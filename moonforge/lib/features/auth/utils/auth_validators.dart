/// Validation utilities for authentication forms.
///
/// Provides reusable validators for email, password, and other auth-related
/// fields with consistent error messages.
class AuthValidators {
  AuthValidators._();

  /// Validates email format.
  ///
  /// Returns null if valid, error message if invalid.
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }
    // Basic email pattern - sufficient for most cases
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password strength.
  ///
  /// Returns null if valid, error message if invalid.
  /// Requires minimum 6 characters as per Firebase Auth default.
  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates password confirmation matches.
  ///
  /// [password] is the original password to match against.
  /// Returns null if valid, error message if invalid.
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates display name.
  ///
  /// Returns null if valid, error message if invalid.
  static String? validateDisplayName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Display name is required';
    }
    if (name.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    if (name.length > 50) {
      return 'Display name must be less than 50 characters';
    }
    return null;
  }

  /// Checks if a password meets strength requirements.
  ///
  /// Returns a score from 0 (weak) to 4 (strong).
  static int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    return score > 4 ? 4 : score;
  }

  /// Gets a human-readable description of password strength.
  static String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Very Weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }
}
