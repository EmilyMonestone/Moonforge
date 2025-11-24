import 'package:equatable/equatable.dart';

/// Base class for typed repository errors.
abstract class RepositoryError extends Equatable implements Exception {
  final String message;
  final Object? cause;

  const RepositoryError(this.message, [this.cause]);

  @override
  List<Object?> get props => <Object?>[message, cause];

  @override
  String toString() =>
      'RepositoryError: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class EntityNotFoundError extends RepositoryError {
  final Object id;

  const EntityNotFoundError(this.id) : super('Entity with ID $id not found');

  @override
  List<Object?> get props => <Object?>[id, message, cause];
}

class DuplicateEntityError extends RepositoryError {
  const DuplicateEntityError(String message) : super(message);
}

class RepositoryValidationError extends RepositoryError {
  final Map<String, String> fieldErrors;

  RepositoryValidationError(this.fieldErrors)
    : super(
        'Validation failed: ${fieldErrors.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
      );

  @override
  List<Object?> get props => <Object?>[fieldErrors, message, cause];
}

class ConflictError extends RepositoryError {
  const ConflictError(String message) : super(message);
}
