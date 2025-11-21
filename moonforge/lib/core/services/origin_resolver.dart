import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service responsible for deterministic origin resolution
/// Resolves composite and plain originIds to canonical EntityOrigin
class OriginResolver {
  final CampaignRepository campaignRepo;
  final ChapterRepository chapterRepo;
  final AdventureRepository adventureRepo;
  final SceneRepository sceneRepo;
  final EncounterRepository encounterRepo;

  // Cache for performance (keyed by originId)
  final Map<String, EntityOrigin?> _cache = {};

  OriginResolver({
    required this.campaignRepo,
    required this.chapterRepo,
    required this.adventureRepo,
    required this.sceneRepo,
    required this.encounterRepo,
  });

  /// Clear the resolution cache
  void clearCache() {
    _cache.clear();
  }

  /// Resolve an originId to its canonical EntityOrigin
  /// Returns null if originId cannot be resolved
  Future<EntityOrigin?> resolve(String originId) async {
    if (originId.isEmpty) return null;

    // Check cache first
    if (_cache.containsKey(originId)) {
      return _cache[originId];
    }

    EntityOrigin? result;

    // Plain ID (no hyphens) - try lookup across all repositories
    if (!originId.contains('-')) {
      result = await _resolvePlainId(originId);
    } else {
      // Composite ID - parse and validate
      result = await _resolveCompositeId(originId);
      
      // Fallback: If composite resolution fails due to missing data (not malformed format),
      // try to extract and resolve the leaf ID
      if (result == null && _isWellFormedComposite(originId)) {
        logger.w(
          '[OriginResolver] Composite resolution failed for $originId, attempting fallback to leaf ID',
        );
        final tokens = originId.split('-').where((t) => t.isNotEmpty).toList();
        bool isIdToken(String t) => RegExp(r'^\d+$').hasMatch(t) && t.length >= 6;
        final firstIdIndex = tokens.indexWhere(isIdToken);
        if (firstIdIndex != -1) {
          final idTokens = tokens.sublist(firstIdIndex);
          // Try the first ID token (likely the leaf in leaf-first encoding)
          if (idTokens.isNotEmpty) {
            result = await _resolvePlainId(idTokens.first);
            if (result != null) {
              logger.w(
                '[OriginResolver] Fallback successful: resolved ${idTokens.first} as ${result.partType}: ${result.label}',
              );
            } else {
              logger.w(
                '[OriginResolver] Fallback failed: could not resolve ${idTokens.first} as plain ID',
              );
            }
          }
        }
      }
    }

    // Cache result (even if null)
    _cache[originId] = result;
    return result;
  }

