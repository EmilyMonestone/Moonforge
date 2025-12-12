/// Open5e API endpoint configuration
///
/// Defines all available Open5e API endpoints with their base URLs.
/// The API has both v1 and v2 versions of various resources.
class Open5eEndpoints {
  static const String baseUrl = 'https://api.open5e.com';
  
  // Root manifest endpoint that lists all available endpoints
  static const String manifest = '$baseUrl/v1/manifest/';
  
  // Version 1 endpoints
  static const String monsters = '$baseUrl/v1/monsters/';
  static const String spellList = '$baseUrl/v1/spelllist/';
  static const String planes = '$baseUrl/v1/planes/';
  static const String sections = '$baseUrl/v1/sections/';
  static const String races = '$baseUrl/v1/races/';
  static const String classes = '$baseUrl/v1/classes/';
  static const String magicItems = '$baseUrl/v1/magicitems/';
  
  // Version 2 endpoints
  static const String spells = '$baseUrl/v2/spells/';
  static const String documents = '$baseUrl/v2/documents/';
  static const String backgrounds = '$baseUrl/v2/backgrounds/';
  static const String feats = '$baseUrl/v2/feats/';
  static const String conditions = '$baseUrl/v2/conditions/';
  static const String weapons = '$baseUrl/v2/weapons/';
  static const String armor = '$baseUrl/v2/armor/';
  
  /// Get endpoint URL by resource name
  static String? getEndpoint(String resourceName) {
    switch (resourceName) {
      case 'manifest':
        return manifest;
      case 'monsters':
        return monsters;
      case 'spells':
        return spells;
      case 'spelllist':
        return spellList;
      case 'planes':
        return planes;
      case 'sections':
        return sections;
      case 'races':
        return races;
      case 'classes':
        return classes;
      case 'magicitems':
        return magicItems;
      case 'documents':
        return documents;
      case 'backgrounds':
        return backgrounds;
      case 'feats':
        return feats;
      case 'conditions':
        return conditions;
      case 'weapons':
        return weapons;
      case 'armor':
        return armor;
      default:
        return null;
    }
  }
}
