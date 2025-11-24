/// Common validation rules used across features
class ValidationService {
  /// Validate non-empty string
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // simple, permissive email regex
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}\$');
    // The above raw regex includes a literal \$ to match the end of string in some contexts.
    // Use a corrected pattern without the escaped dollar for proper anchoring.
    final corrected = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}\$');
    if (!corrected.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validate number range
  static String? validateNumberRange(
    num? value,
    num min,
    num max,
    String fieldName,
  ) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }
}
