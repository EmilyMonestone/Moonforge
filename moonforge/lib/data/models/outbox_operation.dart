import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'outbox_operation.g.dart';

/// Model for tracking pending sync operations
@collection
@JsonSerializable(explicitToJson: true)
class OutboxOperation {
  Id isarId = Isar.autoIncrement;

  /// Collection type (e.g., 'campaigns', 'adventures', 'entities')
  @Index()
  late String collection;

  /// Document ID being modified
  @Index()
  late String docId;

  /// Operation type: 'upsert', 'delete', 'patch'
  late String opType;

  /// Serialized payload (JSON)
  late String payload;

  /// Revision number at the time of operation
  int baseRev = 0;

  /// Timestamp when operation was queued
  late DateTime createdAt;

  /// Number of retry attempts
  @JsonKey(defaultValue: 0)
  int retryCount = 0;

  /// Last error message if sync failed
  String? lastError;

  /// Status: 'pending', 'syncing', 'synced', 'failed'
  @Index()
  @JsonKey(defaultValue: 'pending')
  String status = 'pending';

  OutboxOperation();

  factory OutboxOperation.fromJson(Map<String, dynamic> json) =>
      _$OutboxOperationFromJson(json);

  Map<String, dynamic> toJson() => _$OutboxOperationToJson(this);
}