  /// Resolve a plain (non-composite) originId
  /// 
  /// Tries both the originId as-is and with type prefixes (e.g., "campaign-123")
  /// since IDs may be stored with prefixes in the database
  Future<EntityOrigin?> _resolvePlainId(String originId) async {
    // Helper to try lookup with and without prefix
    Future<T?> tryWithPrefix<T>(
      String prefix,
      Future<T?> Function(String) lookup,
    ) async {
      // Try with originId as-is first
      var result = await lookup(originId);
      if (result != null) return result;
      
      // If originId doesn't already start with prefix, try adding it
      if (!originId.startsWith('$prefix-')) {
        result = await lookup('$prefix-$originId');
      }
      return result;
    }

    // Try campaign
    final campaign = await tryWithPrefix('campaign', campaignRepo.getById);
    if (campaign != null) {
      logger.d('[OriginResolver] Resolved plain ID $originId as campaign');
      return EntityOrigin(
        partType: 'campaign',
        partId: campaign.id,
        label: 'Campaign',
        path: campaign.id,
      );
    }

    // Try chapter
    final chapter = await tryWithPrefix('chapter', chapterRepo.getById);
    if (chapter != null) {
      final chapters = await chapterRepo.getByCampaign(chapter.campaignId);
      chapters.sort((a, b) => a.order.compareTo(b.order));
      final idx = chapters.indexWhere((c) => c.id == chapter.id);
      final label = idx >= 0 ? 'Chapter ${idx + 1}' : 'Chapter';
      logger.d(
        '[OriginResolver] Resolved plain ID $originId as chapter: $label',
      );
      return EntityOrigin(
        partType: 'chapter',
        partId: chapter.id,
        label: label,
        path: '${chapter.campaignId}/${chapter.id}',
      );
    }

    // Try adventure
    final adventure = await tryWithPrefix('adventure', adventureRepo.getById);
    if (adventure != null) {
      final ch = await chapterRepo.getById(adventure.chapterId);
      if (ch != null) {
        final chapters = await chapterRepo.getByCampaign(ch.campaignId);
        chapters.sort((a, b) => a.order.compareTo(b.order));
        final chapterIndex = chapters.indexWhere((c) => c.id == ch.id);
        final adventures = await adventureRepo.getByChapter(ch.id);
        adventures.sort((a, b) => a.order.compareTo(b.order));
        final advIndex = adventures.indexWhere((a) => a.id == adventure.id);
        final label = (chapterIndex >= 0 && advIndex >= 0)
            ? 'Adventure ${chapterIndex + 1}.${advIndex + 1}'
            : 'Adventure';
        logger.d(
          '[OriginResolver] Resolved plain ID $originId as adventure: $label',
        );
        return EntityOrigin(
          partType: 'adventure',
          partId: adventure.id,
          label: label,
          path: '${ch.campaignId}/${ch.id}/${adventure.id}',
        );
      }
    }

    // Try scene
    final scene = await tryWithPrefix('scene', sceneRepo.getById);
    if (scene != null) {
      final adv = await adventureRepo.getById(scene.adventureId);
      if (adv != null) {
        final ch = await chapterRepo.getById(adv.chapterId);
        if (ch != null) {
          final chapters = await chapterRepo.getByCampaign(ch.campaignId);
          chapters.sort((a, b) => a.order.compareTo(b.order));
          final chapterIndex = chapters.indexWhere((c) => c.id == ch.id);
          final adventures = await adventureRepo.getByChapter(ch.id);
          adventures.sort((a, b) => a.order.compareTo(b.order));
          final advIndex = adventures.indexWhere((a) => a.id == adv.id);
          final scenes = await sceneRepo.getByAdventure(adv.id);
          scenes.sort((a, b) => a.order.compareTo(b.order));
          final sceneIndex = scenes.indexWhere((s) => s.id == scene.id);
          final label = (chapterIndex >= 0 && advIndex >= 0 && sceneIndex >= 0)
              ? 'Scene ${chapterIndex + 1}.${advIndex + 1}.${sceneIndex + 1}'
              : 'Scene';
          logger.d(
            '[OriginResolver] Resolved plain ID $originId as scene: $label',
          );
          return EntityOrigin(
            partType: 'scene',
            partId: scene.id,
            label: label,
            path: '${ch.campaignId}/${ch.id}/${adv.id}/${scene.id}',
          );
        }
      }
    }

    // Try encounter
    final encounter = await tryWithPrefix('encounter', encounterRepo.getById);
    if (encounter != null) {
      logger.d(
        '[OriginResolver] Resolved plain ID $originId as encounter: ${encounter.name}',
      );
      return EntityOrigin(
        partType: 'encounter',
        partId: encounter.id,
        label: 'Encounter: ${encounter.name}',
        path: encounter.id,
      );
    }

    logger.w('[OriginResolver] Could not resolve plain ID: $originId');
    return null;
  }

