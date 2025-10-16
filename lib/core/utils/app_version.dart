import 'package:package_info_plus/package_info_plus.dart';

/// Utility class for getting app version information
class AppVersion {
  static PackageInfo? _packageInfo;

  /// Initialize the package info
  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// Get the app version
  static String getVersion() {
    return _packageInfo?.version ?? 'Unknown';
  }

  /// Get the app build number
  static String getBuildNumber() {
    return _packageInfo?.buildNumber ?? 'Unknown';
  }

  /// Get the full version string (version+buildNumber)
  static String getFullVersion() {
    final version = getVersion();
    final buildNumber = getBuildNumber();
    return '$version ($buildNumber)';
  }
}
