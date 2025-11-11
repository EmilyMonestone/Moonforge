import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/utils/logger.dart';

import '../app_db.dart';
import '../firestore_mappers.dart';

/// Processes outbox entries and pushes them to Firestore
class OutboxProcessor {
  final AppDb _db;
  final FirebaseFirestore _firestore;

  OutboxProcessor(this._db, this._firestore);

  /// Flush all pending outbox entries to Firestore
  Future<void> flush() async {
    final items = await _db.outboxDao.getAllPending();

    for (final item in items) {
      try {
        await _processEntry(item);
        await _db.outboxDao.removeById(item.id);
      } catch (e) {
        // Log error but continue processing other entries
        logger.e('Error processing outbox entry ${item.id}: $e');
      }
    }
  }

  Future<void> _processEntry(OutboxEntry entry) async {
    final doc = _firestore.collection(entry.table).doc(entry.rowId);

    if (entry.op == 'delete') {
      // Soft delete
      await doc.update({
        'deleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
        'rev': FieldValue.increment(1),
      });
    } else if (entry.op == 'upsert') {
      // Load current local row and map to Firestore
      final map = await _loadAndMapRow(entry.table, entry.rowId);
      if (map != null) {
        await doc.set(map, SetOptions(merge: true));
      }
    }
  }

  Future<Map<String, Object?>?> _loadAndMapRow(
    String table,
    String rowId,
  ) async {
    switch (table) {
      case 'campaigns':
        final row = await _db.campaignDao.getById(rowId);
        return row != null ? campaignToFirestore(row) : null;
      case 'chapters':
        final row = await _db.chapterDao.getById(rowId);
        return row != null ? chapterToFirestore(row) : null;
      case 'adventures':
        final row = await _db.adventureDao.getById(rowId);
        return row != null ? adventureToFirestore(row) : null;
      case 'scenes':
        final row = await _db.sceneDao.getById(rowId);
        return row != null ? sceneToFirestore(row) : null;
      case 'parties':
        final row = await _db.partyDao.getById(rowId);
        return row != null ? partyToFirestore(row) : null;
      case 'encounters':
        final row = await _db.encounterDao.getById(rowId);
        return row != null ? encounterToFirestore(row) : null;
      case 'entities':
        final row = await _db.entityDao.getById(rowId);
        return row != null ? entityToFirestore(row) : null;
      case 'mediaAssets':
        final row = await _db.mediaAssetDao.getById(rowId);
        return row != null ? mediaAssetToFirestore(row) : null;
      case 'sessions':
        final row = await _db.sessionDao.getById(rowId);
        return row != null ? sessionToFirestore(row) : null;
      case 'players':
        final row = await _db.playerDao.getById(rowId);
        return row != null ? playerToFirestore(row) : null;
      default:
        return null;
    }
  }
}