  /// Check if a composite originId has well-formed structure (valid type/ID token counts)
  /// Returns true if the format is valid, even if the IDs don't exist in the database
  bool _isWellFormedComposite(String originId) {
    final tokens = originId.split('-').where((t) => t.isNotEmpty).toList();
    if (tokens.length < 2) {
      return false;
    }

    // Separate type tokens from ID tokens
    bool isIdToken(String t) => RegExp(r'^\d+$').hasMatch(t) && t.length >= 6;
    final firstIdIndex = tokens.indexWhere(isIdToken);
    if (firstIdIndex == -1) {
      return false;
    }

    final typeTokens = tokens.sublist(0, firstIdIndex);
    final idTokens = tokens.sublist(firstIdIndex);

    // Must have equal or more IDs than types
    if (typeTokens.isEmpty || idTokens.isEmpty || idTokens.length < typeTokens.length) {
      return false;
    }

    // Must have at least one valid type token
    const validTypes = {'campaign', 'chapter', 'adventure', 'scene', 'encounter'};
    final filteredTypes = typeTokens.where(validTypes.contains).toList();
    return filteredTypes.isNotEmpty;
  }

  /// Resolve a composite originId by parsing and validating tokens
  /// Format examples:
  /// - adventure-chapter-campaign-advId-chapterId-campaignId (leaf-first)
  /// - campaign-chapter-adventure-campaignId-chapterId-advId (root-first)
  Future<EntityOrigin?> _resolveCompositeId(String originId) async {
    final tokens = originId.split('-').where((t) => t.isNotEmpty).toList();
    if (tokens.length < 2) {
      logger.w('[OriginResolver] Composite ID has too few tokens: $originId');
      return null;
    }

    // Separate type tokens from ID tokens
    // ID tokens are numeric strings (timestamps like 1762812675441)
    bool isIdToken(String t) => RegExp(r'^\d+$').hasMatch(t) && t.length >= 6;
    final firstIdIndex = tokens.indexWhere(isIdToken);
    if (firstIdIndex == -1) {
      logger.w('[OriginResolver] No ID tokens found in: $originId');
      return null;
    }

    final typeTokens = tokens.sublist(0, firstIdIndex);
    final idTokens = tokens.sublist(firstIdIndex);

    if (typeTokens.isEmpty || idTokens.isEmpty || idTokens.length < typeTokens.length) {
      logger.w(
        '[OriginResolver] Invalid token structure in: $originId (types: ${typeTokens.length}, ids: ${idTokens.length})',
      );
      return null;
    }

    const validTypes = {'campaign', 'chapter', 'adventure', 'scene', 'encounter'};
    final filteredTypes = typeTokens.where(validTypes.contains).toList();
    if (filteredTypes.isEmpty) {
      logger.w('[OriginResolver] No valid type tokens in: $originId');
      return null;
    }

    // Determine encoding: leaf-first vs root-first
    // Strategy: try both and validate against repository records
    final leafFirstResult = await _tryResolveMapping(
      originId,
      filteredTypes,
      idTokens,
      leafFirst: true,
    );
    if (leafFirstResult != null) {
      return leafFirstResult;
    }

    final rootFirstResult = await _tryResolveMapping(
      originId,
      filteredTypes,
      idTokens,
      leafFirst: false,
    );
    if (rootFirstResult != null) {
      return rootFirstResult;
    }

    logger.w('[OriginResolver] Could not resolve composite ID: $originId');
    return null;
  }

