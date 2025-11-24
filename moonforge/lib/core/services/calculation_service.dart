import 'dart:math';

/// Common calculation utilities
class CalculationService {
  /// Calculate percentage (0-100)
  static double percentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate average
  static double average(List<num> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Round to decimals
  static double roundTo(double value, int decimals) {
    final mod = pow(10.0, decimals);
    return ((value * mod).round().toDouble() / mod);
  }
}
