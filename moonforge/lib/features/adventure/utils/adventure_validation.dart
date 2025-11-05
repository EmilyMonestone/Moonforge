import 'package:moonforge/data/db/app_db.dart';

/// Validation utilities for adventures
class AdventureValidation {
  /// Validate adventure data
  static AdventureValidationResult validate(Adventure adventure) {
    final errors = <String>[];

    // Check required fields
    if (adventure.name.trim().isEmpty) {
      errors.add('Adventure name is required');
    }

    if (adventure.chapterId.trim().isEmpty) {
      errors.add('Chapter ID is required');
    }

    // Check order is positive
    if (adventure.order < 1) {
      errors.add('Adventure order must be at least 1');
    }

    // Check name length
    if (adventure.name.length > 200) {
      errors.add('Adventure name is too long (max 200 characters)');
    }

    // Check summary length if present
    if (adventure.summary != null && adventure.summary!.length > 1000) {
      errors.add('Adventure summary is too long (max 1000 characters)');
    }

    return AdventureValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate adventure name
  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.length <= 200;
  }

  /// Validate adventure order
  static bool isValidOrder(int order) {
    return order >= 1;
  }

  /// Check if adventure data has required fields
  static bool hasRequiredFields(Adventure adventure) {
    return adventure.name.trim().isNotEmpty &&
        adventure.chapterId.trim().isNotEmpty &&
        adventure.order >= 1;
  }
}

/// Result of adventure validation
class AdventureValidationResult {
  final bool isValid;
  final List<String> errors;

  AdventureValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Get all errors as a single message
  String get message => errors.join('\n');
}
