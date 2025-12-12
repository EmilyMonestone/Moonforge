/// Open5e API v2 endpoint configuration
///
/// Defines all available Open5e API v2 endpoints with their base URLs.
/// All endpoints use the v2 API with gamesystem filtering support.
class Open5eEndpoints {
  static const String baseUrl = 'https://api.open5e.com/v2';
  
  /// Default gamesystem to use for filtering
  static const String defaultGameSystem = '5e-2024';
  
  // Core content endpoints
  static const String items = '$baseUrl/items/';
  static const String magicItems = '$baseUrl/magicitems/';
  static const String itemSets = '$baseUrl/itemsets/';
  static const String itemCategories = '$baseUrl/itemcategories/';
  static const String itemRarities = '$baseUrl/itemrarities/';
  static const String weapons = '$baseUrl/weapons/';
  static const String weaponProperties = '$baseUrl/weaponproperties/';
  static const String armor = '$baseUrl/armor/';
  
  // Character options
  static const String backgrounds = '$baseUrl/backgrounds/';
  static const String feats = '$baseUrl/feats/';
  static const String species = '$baseUrl/species/';
  static const String classes = '$baseUrl/classes/';
  static const String abilities = '$baseUrl/abilities/';
  static const String skills = '$baseUrl/skills/';
  
  // Creatures
  static const String creatures = '$baseUrl/creatures/';
  static const String creatureTypes = '$baseUrl/creaturetypes/';
  static const String creatureSets = '$baseUrl/creaturesets/';
  
  // Spells
  static const String spells = '$baseUrl/spells/';
  static const String spellSchools = '$baseUrl/spellschools/';
  
  // Game mechanics
  static const String conditions = '$baseUrl/conditions/';
  static const String damageTypes = '$baseUrl/damagetypes/';
  static const String languages = '$baseUrl/languages/';
  static const String alignments = '$baseUrl/alignments/';
  static const String sizes = '$baseUrl/sizes/';
  static const String environments = '$baseUrl/environments/';
  
  // Rules and documentation
  static const String documents = '$baseUrl/documents/';
  static const String licenses = '$baseUrl/licenses/';
  static const String publishers = '$baseUrl/publishers/';
  static const String gameSystems = '$baseUrl/gamesystems/';
  static const String rules = '$baseUrl/rules/';
  static const String ruleSets = '$baseUrl/rulesets/';
  
  // Media
  static const String images = '$baseUrl/images/';
  static const String services = '$baseUrl/services/';
  
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
