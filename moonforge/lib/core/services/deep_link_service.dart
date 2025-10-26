/// Deep link handling service for Moonforge.
///
/// This service integrates with app_links to handle deep links from all platforms
/// (web, Android, iOS, macOS, Windows, Linux) and routes them through go_router.
///
/// Supported deep link format: moonforge://campaign/[id]
library;

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Service for handling deep links across all platforms.
class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService _instance = DeepLinkService._();
  static DeepLinkService get instance => _instance;

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link handling with a GoRouter instance.
  ///
  /// This should be called once during app initialization.
  Future<void> initialize(GoRouter router) async {
    // Handle initial link (when app is launched from a deep link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        _handleDeepLink(initialUri, router);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }

    // Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('Received deep link: $uri');
        _handleDeepLink(uri, router);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  /// Process a deep link URI and navigate using go_router.
  void _handleDeepLink(Uri uri, GoRouter router) {
    // Expected format: moonforge://campaign/[id]
    // or moonforge://party/[id]
    // etc.

    if (uri.scheme != 'moonforge') {
      debugPrint('Unsupported scheme: ${uri.scheme}');
      return;
    }

    // Parse the path
    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) {
      // Navigate to home if no path specified
      router.go('/');
      return;
    }

    // Route based on the first path segment
    final type = pathSegments.first;
    
    switch (type) {
      case 'campaign':
        if (pathSegments.length > 1) {
          // Navigate to specific campaign
          // For now, just navigate to campaign root since we need more context
          router.go('/campaign');
        } else {
          router.go('/campaign');
        }
        break;
      
      case 'party':
        if (pathSegments.length > 1) {
          final partyId = pathSegments[1];
          router.go('/party/$partyId');
        } else {
          router.go('/party');
        }
        break;
      
      case 'settings':
        router.go('/settings');
        break;
      
      default:
        // Unknown path, navigate to home
        debugPrint('Unknown deep link path: $type');
        router.go('/');
    }
  }

  /// Dispose of the service and cleanup resources.
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}
