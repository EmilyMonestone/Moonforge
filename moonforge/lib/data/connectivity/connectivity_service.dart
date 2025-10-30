import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  Stream<bool>? _connectivityStream;
  bool _isOnline = false;
  
  /// Stream of connectivity status (true = online, false = offline)
  Stream<bool> get connectivityStream {
    _connectivityStream ??= _connectivity.onConnectivityChanged
        .map((results) {
          // ConnectivityResult list; online if any connection is not 'none'
          final isOnline = results.isNotEmpty && 
              results.any((result) => result != ConnectivityResult.none);
          _isOnline = isOnline;
          return isOnline;
        })
        .asBroadcastStream();
    return _connectivityStream!;
  }
  
  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final isOnline = results.isNotEmpty && 
        results.any((result) => result != ConnectivityResult.none);
    _isOnline = isOnline;
    return isOnline;
  }
  
  /// Get last known connectivity status (cached)
  bool get isOnline => _isOnline;
}
