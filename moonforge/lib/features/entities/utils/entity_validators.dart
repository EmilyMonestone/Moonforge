/// Validation utilities for entity data
class EntityValidators {
  EntityValidators._();

  /// Validate entity name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entity name is required';
    }
    if (value.length > 100) {
      return 'Entity name must be less than 100 characters';
    }
    return null;
  }

  /// Validate entity kind
  static String? validateKind(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entity kind is required';
    }
    final validKinds = [
      'npc',
      'monster',
      'group',
      'place',
      'item',
      'handout',
      'journal',
    ];
    if (!validKinds.contains(value)) {
      return 'Invalid entity kind';
    }
    return null;
  }

  /// Validate entity summary
  static String? validateSummary(String? value) {
    if (value != null && value.length > 500) {
      return 'Summary must be less than 500 characters';
    }
    return null;
  }

  /// Validate tag name
  static String? validateTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag cannot be empty';
    }
    if (value.length > 50) {
      return 'Tag must be less than 50 characters';
    }
    // Tags should not contain special characters
    if (!RegExp(r'^[a-zA-Z0-9\-_\s]+$').hasMatch(value)) {
      return 'Tag can only contain letters, numbers, spaces, hyphens, and underscores';
    }
    return null;
  }

  /// Validate place type
  static String? validatePlaceType(String? value) {
    if (value != null && value.length > 50) {
      return 'Place type must be less than 50 characters';
    }
    return null;
  }

  /// Check if entity has required fields for its kind
  static bool hasRequiredFieldsForKind(String kind, Map<String, dynamic> data) {
    switch (kind) {
      case 'place':
        // Places should have a place type
        return data.containsKey('placeType') && data['placeType'] != null;
      case 'group':
        // Groups can have members but it's optional
        return true;
      case 'npc':
      case 'monster':
        // NPCs and monsters can have statblocks but it's optional
        return true;
      default:
        return true;
    }
  }
}
