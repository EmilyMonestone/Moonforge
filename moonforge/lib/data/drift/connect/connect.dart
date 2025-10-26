/// Conditional export shim for platform-specific database connections
/// 
/// This file exports the correct implementation based on the platform:
/// - web.dart for web (WASM backend)
/// - native.dart for Android, iOS, macOS, Linux, Windows
export 'web.dart' if (dart.library.io) 'native.dart';
