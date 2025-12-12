/// Open5e API Integration
///
/// A comprehensive, type-safe client for the Open5e API that provides:
/// - Type-safe models for all major Open5e resources
/// - Caching with ETag support
/// - Pagination support
/// - Search capabilities
/// - Easy-to-use service methods
///
/// Usage:
/// ```dart
/// final service = Open5eService(persistenceService);
///
/// // Fetch monsters
/// final monsters = await service.getMonsters(page: 1);
///
/// // Get a specific monster
/// final dragon = await service.getMonsterBySlug('ancient-red-dragon');
///
/// // Search for spells
/// final fireSpells = await service.searchSpells('fire');
/// ```

export 'open5e_endpoints.dart';
export 'open5e_models.dart';
export 'open5e_service.dart';