  /// Try to resolve with a specific mapping strategy (leaf-first or root-first)
  Future<EntityOrigin?> _tryResolveMapping(
    String originId,
    List<String> typeTokens,
    List<String> idTokens,
    {required bool leafFirst,
  }) async {
    // Build type->id mapping
    final mapping = <String, String>{};
    final lenTypes = typeTokens.length;
    final lenIds = idTokens.length;

    // Both leaf-first and root-first use direct positional mapping
    // Leaf-first: adventure-chapter-campaign-advId-chapterId-campaignId
    // Root-first: campaign-chapter-adventure-campaignId-chapterId-advId
    // In both cases, typeTokens[i] maps to idTokens[i]
    for (var i = 0; i < lenTypes; i++) {
      mapping[typeTokens[i]] = idTokens[i];
    }

    // Determine leaf type
    final leafType = leafFirst ? typeTokens.first : typeTokens.last;
    final leafId = mapping[leafType];
    if (leafId == null) {
      return null;
    }

    logger.d(
      '[OriginResolver] Trying ${leafFirst ? "leaf-first" : "root-first"} for $originId: leafType=$leafType, leafId=$leafId',
    );

    // Validate mapping by checking if leaf exists and its hierarchy matches
    final validated = await _validateMapping(mapping, leafType, leafId);
    if (!validated) {
      logger.d(
        '[OriginResolver] Validation failed for ${leafFirst ? "leaf-first" : "root-first"} mapping',
      );
      return null;
    }

    // Build the label with numbering
    final label = await _buildLabel(mapping, leafType, leafId);
    final path = _buildPath(mapping);

    logger.d(
      '[OriginResolver] Resolved composite $originId as $leafType: $label',
    );
    return EntityOrigin(
      partType: leafType,
      partId: leafId,
      label: label,
      path: path,
    );
  }

  /// Validate that the mapping corresponds to actual repository records
  /// and that hierarchy relationships are correct
  Future<bool> _validateMapping(
    Map<String, String> mapping,
    String leafType,
    String leafId,
  ) async {
    try {
      // Validate based on leaf type
      switch (leafType) {
        case 'campaign':
          final campaign = await campaignRepo.getById(leafId);
          if (campaign == null) return false;
          // If more specific types exist in mapping, campaign cannot be the leaf
          if (mapping.containsKey('chapter') || 
              mapping.containsKey('adventure') || 
              mapping.containsKey('scene') || 
              mapping.containsKey('encounter')) {
            return false;
          }
          return true;

        case 'chapter':
          final chapter = await chapterRepo.getById(leafId);
          if (chapter == null) return false;
          // If campaign specified, verify match
          final campaignId = mapping['campaign'];
          if (campaignId != null && chapter.campaignId != campaignId) {
            return false;
          }
          // If more specific types exist in mapping, chapter cannot be the leaf
          if (mapping.containsKey('adventure') || 
              mapping.containsKey('scene') || 
              mapping.containsKey('encounter')) {
            return false;
          }
          return true;

        case 'adventure':
          final adventure = await adventureRepo.getById(leafId);
          if (adventure == null) {
            logger.d('[OriginResolver] Adventure not found: $leafId');
            return false;
          }
          // Verify chapter relationship if specified
          final chapterId = mapping['chapter'];
          if (chapterId != null && adventure.chapterId != chapterId) {
            logger.d(
              '[OriginResolver] Adventure chapter mismatch: adventure.chapterId=${adventure.chapterId} != expected=$chapterId',
            );
            return false;
          }
          // Verify campaign relationship if specified
          final campaignId = mapping['campaign'];
          if (campaignId != null) {
            final chapter = await chapterRepo.getById(adventure.chapterId);
            if (chapter == null) {
              logger.d(
                '[OriginResolver] Chapter not found for adventure: ${adventure.chapterId}',
              );
              return false;
            }
            if (chapter.campaignId != campaignId) {
              logger.d(
                '[OriginResolver] Chapter campaign mismatch: chapter.campaignId=${chapter.campaignId} != expected=$campaignId',
              );
              return false;
            }
          }
          // If more specific types exist in mapping, adventure cannot be the leaf
          if (mapping.containsKey('scene') || mapping.containsKey('encounter')) {
            return false;
          }
          return true;

        case 'scene':
          final scene = await sceneRepo.getById(leafId);
          if (scene == null) return false;
          // Verify adventure relationship if specified
          final adventureId = mapping['adventure'];
          if (adventureId != null && scene.adventureId != adventureId) {
            return false;
          }
          // Verify chapter relationship if specified
          final chapterId = mapping['chapter'];
          if (chapterId != null) {
            final adventure = await adventureRepo.getById(scene.adventureId);
            if (adventure == null || adventure.chapterId != chapterId) {
              return false;
            }
          }
          // Verify campaign relationship if specified
          final campaignId = mapping['campaign'];
          if (campaignId != null) {
            final adventure = await adventureRepo.getById(scene.adventureId);
            if (adventure == null) return false;
            final chapter = await chapterRepo.getById(adventure.chapterId);
            if (chapter == null || chapter.campaignId != campaignId) {
              return false;
            }
          }
          return true;

        case 'encounter':
          final encounter = await encounterRepo.getById(leafId);
          return encounter != null;

        default:
          return false;
      }
    } catch (e) {
      logger.w('[OriginResolver] Validation error: $e');
      return false;
    }
  }

