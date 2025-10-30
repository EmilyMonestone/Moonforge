import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service for Firestore remote operations
class FirestoreRemote {
  final FirebaseFirestore _firestore;

  FirestoreRemote(this._firestore);

  /// Get a document
  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String docId,
  ) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (!doc.exists) return null;
      
      final data = doc.data();
      if (data == null) return null;
      
      // Add server timestamp if available
      data['_serverTimestamp'] = doc.metadata.hasPendingWrites 
          ? null 
          : FieldValue.serverTimestamp();
      
      return data;
    } catch (e, st) {
      logger.e('Failed to get document $collection/$docId', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Create or update a document with server timestamp
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      final dataWithTimestamp = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (!merge) {
        dataWithTimestamp['createdAt'] = data['createdAt'] ?? FieldValue.serverTimestamp();
      }
      
      await _firestore
          .collection(collection)
          .doc(docId)
          .set(dataWithTimestamp, SetOptions(merge: merge));
      
      logger.d('Set document $collection/$docId');
    } catch (e, st) {
      logger.e('Failed to set document $collection/$docId', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Update specific fields with server timestamp
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final updatesWithTimestamp = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _firestore
          .collection(collection)
          .doc(docId)
          .update(updatesWithTimestamp);
      
      logger.d('Updated document $collection/$docId');
    } catch (e, st) {
      logger.e('Failed to update document $collection/$docId', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      logger.d('Deleted document $collection/$docId');
    } catch (e, st) {
      logger.e('Failed to delete document $collection/$docId', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Query documents with pagination
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    String? fieldPath,
    dynamic isEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    String? orderByField,
    bool descending = false,
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      // Apply filters
      if (fieldPath != null) {
        if (isEqualTo != null) {
          query = query.where(fieldPath, isEqualTo: isEqualTo);
        }
        if (arrayContains != null) {
          query = query.where(fieldPath, arrayContains: arrayContains);
        }
        if (arrayContainsAny != null) {
          query = query.where(fieldPath, arrayContainsAny: arrayContainsAny);
        }
        if (whereIn != null) {
          query = query.where(fieldPath, whereIn: whereIn);
        }
      }

      // Apply ordering
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      // Apply pagination
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e, st) {
      logger.e('Failed to query $collection', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Listen to document changes
  Stream<Map<String, dynamic>?> watchDocument(
    String collection,
    String docId,
  ) {
    return _firestore
        .collection(collection)
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return {
        'id': snapshot.id,
        ...data,
      };
    });
  }

  /// Listen to collection changes
  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection, {
    String? fieldPath,
    dynamic arrayContains,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    if (fieldPath != null && arrayContains != null) {
      query = query.where(fieldPath, arrayContains: arrayContains);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  /// Batch write operations
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();

      for (final op in operations) {
        final docRef = _firestore.collection(op.collection).doc(op.docId);
        
        switch (op.type) {
          case BatchOperationType.set:
            batch.set(docRef, {
              ...op.data!,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            break;
          case BatchOperationType.update:
            batch.update(docRef, {
              ...op.data!,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            break;
          case BatchOperationType.delete:
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
      logger.d('Batch write completed: ${operations.length} operations');
    } catch (e, st) {
      logger.e('Batch write failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// Batch operation type
enum BatchOperationType { set, update, delete }

/// Batch operation definition
class BatchOperation {
  final BatchOperationType type;
  final String collection;
  final String docId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collection,
    required this.docId,
    this.data,
  });

  factory BatchOperation.set(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) {
    return BatchOperation(
      type: BatchOperationType.set,
      collection: collection,
      docId: docId,
      data: data,
    );
  }

  factory BatchOperation.update(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) {
    return BatchOperation(
      type: BatchOperationType.update,
      collection: collection,
      docId: docId,
      data: data,
    );
  }

  factory BatchOperation.delete(String collection, String docId) {
    return BatchOperation(
      type: BatchOperationType.delete,
      collection: collection,
      docId: docId,
    );
  }
}
