import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides access to Firebase Firestore instance
/// ```dart
/// final firestore = FirebaseFirestore.instance;
/// Odm.init(firestore); // Initialize once (e.g., in main)
/// final firestore = Odm.instance; // Access anywhere
/// ```
class Odm {
  static FirebaseFirestore? _instance;

  static Future<FirebaseFirestore> init(
    FirebaseFirestore firestore,
  ) async {
    if (_instance != null) return _instance!;
    _instance = firestore;
    return firestore;
  }

  /// check if Odm is initialized
  static bool get isInitialized => _instance != null;

  /// global access to the initialized Firestore instance
  /// throws StateError if not initialized
  static FirebaseFirestore get instance {
    final firestore = _instance;
    if (firestore == null) {
      throw StateError(
        'Odm.init(...) must be called before accessing Odm.instance.',
      );
    }
    return firestore;
  }
}
