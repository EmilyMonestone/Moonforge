import 'package:moonforge/core/utils/logger.dart';

/// Base interface for repository operations.
///
/// All repositories should implement this interface or extend [BaseRepository]
/// to gain consistent error handling and logging behaviour.
abstract class IRepository<T, ID> {
  /// Fetch a single entity by its identifier.
  Future<T?> getById(ID id);

  /// Fetch all entities for the repository.
  Future<List<T>> getAll();

  /// Persist a new entity instance and return the stored value.
  Future<T> create(T entity);

  /// Persist changes to an existing entity and return the updated value.
  Future<T> update(T entity);

  /// Delete the entity identified by [id].
  Future<void> delete(ID id);

  /// Watch a single entity for live-updates.
  Stream<T?> watchById(ID id);

  /// Watch all entities for live-updates.
  Stream<List<T>> watchAll();
}

/// Base repository implementation with shared logging/error handling helpers.
abstract class BaseRepository<T, ID> implements IRepository<T, ID> {
  /// Wraps an async repository call with consistent error logging.
  Future<R> handleError<R>(
    Future<R> Function() operation, {
    String? context,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      logger.e(
        'Repository error${context != null ? ' in $context' : ''}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Wraps a stream-producing repository call with consistent error logging.
  Stream<R> handleStreamError<R>(
    Stream<R> Function() operation, {
    String? context,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      logger.e(
        'Repository stream error${context != null ? ' in $context' : ''}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
