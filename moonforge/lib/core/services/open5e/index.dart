/// Open5e API Integration
///
/// A comprehensive, type-safe client for the Open5e API that provides:
/// - Type-safe models for all major Open5e resources
/// - Caching with ETag support
/// - Filtering, searching, and ordering per official API docs
/// - Pagination support
/// - Document filtering (e.g., filter by '5esrd', 'tob')
/// - Easy-to-use service methods
///
/// Usage:
/// ```dart
/// final service = Open5eService(persistenceService);
///
/// // Fetch monsters with Challenge Rating 3 from Tome of Beasts
/// final monsters = await service.getMonsters(
///   options: Open5eQueryOptions(
///     filters: {'cr': '3'},
///     documentSlug: 'tob',
///     ordering: 'name',
///   ),
/// );
///
/// // Search for fire-related spells
/// final fireSpells = await service.getSpells(
///   options: Open5eQueryOptions(search: 'fire'),
/// );
/// ```

export 'open5e_endpoints.dart';
export 'open5e_service_v2.dart';
export 'models/character.dart';
export 'models/common.dart';
export 'models/equipment.dart';
export 'models/mechanics.dart';
export 'models/spells.dart';
