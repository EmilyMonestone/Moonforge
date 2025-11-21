import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/services/origin_resolver.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

// Fake repositories for testing (in-memory)
class FakeCampaignRepository implements CampaignRepository {
  final Map<String, Campaign> _campaigns = {};

  void addCampaign(Campaign campaign) {
    _campaigns[campaign.id] = campaign;
  }

  @override
  Future<Campaign?> getById(String id) async {
    return _campaigns[id];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeChapterRepository implements ChapterRepository {
  final Map<String, Chapter> _chapters = {};
  final Map<String, List<Chapter>> _campaignChapters = {};

  void addChapter(Chapter chapter) {
    _chapters[chapter.id] = chapter;
    _campaignChapters.putIfAbsent(chapter.campaignId, () => []).add(chapter);
  }

  @override
  Future<Chapter?> getById(String id) async {
    return _chapters[id];
  }

  @override
  Future<List<Chapter>> getByCampaign(String campaignId) async {
    return _campaignChapters[campaignId] ?? [];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAdventureRepository implements AdventureRepository {
  final Map<String, Adventure> _adventures = {};
  final Map<String, List<Adventure>> _chapterAdventures = {};

  void addAdventure(Adventure adventure) {
    _adventures[adventure.id] = adventure;
    _chapterAdventures
        .putIfAbsent(adventure.chapterId, () => [])
        .add(adventure);
  }

  @override
  Future<Adventure?> getById(String id) async {
    return _adventures[id];
  }

  @override
  Future<List<Adventure>> getByChapter(String chapterId) async {
    return _chapterAdventures[chapterId] ?? [];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSceneRepository implements SceneRepository {
  final Map<String, Scene> _scenes = {};
  final Map<String, List<Scene>> _adventureScenes = {};

  void addScene(Scene scene) {
    _scenes[scene.id] = scene;
    _adventureScenes.putIfAbsent(scene.adventureId, () => []).add(scene);
  }

  @override
  Future<Scene?> getById(String id) async {
    return _scenes[id];
  }

  @override
  Future<List<Scene>> getByAdventure(String adventureId) async {
    return _adventureScenes[adventureId] ?? [];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeEncounterRepository implements EncounterRepository {
  final Map<String, Encounter> _encounters = {};

  void addEncounter(Encounter encounter) {
    _encounters[encounter.id] = encounter;
  }

  @override
  Future<Encounter?> getById(String id) async {
    return _encounters[id];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // Configure logger for testing - allow warnings to help debug
  setUpAll(() {
    logger = Logger(
      printer: SimplePrinter(),
      level: Level.warning, // Allow warnings to see what's failing
    );
  });

  late FakeCampaignRepository fakeCampaignRepo;
  late FakeChapterRepository fakeChapterRepo;
  late FakeAdventureRepository fakeAdventureRepo;
  late FakeSceneRepository fakeSceneRepo;
  late FakeEncounterRepository fakeEncounterRepo;
  late OriginResolver resolver;

  // Test data IDs
  const campaignId = '1762876290532';
  const chapterId = '1762875014035';
  const adventureId = '1762812675441';
  const sceneId = '1762812675442';
  const encounterId = '1762812675443';

  void setupTestData() {
    // Campaign
    fakeCampaignRepo.addCampaign(
      Campaign(
        id: campaignId,
        name: 'Test Campaign',
        description: '',
        content: null,
        ownerUid: 'testUser',
        memberUids: [],
        entityIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      ),
    );

    // Chapter
    fakeChapterRepo.addChapter(
      Chapter(
        id: chapterId,
        campaignId: campaignId,
        name: 'Test Chapter',
        order: 0,
        summary: '',
        content: const {},
        entityIds: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      ),
    );

    // Adventure
    fakeAdventureRepo.addAdventure(
      Adventure(
        id: adventureId,
        chapterId: chapterId,
        name: 'Test Adventure',
        order: 0,
        summary: '',
        content: const {},
        entityIds: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      ),
    );

    // Scene
    fakeSceneRepo.addScene(
      Scene(
        id: sceneId,
        adventureId: adventureId,
        name: 'Test Scene',
        order: 0,
        summary: '',
        content: const {},
        entityIds: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      ),
    );

    // Encounter
    fakeEncounterRepo.addEncounter(
      Encounter(
        id: encounterId,
        originId: campaignId,
        name: 'Test Encounter',
        preset: false,
        notes: null,
        loot: null,
        combatants: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
        entityIds: const [],
      ),
    );
  }

  setUp(() {
    fakeCampaignRepo = FakeCampaignRepository();
    fakeChapterRepo = FakeChapterRepository();
    fakeAdventureRepo = FakeAdventureRepository();
    fakeSceneRepo = FakeSceneRepository();
    fakeEncounterRepo = FakeEncounterRepository();

    resolver = OriginResolver(
      campaignRepo: fakeCampaignRepo,
      chapterRepo: fakeChapterRepo,
      adventureRepo: fakeAdventureRepo,
      sceneRepo: fakeSceneRepo,
      encounterRepo: fakeEncounterRepo,
    );

    // Setup test data
    setupTestData();
  });

  group('OriginResolver - Plain IDs', () {
    test('resolves plain campaign ID', () async {
      final result = await resolver.resolve(campaignId);
      expect(result, isNotNull);
      expect(result!.partType, 'campaign');
      expect(result.partId, campaignId);
      expect(result.label, 'Campaign');
    });

    test('resolves plain chapter ID with numbering', () async {
      final result = await resolver.resolve(chapterId);
      expect(result, isNotNull);
      expect(result!.partType, 'chapter');
      expect(result.partId, chapterId);
      expect(result.label, 'Chapter 1');
    });

    test('resolves plain adventure ID with numbering', () async {
      final result = await resolver.resolve(adventureId);
      expect(result, isNotNull);
      expect(result!.partType, 'adventure');
      expect(result.partId, adventureId);
      expect(result.label, 'Adventure 1.1');
    });

    test('resolves plain scene ID with numbering', () async {
      final result = await resolver.resolve(sceneId);
      expect(result, isNotNull);
      expect(result!.partType, 'scene');
      expect(result.partId, sceneId);
      expect(result.label, 'Scene 1.1.1');
    });

    test('resolves plain encounter ID', () async {
      final result = await resolver.resolve(encounterId);
      expect(result, isNotNull);
      expect(result!.partType, 'encounter');
      expect(result.partId, encounterId);
      expect(result.label, 'Encounter: Test Encounter');
    });

    test('returns null for empty originId', () async {
      final result = await resolver.resolve('');
      expect(result, isNull);
    });

    test('returns null for non-existent plain ID', () async {
      final result = await resolver.resolve('nonexistent');
      expect(result, isNull);
    });
  });

  group('OriginResolver - Composite IDs (Leaf-First)', () {
    test('DEBUG: check test data setup', () async {
      // Verify test data is set up correctly
      final adv = await fakeAdventureRepo.getById(adventureId);
      expect(adv, isNotNull, reason: 'Adventure should exist');
      expect(
        adv!.chapterId,
        chapterId,
        reason: 'Adventure chapter ID should match',
      );

      final ch = await fakeChapterRepo.getById(chapterId);
      expect(ch, isNotNull, reason: 'Chapter should exist');
      expect(
        ch!.campaignId,
        campaignId,
        reason: 'Chapter campaign ID should match',
      );

      final camp = await fakeCampaignRepo.getById(campaignId);
      expect(camp, isNotNull, reason: 'Campaign should exist');
    });

    test('resolves leaf-first adventure composite ID', () async {
      // Format: adventure-chapter-campaign-advId-chapterId-campaignId
      final compositeId =
          'adventure-chapter-campaign-$adventureId-$chapterId-$campaignId';
      final result = await resolver.resolve(compositeId);

      expect(result, isNotNull);
      expect(result!.partType, 'adventure');
      expect(result.partId, adventureId);
      expect(result.label, 'Adventure 1.1');
    });

    test('resolves leaf-first scene composite ID', () async {
      // Format: scene-adventure-chapter-campaign-sceneId-advId-chapterId-campaignId
      final compositeId =
          'scene-adventure-chapter-campaign-$sceneId-$adventureId-$chapterId-$campaignId';
      final result = await resolver.resolve(compositeId);

      expect(result, isNotNull);
      expect(result!.partType, 'scene');
      expect(result.partId, sceneId);
      expect(result.label, 'Scene 1.1.1');
    });

    test('resolves leaf-first chapter composite ID', () async {
      // Format: chapter-campaign-chapterId-campaignId
      final compositeId = 'chapter-campaign-$chapterId-$campaignId';
      final result = await resolver.resolve(compositeId);

      expect(result, isNotNull);
      expect(result!.partType, 'chapter');
      expect(result.partId, chapterId);
      expect(result.label, 'Chapter 1');
    });
  });

  group('OriginResolver - Composite IDs (Root-First)', () {
    test('resolves root-first adventure composite ID', () async {
      // Format: campaign-chapter-adventure-campaignId-chapterId-advId
      final compositeId =
          'campaign-chapter-adventure-$campaignId-$chapterId-$adventureId';
      final result = await resolver.resolve(compositeId);

      expect(result, isNotNull);
      expect(result!.partType, 'adventure');
      expect(result.partId, adventureId);
      expect(result.label, 'Adventure 1.1');
    });

    test('resolves root-first scene composite ID', () async {
      // Format: campaign-chapter-adventure-scene-campaignId-chapterId-advId-sceneId
      final compositeId =
          'campaign-chapter-adventure-scene-$campaignId-$chapterId-$adventureId-$sceneId';
      final result = await resolver.resolve(compositeId);

      expect(result, isNotNull);
      expect(result!.partType, 'scene');
      expect(result.partId, sceneId);
      expect(result.label, 'Scene 1.1.1');
    });
  });

  group('OriginResolver - Edge Cases', () {
    test('handles malformed composite IDs gracefully', () async {
      final result1 = await resolver.resolve('adventure-');
      expect(result1, isNull);

      final result2 = await resolver.resolve('invalid-tokens-only');
      expect(result2, isNull);

      final result3 = await resolver.resolve(
        'adventure-chapter-$adventureId',
      ); // missing IDs
      expect(result3, isNull);
    });

    test('caches resolved origins', () async {
      // First call
      final result1 = await resolver.resolve(campaignId);
      expect(result1, isNotNull);

      // Second call should use cache
      final result2 = await resolver.resolve(campaignId);
      expect(result2, isNotNull);
      expect(result2!.partType, result1!.partType);
      expect(result2.partId, result1.partId);
    });

    test('clears cache when requested', () async {
      // First call
      final result1 = await resolver.resolve(campaignId);
      expect(result1, isNotNull);

      // Clear cache
      resolver.clearCache();

      // Second call
      final result2 = await resolver.resolve(campaignId);
      expect(result2, isNotNull);
      expect(result2!.partType, result1!.partType);
    });

    test('handles multiple chapters with correct numbering', () async {
      const chapter2Id = 'chapter2Id';
      fakeChapterRepo.addChapter(
        Chapter(
          id: chapter2Id,
          campaignId: campaignId,
          name: 'Chapter 2',
          order: 1,
          summary: '',
          content: const {},
          entityIds: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          rev: 1,
        ),
      );

      final result = await resolver.resolve(chapter2Id);
      expect(result, isNotNull);
      expect(result!.label, 'Chapter 2');
    });

    test('handles multiple adventures with correct numbering', () async {
      const adventure2Id = 'adventure2Id';
      fakeAdventureRepo.addAdventure(
        Adventure(
          id: adventure2Id,
          chapterId: chapterId,
          name: 'Adventure 2',
          order: 1,
          summary: '',
          content: const {},
          entityIds: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          rev: 1,
        ),
      );

      final result = await resolver.resolve(adventure2Id);
      expect(result, isNotNull);
      expect(result!.label, 'Adventure 1.2');
    });
  });

  group('OriginResolver - Integration with Deprecated getTrueOrigin', () {
    test('getTrueOrigin delegates to OriginResolver correctly', () async {
      // ignore: deprecated_member_use_from_same_package
      final result = await getTrueOrigin(
        adventureId,
        campaignRepo: fakeCampaignRepo,
        chapterRepo: fakeChapterRepo,
        adventureRepo: fakeAdventureRepo,
        sceneRepo: fakeSceneRepo,
        encounterRepo: fakeEncounterRepo,
      );

      expect(result, isNotNull);
      expect(result!.partType, 'adventure');
      expect(result.partId, adventureId);
      expect(result.label, 'Adventure 1.1');
    });
  });
}
