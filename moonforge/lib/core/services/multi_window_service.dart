import 'dart:io';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service to handle opening routes in new windows across different platforms.
///
/// Supports:
/// - Web: Opens routes in new browser tabs using url_launcher
/// - Desktop (Windows/Linux): Opens native windows using desktop_multi_window
/// - Other platforms: Falls back to no-op (mobile doesn't support multi-window)
class MultiWindowService {
  MultiWindowService._();

  static final MultiWindowService instance = MultiWindowService._();

  /// Opens the specified route in a new window.
  ///
  /// [route] - The route path to open (e.g., '/campaign/entity/123')
  ///
  /// Returns true if the window was opened successfully, false otherwise.
  Future<bool> openRouteInNewWindow(String route) async {
    if (kIsWeb) {
      return _openInNewTab(route);
    } else if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      return _openInDesktopWindow(route);
    }
    // Mobile and unsupported platforms
    return false;
  }

  /// Opens a route in a new browser tab (web only).
  Future<bool> _openInNewTab(String route) async {
    try {
      // Get the current origin (protocol + host + port)
      final currentUrl = Uri.base;
      final newUrl = Uri(
        scheme: currentUrl.scheme,
        host: currentUrl.host,
        port: currentUrl.port,
        path: route,
      );

      final uri = Uri.parse(newUrl.toString());
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, webOnlyWindowName: '_blank');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens a route in a new desktop window (Windows/Linux only).
  Future<bool> _openInDesktopWindow(String route) async {
    try {
      // Pass the route as the argument string to the new window
      final window = await DesktopMultiWindow.createWindow(route);

      window
        ..setFrame(const Offset(100, 100) & const Size(1000, 800))
        ..center()
        ..setTitle('Moonforge')
        ..show();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if multi-window is supported on the current platform.
  bool get isSupported {
    if (kIsWeb) {
      return true;
    }
    // For non-web platforms, check if it's Windows or Linux
    return !kIsWeb && (Platform.isWindows || Platform.isLinux);
  }
}
