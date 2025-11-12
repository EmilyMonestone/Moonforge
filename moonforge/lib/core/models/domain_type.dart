/// Enumeration of all domain types in the Moonforge application.
///
/// This enum provides a type-safe way to reference different domain entities
/// throughout the application. Each type represents a major concept in the
/// tabletop RPG campaign management system.
enum DomainType {
  /// A campaign - the top-level container for a tabletop RPG adventure
  campaign,

  /// A chapter - a major section within a campaign
  chapter,

  /// An adventure - a specific quest or story arc within a chapter
  adventure,

  /// A scene - a specific encounter or moment within an adventure
  scene,

  /// A session - a playing session with notes and logs
  session,

  /// A party - a group of player characters
  party,

  /// An encounter - a combat or challenge scenario
  encounter,

  /// A player - a player character with stats and details
  player,

  /// A combatant - a participant in an encounter (PC, NPC, or monster)
  combatant,

  /// A media asset - an image, audio, or other media file
  mediaAsset,

  // Entity kinds - different types of entities in the game world
  
  /// An NPC (Non-Player Character) entity
  entityNpc,

  /// A monster entity
  entityMonster,

  /// A group entity (faction, organization, etc.)
  entityGroup,

  /// A place entity (location, building, etc.)
  entityPlace,

  /// An item entity (weapon, artifact, etc.)
  entityItem,

  /// A handout entity (document, letter, etc.)
  entityHandout,

  /// A journal entity (lore, notes, etc.)
  entityJournal,

  /// A generic entity (fallback for unknown types)
  entityGeneric,
}
