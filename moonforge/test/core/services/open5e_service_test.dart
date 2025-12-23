import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';

class MockClient extends Mock implements http.Client {}

class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  group('Open5eEndpoints', () {
    test('getEndpoint returns correct URL for known resources', () {
      expect(
        Open5eEndpoints.getEndpoint('creatures'),
        'https://api.open5e.com/v2/creatures/?format=api',
      );
      expect(
        Open5eEndpoints.getEndpoint('spells'),
        'https://api.open5e.com/v2/spells/?format=api',
      );
      expect(
        Open5eEndpoints.getEndpoint('weapons'),
        'https://api.open5e.com/v2/weapons/?format=api',
      );
      expect(
        Open5eEndpoints.getEndpoint('species'),
        'https://api.open5e.com/v2/species/?format=api',
      );
    });

    test('getEndpoint returns null for unknown resources', () {
      expect(Open5eEndpoints.getEndpoint('unknown'), isNull);
    });
  });

  group('Open5eQueryOptions', () {
    test('toQueryParams includes all parameters', () {
      final options = Open5eQueryOptions(
        search: 'dragon',
        documentKey: DocumentKey.tomeOfBeasts,
        gameSystemKey: GameSystemKey.edition2024,
        ordering: 'name',
        page: 2,
        limit: 50,
        filters: {'challenge_rating_decimal': '3'},
        creatureType: 'dragon',
      );

      final params = options.toQueryParams();

      expect(params['name__icontains'], 'dragon');
      expect(params['document__key__iexact'], DocumentKey.tomeOfBeasts);
      expect(params['document__gamesystem__key__iexact'], GameSystemKey.edition2024);
      expect(params['ordering'], 'name');
      expect(params['page'], '2');
      expect(params['limit'], '50');
      expect(params['challenge_rating_decimal'], '3');
      expect(params['type'], 'dragon');
    });

    test('toQueryParams handles minimal options with defaults', () {
      final options = Open5eQueryOptions();
      final params = options.toQueryParams();

      expect(params['page'], '1');
      expect(params['document__gamesystem__key__iexact'], GameSystemKey.edition2024);
      expect(params.containsKey('name__icontains'), false);
      expect(params.containsKey('document__key'), false);
    });

    test('GameSystemKey constants have correct values', () {
      expect(GameSystemKey.edition2024, '5e-2024');
      expect(GameSystemKey.edition2014, '5e-2014');
      expect(GameSystemKey.advancedEdition, 'a5e');
    });

    test('DocumentKey constants have correct values', () {
      expect(DocumentKey.srd2024, 'srd-2024');
      expect(DocumentKey.srd2014, 'srd');
      expect(DocumentKey.tomeOfBeasts, 'tob');
      expect(DocumentKey.tomeOfBeasts2, 'tob2');
      expect(DocumentKey.creaturesCodex, 'cc');
      expect(DocumentKey.midgardHeroes, 'dmag');
    });
  });

  group('PaginatedResponse', () {
    test('fromJson parses valid response', () {
      final json = {
        'count': 10,
        'next': 'https://api.example.com?page=2',
        'previous': null,
        'results': [
          {
            'url': 'https://api.open5e.com/v2/backgrounds/acolyte/',
            'key': 'acolyte',
            'name': 'Acolyte',
            'desc': 'Description 1',
          },
          {
            'url': 'https://api.open5e.com/v2/backgrounds/soldier/',
            'key': 'soldier',
            'name': 'Soldier',
            'desc': 'Description 2',
          },
        ],
      };

      final response = PaginatedResponse.fromJson(
        json,
        (item) => Background.fromJson(item),
      );

      expect(response.count, 10);
      expect(response.next, 'https://api.example.com?page=2');
      expect(response.previous, isNull);
      expect(response.results.length, 2);
      expect(response.results[0].key, 'acolyte');
      expect(response.results[1].name, 'Soldier');
    });

    test('fromJson handles empty results', () {
      final json = {
        'count': 0,
        'results': [],
      };

      final response = PaginatedResponse.fromJson(
        json,
        (item) => Background.fromJson(item),
      );

      expect(response.count, 0);
      expect(response.results, isEmpty);
    });
  });

  group('Open5eModels', () {
    test('Background.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/backgrounds/acolyte/',
        'key': 'acolyte',
        'name': 'Acolyte',
        'desc': 'A religious devotee',
      };

      final background = Background.fromJson(json);

      expect(background.key, 'acolyte');
      expect(background.name, 'Acolyte');
      expect(background.desc, 'A religious devotee');
    });

    test('Open5eSpell.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/spells/fireball/',
        'key': 'fireball',
        'name': 'Fireball',
        'desc': 'A burst of flame',
        'level': 3,
        'school': 'Evocation',
      };

      final spell = Open5eSpell.fromJson(json);

      expect(spell.key, 'fireball');
      expect(spell.name, 'Fireball');
      expect(spell.level, 3);
      expect(spell.school, 'Evocation');
    });

    test('Weapon.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/weapons/longsword/',
        'key': 'longsword',
        'name': 'Longsword',
        'category': 'Martial Melee Weapon',
        'type': 'Weapon',
      };

      final weapon = Weapon.fromJson(json);

      expect(weapon.key, 'longsword');
      expect(weapon.name, 'Longsword');
      expect(weapon.category, 'Martial Melee Weapon');
    });

    test('Species.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/species/elf/',
        'key': 'elf',
        'name': 'Elf',
        'desc': 'Graceful and long-lived',
      };

      final species = Species.fromJson(json);

      expect(species.key, 'elf');
      expect(species.name, 'Elf');
      expect(species.desc, 'Graceful and long-lived');
    });

    test('CharacterClass.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/classes/fighter/',
        'key': 'fighter',
        'name': 'Fighter',
        'desc': 'A master of martial combat',
      };

      final characterClass = CharacterClass.fromJson(json);

      expect(characterClass.key, 'fighter');
      expect(characterClass.name, 'Fighter');
      expect(characterClass.desc, 'A master of martial combat');
    });

    test('Feat.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/feats/alert/',
        'key': 'alert',
        'name': 'Alert',
        'desc': 'Always on alert',
      };

      final feat = Feat.fromJson(json);

      expect(feat.key, 'alert');
      expect(feat.name, 'Alert');
    });

    test('Condition.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/conditions/blinded/',
        'key': 'blinded',
        'name': 'Blinded',
        'desc': 'Cannot see',
      };

      final condition = Condition.fromJson(json);

      expect(condition.key, 'blinded');
      expect(condition.name, 'Blinded');
    });

    test('Creature.fromJson parses correctly', () {
      final json = {
        'url': 'https://api.open5e.com/v2/creatures/ancient-red-dragon/',
        'key': 'ancient-red-dragon',
        'name': 'Ancient Red Dragon',
        'type': 'Dragon',
        'challenge_rating_decimal': 24.00,
        'armor_class': 22,
      };

      final creature = Creature.fromJson(json);

      expect(creature.key, 'ancient-red-dragon');
      expect(creature.name, 'Ancient Red Dragon');
      expect(creature.type, 'Dragon');
      expect(creature.challengeRatingDecimal, 24.00);
      expect(creature.armorClass, 22);
    });
  });

  group('Open5eService', () {
    late MockPersistenceService mockPersistence;
    late MockClient mockClient;
    late Open5eService service;

    setUp(() {
      mockPersistence = MockPersistenceService();
      mockClient = MockClient();
      service = Open5eService(mockPersistence, httpClient: mockClient);

      // Default stub for persistence methods
      when(() => mockPersistence.read<String>(any(),
              boxName: any(named: 'boxName')))
          .thenReturn(null);
      when(() => mockPersistence.write(any(), any(),
              boxName: any(named: 'boxName')))
          .thenAnswer((_) async => {});
    });

    test('service methods are available and type-safe for all 33 endpoints', () {
      // Creatures
      expect(service.getCreatures, isA<Function>());
      expect(service.getCreatureByKey, isA<Function>());
      expect(service.getCreatureTypes, isA<Function>());
      expect(service.getCreatureSets, isA<Function>());
      
      // Spells
      expect(service.getSpells, isA<Function>());
      expect(service.getSpellByKey, isA<Function>());
      expect(service.getSpellSchools, isA<Function>());
      
      // Character
      expect(service.getBackgrounds, isA<Function>());
      expect(service.getFeats, isA<Function>());
      expect(service.getSpecies, isA<Function>());
      expect(service.getClasses, isA<Function>());
      expect(service.getAbilities, isA<Function>());
      expect(service.getSkills, isA<Function>());
      
      // Equipment
      expect(service.getItems, isA<Function>());
      expect(service.getMagicItems, isA<Function>());
      expect(service.getWeapons, isA<Function>());
      expect(service.getArmor, isA<Function>());
      expect(service.getItemSets, isA<Function>());
      expect(service.getItemCategories, isA<Function>());
      expect(service.getItemRarities, isA<Function>());
      expect(service.getWeaponProperties, isA<Function>());
      
      // Mechanics
      expect(service.getConditions, isA<Function>());
      expect(service.getDamageTypes, isA<Function>());
      expect(service.getLanguages, isA<Function>());
      expect(service.getAlignments, isA<Function>());
      expect(service.getSizes, isA<Function>());
      expect(service.getEnvironments, isA<Function>());
      
      // Documentation
      expect(service.getDocuments, isA<Function>());
      expect(service.getGameSystems, isA<Function>());
      expect(service.getPublishers, isA<Function>());
      expect(service.getLicenses, isA<Function>());
      
      // Rules & Media
      expect(service.getRules, isA<Function>());
      expect(service.getRuleSets, isA<Function>());
      expect(service.getImages, isA<Function>());
      expect(service.getServices, isA<Function>());
    });
  });
}
