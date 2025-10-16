import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_odm/firestore_odm.dart';

/// Initialize Firestore ODM
/// ```dart
/// final firestore = FirebaseFirestore.instance;
/// await Odm.init(appSchema, firestore); // einmalig (z. B. in main)
/// final odm = Odm.instance;             // überall abrufen
/// ```
class Odm {
  static FirestoreODM? _instance;

  static Future<FirestoreODM> init(
    FirestoreSchema appSchema,
    FirebaseFirestore firestore,
  ) async {
    if (_instance != null) return _instance!;
    final odm = FirestoreODM(appSchema, firestore: firestore);
    _instance = odm;
    return odm;
  }

  /// check if ODM is initialized
  static bool get isInitialized => _instance != null;

  /// global access to the initialized ODM instance
  /// throws StateError if not initialized
  static FirestoreODM get instance {
    final odm = _instance;
    if (odm == null) {
      throw StateError(
        'Odm.init(...) muss vor dem Zugriff auf Odm.instance aufgerufen werden.',
      );
    }
    return odm;
  }
}