  /// Build the display label with numbering
  Future<String> _buildLabel(
    Map<String, String> mapping,
    String leafType,
    String leafId,
  ) async {
    try {
      switch (leafType) {
        case 'campaign':
          return 'Campaign';

        case 'chapter':
          final campaignId = mapping['campaign'];
          if (campaignId != null) {
            final chapters = await chapterRepo.getByCampaign(campaignId);
            chapters.sort((a, b) => a.order.compareTo(b.order));
            final idx = chapters.indexWhere((c) => c.id == leafId);
            if (idx >= 0) {
              return 'Chapter ${idx + 1}';
            }
          }
          return 'Chapter';

        case 'adventure':
          final chapterId = mapping['chapter'];
          final campaignId = mapping['campaign'];
          if (chapterId != null && campaignId != null) {
            final chapters = await chapterRepo.getByCampaign(campaignId);
            chapters.sort((a, b) => a.order.compareTo(b.order));
            final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
            final adventures = await adventureRepo.getByChapter(chapterId);
            adventures.sort((a, b) => a.order.compareTo(b.order));
            final advIndex = adventures.indexWhere((a) => a.id == leafId);
            if (chapterIndex >= 0 && advIndex >= 0) {
              return 'Adventure ${chapterIndex + 1}.${advIndex + 1}';
            }
          }
          return 'Adventure';

        case 'scene':
          final chapterId = mapping['chapter'];
          final campaignId = mapping['campaign'];
          final adventureId = mapping['adventure'];
          if (chapterId != null && campaignId != null && adventureId != null) {
            final chapters = await chapterRepo.getByCampaign(campaignId);
            chapters.sort((a, b) => a.order.compareTo(b.order));
            final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
            final adventures = await adventureRepo.getByChapter(chapterId);
            adventures.sort((a, b) => a.order.compareTo(b.order));
            final advIndex = adventures.indexWhere((a) => a.id == adventureId);
            final scenes = await sceneRepo.getByAdventure(adventureId);
            scenes.sort((a, b) => a.order.compareTo(b.order));
            final sceneIndex = scenes.indexWhere((s) => s.id == leafId);
            if (chapterIndex >= 0 && advIndex >= 0 && sceneIndex >= 0) {
              return 'Scene ${chapterIndex + 1}.${advIndex + 1}.${sceneIndex + 1}';
            }
          }
          return 'Scene';

        case 'encounter':
          final encounter = await encounterRepo.getById(leafId);
          if (encounter != null) {
            return 'Encounter: ${encounter.name}';
          }
          return 'Encounter';

        default:
          return leafType;
      }
    } catch (e) {
      logger.w('[OriginResolver] Error building label: $e');
      return leafType;
    }
  }

  /// Build canonical path from mapping
  String _buildPath(Map<String, String> mapping) {
    const order = ['campaign', 'chapter', 'adventure', 'scene', 'encounter'];
    return order
        .map((t) => mapping[t] ?? '')
        .where((v) => v.isNotEmpty)
        .join('/');
  }
}
