import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// A utility class for autosaving Quill editor content
/// 
/// Usage:
/// ```dart
/// final autosave = QuillAutosave(
///   controller: _quillController,
///   storageKey: 'campaign_${campaignId}_content',
///   onSave: (content) async {
///     // Optional: Save to remote storage
///     await saveToCampaign(content);
///   },
/// );
/// 
/// // Start autosaving
/// autosave.start();
/// 
/// // Stop autosaving when done
/// autosave.dispose();
/// ```
class QuillAutosave {
  final QuillController controller;
  final String storageKey;
  final Duration delay;
  final Future<void> Function(String content)? onSave;
  final VoidCallback? onError;
  
  final PersistenceService _persistence = PersistenceService();
  Timer? _debounceTimer;
  String? _lastSavedContent;
  bool _isDisposed = false;

  QuillAutosave({
    required this.controller,
    required this.storageKey,
    this.delay = const Duration(seconds: 2),
    this.onSave,
    this.onError,
  }) {
    _loadFromStorage();
  }

  /// Start listening to document changes and autosave
  void start() {
    controller.document.changes.listen(_onDocumentChange);
    logger.i('QuillAutosave started for key: $storageKey');
  }

  /// Load previously saved content from storage
  void _loadFromStorage() {
    try {
      final savedContent = _persistence.read<String>(storageKey);
      if (savedContent != null && savedContent.isNotEmpty) {
        // Parse the saved Delta JSON and restore it
        final deltaJson = jsonDecode(savedContent);
        final document = Document.fromJson(deltaJson);
        controller.document = document;
        _lastSavedContent = savedContent;
        logger.i('Loaded autosaved content for key: $storageKey');
      }
    } catch (e) {
      logger.e('Failed to load autosaved content: $e');
      onError?.call();
    }
  }

  /// Handle document changes
  void _onDocumentChange(DocChange change) {
    if (_isDisposed) return;
    
    // Cancel previous timer if exists
    _debounceTimer?.cancel();
    
    // Start new timer
    _debounceTimer = Timer(delay, _save);
  }

  /// Save the current document content
  Future<void> _save() async {
    if (_isDisposed) return;

    try {
      // Convert document to Delta JSON
      final delta = controller.document.toDelta();
      final content = jsonEncode(delta.toJson());
      
      // Don't save if content hasn't changed
      if (content == _lastSavedContent) {
        return;
      }

      // Save to local storage
      await _persistence.write(storageKey, content);
      _lastSavedContent = content;
      
      logger.d('Autosaved content for key: $storageKey');

      // Call optional save callback
      if (onSave != null) {
        await onSave!(content);
      }
    } catch (e) {
      logger.e('Failed to autosave content: $e');
      onError?.call();
    }
  }

  /// Manually trigger a save (useful for explicit save operations)
  Future<void> saveNow() async {
    _debounceTimer?.cancel();
    await _save();
  }

  /// Clear the autosaved content from storage
  Future<void> clear() async {
    try {
      await _persistence.remove(storageKey);
      _lastSavedContent = null;
      logger.i('Cleared autosaved content for key: $storageKey');
    } catch (e) {
      logger.e('Failed to clear autosaved content: $e');
    }
  }

  /// Check if there's autosaved content available
  bool hasAutosavedContent() {
    return _persistence.hasData(storageKey);
  }

  /// Get the autosaved content without loading it into the controller
  String? getAutosavedContent() {
    return _persistence.read<String>(storageKey);
  }

  /// Dispose of resources
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    logger.i('QuillAutosave disposed for key: $storageKey');
  }
}
