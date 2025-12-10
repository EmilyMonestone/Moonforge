import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utility for layout branching.
///
/// Provides a clear distinction between mobile-style platforms
/// (Android, iOS, Fuchsia) and desktop platforms (Windows, macOS, Linux, Web).
class PlatformDetector {
  /// Returns true if running on a mobile-style platform (Android, iOS, or Fuchsia).
  ///
  /// Mobile platforms typically use touch-first interactions and have different
  /// UI patterns compared to desktop platforms.
  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
  }

  /// Returns true if running on a desktop-style platform
  /// (Windows, macOS, Linux, or Web).
  ///
  /// Desktop platforms typically use mouse/keyboard interactions and have
  /// different UI patterns compared to mobile platforms.
  static bool get isDesktopPlatform {
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }
}
