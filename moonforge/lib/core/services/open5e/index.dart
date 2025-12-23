/// Open5e API v2 Integration
///
/// A comprehensive, type-safe client for the Open5e API v2 that provides:
/// - Type-safe models for all 33 Open5e v2 resources
/// - Caching with ETag support
/// - Filtering, searching, and ordering per official API docs
/// - Pagination support
/// - GameSystem filtering (defaults to 5e-2024)
/// - Document filtering (e.g., filter by 'srd-2024', 'tob')
/// - Easy-to-use service methods
///
/// Usage:
/// ```dart
/// final service = Open5eService(persistenceService);
///
/// // Fetch creatures with CR 3 from 5e-2024 gamesystem
/// final creatures = await service.getCreatures(
///   options: Open5eQueryOptions(
///     filters: {'challenge_rating_decimal': '3'},
///     ordering: 'name',
///   ),
/// );
///
/// // Search for fire-related spells in 5e-2014
/// final fireSpells = await service.getSpells(
///   options: Open5eQueryOptions(
///     search: 'fire',
///     gameSystemKey: '5e-2014',
///   ),
/// );
/// ```

export 'open5e_endpoints.dart';
export 'open5e_service_v2.dart';
export 'models/character.dart';
export 'models/common.dart';
export 'models/creatures.dart';
export 'models/equipment.dart';
export 'models/mechanics.dart';
export 'models/rules.dart';
export 'models/spells.dart';
