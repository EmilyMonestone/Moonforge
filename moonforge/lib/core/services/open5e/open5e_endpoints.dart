/// Open5e API v2 endpoint configuration
///
/// Defines all available Open5e API v2 endpoints with their base URLs.
/// All endpoints use the v2 API with gamesystem filtering support.
class Open5eEndpoints {
  static const String baseUrl = 'https://api.open5e.com/v2';
  
  /// Default gamesystem to use for filtering
  static const String defaultGameSystem = '5e-2024';
  
  // Core content endpoints
  static const String items = '$baseUrl/items/?format=api';
  static const String magicItems = '$baseUrl/magicitems/?format=api';
  static const String itemSets = '$baseUrl/itemsets/?format=api';
  static const String itemCategories = '$baseUrl/itemcategories/?format=api';
  static const String itemRarities = '$baseUrl/itemrarities/?format=api';
  static const String weapons = '$baseUrl/weapons/?format=api';
  static const String weaponProperties = '$baseUrl/weaponproperties/?format=api';
  static const String armor = '$baseUrl/armor/?format=api';
  
  // Character options
  static const String backgrounds = '$baseUrl/backgrounds/?format=api';
  static const String feats = '$baseUrl/feats/?format=api';
  static const String species = '$baseUrl/species/?format=api';
  static const String classes = '$baseUrl/classes/?format=api';
  static const String abilities = '$baseUrl/abilities/?format=api';
  static const String skills = '$baseUrl/skills/?format=api';
  
  // Creatures
  static const String creatures = '$baseUrl/creatures/?format=api';
  static const String creatureTypes = '$baseUrl/creaturetypes/?format=api';
  static const String creatureSets = '$baseUrl/creaturesets/?format=api';
  
  // Spells
  static const String spells = '$baseUrl/spells/?format=api';
  static const String spellSchools = '$baseUrl/spellschools/?format=api';
  
  // Game mechanics
  static const String conditions = '$baseUrl/conditions/?format=api';
  static const String damageTypes = '$baseUrl/damagetypes/?format=api';
  static const String languages = '$baseUrl/languages/?format=api';
  static const String alignments = '$baseUrl/alignments/?format=api';
  static const String sizes = '$baseUrl/sizes/?format=api';
  static const String environments = '$baseUrl/environments/?format=api';
  
  // Rules and documentation
  static const String documents = '$baseUrl/documents/?format=api';
  static const String licenses = '$baseUrl/licenses/?format=api';
  static const String publishers = '$baseUrl/publishers/?format=api';
  static const String gameSystems = '$baseUrl/gamesystems/?format=api';
  static const String rules = '$baseUrl/rules/?format=api';
  static const String ruleSets = '$baseUrl/rulesets/?format=api';
  
  // Media
  static const String images = '$baseUrl/images/?format=api';
  static const String services = '$baseUrl/services/?format=api';
  
  /// Get endpoint URL by resource name
  static String? getEndpoint(String resourceName) {
    switch (resourceName) {
      case 'items':
        return items;
      case 'magicitems':
        return magicItems;
      case 'itemsets':
        return itemSets;
      case 'itemcategories':
        return itemCategories;
      case 'itemrarities':
        return itemRarities;
      case 'weapons':
        return weapons;
      case 'weaponproperties':
        return weaponProperties;
      case 'armor':
        return armor;
      case 'backgrounds':
        return backgrounds;
      case 'feats':
        return feats;
      case 'species':
        return species;
      case 'classes':
        return classes;
      case 'abilities':
        return abilities;
      case 'skills':
        return skills;
      case 'creatures':
        return creatures;
      case 'creaturetypes':
        return creatureTypes;
      case 'creaturesets':
        return creatureSets;
      case 'spells':
        return spells;
      case 'spellschools':
        return spellSchools;
      case 'conditions':
        return conditions;
      case 'damagetypes':
        return damageTypes;
      case 'languages':
        return languages;
      case 'alignments':
        return alignments;
      case 'sizes':
        return sizes;
      case 'environments':
        return environments;
      case 'documents':
        return documents;
      case 'licenses':
        return licenses;
      case 'publishers':
        return publishers;
      case 'gamesystems':
        return gameSystems;
      case 'rules':
        return rules;
      case 'rulesets':
        return ruleSets;
      case 'images':
        return images;
      case 'services':
        return services;
      default:
        return null;
    }
  }
}
