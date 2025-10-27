import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for syncing files with Firebase Storage
/// Handles downloads, uploads, caching, and retry logic
class StorageSyncService {
  final AppDatabase _db;
  final FirebaseStorage _storage;
  Timer? _processingTimer;
  bool _isProcessing = false;
  
  /// Cache directory for downloaded files
  Directory? _cacheDir;

  StorageSyncService(this._db, this._storage);

  /// Initialize the service
  Future<void> initialize() async {
    if (!kIsWeb) {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory(p.join(appDir.path, 'media_cache'));
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }
    }
  }

  /// Start processing the storage queue
  void start() {
    _processingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isProcessing) {
        _processQueue();
      }
    });
  }

  /// Stop processing
  void stop() {
    _processingTimer?.cancel();
  }

  /// Enqueue a download for a media asset
  Future<void> enqueueDownload({
    required String assetId,
    required String storagePath,
    required String mimeType,
    int? fileSize,
    int priority = 0,
  }) async {
    await _db.storageQueueDao.enqueueDownload(
      storagePath: storagePath,
      assetId: assetId,
      mimeType: mimeType,
      fileSize: fileSize,
      priority: priority,
    );
  }

  /// Enqueue an upload for a local file
  Future<void> enqueueUpload({
    required String localPath,
    required String storagePath,
    String? assetId,
    required String mimeType,
    int? fileSize,
    int priority = 0,
  }) async {
    await _db.storageQueueDao.enqueueUpload(
      localPath: localPath,
      storagePath: storagePath,
      assetId: assetId,
      mimeType: mimeType,
      fileSize: fileSize,
      priority: priority,
    );
  }

  /// Process next item in the queue
  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final op = await _db.storageQueueDao.nextOp();
      if (op == null) return;

      if (op.opType == 'download') {
        await _processDownload(op);
      } else if (op.opType == 'upload') {
        await _processUpload(op);
      }
    } catch (e) {
      debugPrint('⚠️ Storage queue processing error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Process a download operation
  Future<void> _processDownload(StorageQueueData op) async {
    try {
      await _db.storageQueueDao.updateStatus(op.id, 'in_progress');

      if (kIsWeb) {
        // Web: Get download URL for browser caching
        final ref = _storage.ref(op.storagePath);
        final downloadUrl = await ref.getDownloadURL();

        // Update metadata with download URL
        if (op.assetId != null) {
          await _db.mediaAssetsDao.updateDownloadStatus(
            'media_assets',
            op.assetId!,
            status: 'cached',
            localPath: downloadUrl,
            cacheExpiry: DateTime.now().add(const Duration(days: 7)),
          );
        }

        await _db.storageQueueDao.updateStatus(op.id, 'completed');
        await _db.storageQueueDao.remove(op.id);
      } else {
        // Mobile/Desktop: Download to local filesystem
        final ref = _storage.ref(op.storagePath);
        final fileName = p.basename(op.storagePath);
        final localFile = File(p.join(_cacheDir!.path, fileName));

        final downloadTask = ref.writeToFile(localFile);

        // Track progress
        downloadTask.snapshotEvents.listen((snapshot) async {
          final progress =
              (snapshot.bytesTransferred / snapshot.totalBytes * 100).round();
          await _db.storageQueueDao.updateProgress(op.id, progress);
        });

        await downloadTask;

        // Update metadata
        if (op.assetId != null) {
          await _db.mediaAssetsDao.updateDownloadStatus(
            'media_assets',
            op.assetId!,
            status: 'cached',
            localPath: localFile.path,
            cacheExpiry: DateTime.now().add(const Duration(days: 30)),
          );
        }

        await _db.storageQueueDao.updateStatus(op.id, 'completed');
        await _db.storageQueueDao.remove(op.id);
      }
    } catch (e) {
      debugPrint('⚠️ Download failed for ${op.storagePath}: $e');
      await _db.storageQueueDao.markAttempt(op.id);

      if (op.attempt >= 5) {
        await _db.storageQueueDao.updateStatus(
          op.id,
          'failed',
          errorMessage: e.toString(),
        );
      } else {
        await _db.storageQueueDao.updateStatus(op.id, 'pending');
      }
    }
  }

  /// Process an upload operation
  Future<void> _processUpload(StorageQueueData op) async {
    if (op.localPath == null) {
      await _db.storageQueueDao.updateStatus(
        op.id,
        'failed',
        errorMessage: 'No local path provided',
      );
      return;
    }

    try {
      await _db.storageQueueDao.updateStatus(op.id, 'in_progress');

      final ref = _storage.ref(op.storagePath);
      
      if (kIsWeb) {
        // Web upload would need to be handled differently
        // For now, mark as failed on web
        await _db.storageQueueDao.updateStatus(
          op.id,
          'failed',
          errorMessage: 'Web upload not yet implemented',
        );
        return;
      }

      final file = File(op.localPath!);
      if (!await file.exists()) {
        await _db.storageQueueDao.updateStatus(
          op.id,
          'failed',
          errorMessage: 'Local file not found',
        );
        return;
      }

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: op.mimeType),
      );

      // Track progress
      uploadTask.snapshotEvents.listen((snapshot) async {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes * 100).round();
        await _db.storageQueueDao.updateProgress(op.id, progress);
      });

      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      // Update media asset if linked
      if (op.assetId != null) {
        await _db.mediaAssetsDao.updateDownloadStatus(
          'media_assets',
          op.assetId!,
          status: 'cached',
          localPath: downloadUrl,
        );
      }

      await _db.storageQueueDao.updateStatus(op.id, 'completed');
      await _db.storageQueueDao.remove(op.id);
    } catch (e) {
      debugPrint('⚠️ Upload failed for ${op.storagePath}: $e');
      await _db.storageQueueDao.markAttempt(op.id);

      if (op.attempt >= 5) {
        await _db.storageQueueDao.updateStatus(
          op.id,
          'failed',
          errorMessage: e.toString(),
        );
      } else {
        await _db.storageQueueDao.updateStatus(op.id, 'pending');
      }
    }
  }

  /// Get local path for a media asset (if cached)
  Future<String?> getLocalPath(String assetId) async {
    return await _db.mediaAssetsDao.getLocalPath(assetId);
  }

  /// Check if an asset is cached
  Future<bool> isCached(String assetId) async {
    final status = await _db.mediaAssetsDao.getDownloadStatus(assetId);
    return status == 'cached';
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    // TODO: Implement cache cleanup
    // Query LocalMetas for entries where cacheExpiry < now and delete files
  }
}
