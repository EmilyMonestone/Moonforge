import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service for handling automatic updates on desktop platforms.
/// 
/// Uses the auto_updater package which is based on:
/// - Sparkle for macOS
/// - WinSparkle for Windows
/// 
/// For updates to work, you need to:
/// 1. Publish releases to GitHub with properly formatted release assets
/// 2. Include an appcast.xml file (macOS) or appcast.json file (Windows)
/// 3. Sign your application (especially important for macOS)
class AutoUpdaterService {
  AutoUpdaterService._();
  
  static final AutoUpdaterService instance = AutoUpdaterService._();
  
  /// The base URL for the appcast feed
  /// This should point to a publicly accessible URL where the appcast file is hosted
  /// 
  /// For GitHub releases, you can use GitHub Pages or a raw GitHub URL
  /// Example: https://yourusername.github.io/yourrepo/appcast.xml
  static const String _feedURLBase = 'https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast';
  
  bool _initialized = false;
  
  /// Initialize the auto updater service
  /// 
  /// This should be called early in the app lifecycle, typically in main()
  /// or during app initialization.
  Future<void> initialize() async {
    if (_initialized) {
      logger.i('AutoUpdater already initialized');
      return;
    }
    
    // Auto updater only works on desktop platforms (Windows and macOS)
    if (kIsWeb || !(Platform.isWindows || Platform.isMacOS)) {
      logger.i('AutoUpdater not supported on this platform');
      return;
    }
    
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      logger.i('Initializing AutoUpdater for version $currentVersion');
      
      // Determine the feed URL based on the platform
      String feedURL;
      if (Platform.isMacOS) {
        feedURL = '$_feedURLBase/appcast.xml';
      } else if (Platform.isWindows) {
        feedURL = '$_feedURLBase/appcast.json';
      } else {
        logger.w('AutoUpdater not supported on ${Platform.operatingSystem}');
        return;
      }
      
      logger.i('Setting feed URL to: $feedURL');
      
      // Set the feed URL
      await autoUpdater.setFeedURL(feedURL);
      
      // Check for updates every 24 hours (86400 seconds)
      // You can adjust this interval or set it to 0 to disable automatic checks
      await autoUpdater.setScheduledCheckInterval(86400);
      
      _initialized = true;
      logger.i('AutoUpdater initialized successfully');
    } catch (e, stackTrace) {
      logger.e('Failed to initialize AutoUpdater', error: e, stackTrace: stackTrace);
    }
  }
  
  /// Manually check for updates
  /// 
  /// This can be triggered by a user action, such as clicking a "Check for Updates" button
  Future<void> checkForUpdates() async {
    if (!_initialized) {
      logger.w('AutoUpdater not initialized. Call initialize() first.');
      return;
    }
    
    try {
      logger.i('Manually checking for updates...');
      await autoUpdater.checkForUpdates();
    } catch (e, stackTrace) {
      logger.e('Failed to check for updates', error: e, stackTrace: stackTrace);
    }
  }
  
  /// Set the interval for automatic update checks
  /// 
  /// [interval] The interval in seconds. Minimum is 3600 (1 hour).
  ///            Set to 0 to disable automatic checks.
  ///            Default is 86400 (24 hours).
  Future<void> setCheckInterval(int interval) async {
    if (!_initialized) {
      logger.w('AutoUpdater not initialized. Call initialize() first.');
      return;
    }
    
    try {
      await autoUpdater.setScheduledCheckInterval(interval);
      logger.i('Update check interval set to $interval seconds');
    } catch (e, stackTrace) {
      logger.e('Failed to set check interval', error: e, stackTrace: stackTrace);
    }
  }
}
