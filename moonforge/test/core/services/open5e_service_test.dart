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
        Open5eEndpoints.getEndpoint('monsters'),
        'https://api.open5e.com/v1/monsters/',
      );
      expect(
        Open5eEndpoints.getEndpoint('spells'),
        'https://api.open5e.com/v2/spells/',
      );
      expect(
        Open5eEndpoints.getEndpoint('weapons'),
        'https://api.open5e.com/v2/weapons/',
      );
    });

    test('getEndpoint returns null for unknown resources', () {
      expect(Open5eEndpoints.getEndpoint('unknown'), isNull);
    });
  });

  group('PaginatedResponse', () {
    test('fromJson parses valid response', () {
      final json = {
        'count': 10,
        'next': 'https://api.example.com?page=2',
        'previous': null,
        'results': [
          {'slug': 'test1', 'name': 'Test 1', 'desc': 'Description 1'},
          {'slug': 'test2', 'name': 'Test 2', 'desc': 'Description 2'},
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
      expect(response.results[0].slug, 'test1');
      expect(response.results[1].name, 'Test 2');
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
        'slug': 'acolyte',
        'name': 'Acolyte',
        'desc': 'A religious devotee',
        'skill_proficiencies': ['Insight', 'Religion'],
        'document': 'srd',
      };

      final background = Background.fromJson(json);

      expect(background.slug, 'acolyte');
      expect(background.name, 'Acolyte');
      expect(background.desc, 'A religious devotee');
      expect(background.skillProficiencies, ['Insight', 'Religion']);
      expect(background.document, 'srd');
    });

    test('Open5eSpell.fromJson parses correctly', () {
      final json = {
        'slug': 'fireball',
        'name': 'Fireball',
        'desc': 'A burst of flame',
        'level': 3,
        'school': 'Evocation',
        'components': 'V,S,M',
        'ritual': false,
        'concentration': false,
        'duration': 'Instantaneous',
        'casting_time': '1 action',
        'dnd_class': ['Wizard', 'Sorcerer'],
      };

      final spell = Open5eSpell.fromJson(json);

      expect(spell.slug, 'fireball');
      expect(spell.name, 'Fireball');
      expect(spell.level, 3);
      expect(spell.school, 'Evocation');
      expect(spell.ritual, false);
      expect(spell.concentration, false);
      expect(spell.dndClass, ['Wizard', 'Sorcerer']);
    });

    test('Weapon.fromJson parses correctly', () {
      final json = {
        'slug': 'longsword',
        'name': 'Longsword',
        'category': 'Martial Melee Weapon',
        'damage': '1d8',
        'damage_type': 'slashing',
        'weight': '3 lb.',
        'properties': 'Versatile (1d10)',
      };

      final weapon = Weapon.fromJson(json);

      expect(weapon.slug, 'longsword');
      expect(weapon.name, 'Longsword');
      expect(weapon.category, 'Martial Melee Weapon');
      expect(weapon.damage, '1d8');
      expect(weapon.damageType, 'slashing');
    });

    test('Race.fromJson parses correctly', () {
      final json = {
        'slug': 'elf',
        'name': 'Elf',
        'desc': 'Graceful and long-lived',
        'asi': '+2 Dexterity',
        'age': 'Mature at 100 years',
        'size': 'Medium',
        'speed': '30 ft.',
      };

      final race = Race.fromJson(json);

      expect(race.slug, 'elf');
      expect(race.name, 'Elf');
      expect(race.asi, '+2 Dexterity');
      expect(race.size, 'Medium');
    });

    test('CharacterClass.fromJson parses correctly', () {
      final json = {
        'slug': 'fighter',
        'name': 'Fighter',
        'desc': 'A master of martial combat',
        'hit_dice': '1d10',
        'prof_armor': 'All armor, shields',
        'prof_weapons': 'Simple weapons, martial weapons',
      };

      final characterClass = CharacterClass.fromJson(json);

      expect(characterClass.slug, 'fighter');
      expect(characterClass.name, 'Fighter');
      expect(characterClass.hitDice, '1d10');
      expect(characterClass.profArmor, 'All armor, shields');
    });

    test('Feat.fromJson parses correctly', () {
      final json = {
        'slug': 'alert',
        'name': 'Alert',
        'desc': 'Always on alert',
        'prerequisite': 'None',
      };

      final feat = Feat.fromJson(json);

      expect(feat.slug, 'alert');
      expect(feat.name, 'Alert');
      expect(feat.prerequisite, 'None');
    });

    test('Condition.fromJson parses correctly', () {
      final json = {
        'slug': 'blinded',
        'name': 'Blinded',
        'desc': 'Cannot see',
      };

      final condition = Condition.fromJson(json);

      expect(condition.slug, 'blinded');
      expect(condition.name, 'Blinded');
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
      when(() => mockPersistence.read<String>(any(), boxName: any(named: 'boxName')))
          .thenReturn(null);
      when(() => mockPersistence.write(any(), any(), boxName: any(named: 'boxName')))
          .thenAnswer((_) async => {});
    });

    test('service methods are available and type-safe', () {
      // Just verify that all methods exist and return the correct types
      expect(service.getMonsters, isA<Function>());
      expect(service.getSpells, isA<Function>());
      expect(service.getBackgrounds, isA<Function>());
      expect(service.getFeats, isA<Function>());
      expect(service.getConditions, isA<Function>());
      expect(service.getRaces, isA<Function>());
      expect(service.getClasses, isA<Function>());
      expect(service.getMagicItems, isA<Function>());
      expect(service.getWeapons, isA<Function>());
      expect(service.getArmor, isA<Function>());
      expect(service.getDocuments, isA<Function>());
      expect(service.getPlanes, isA<Function>());
      expect(service.getSections, isA<Function>());
      expect(service.getSpellLists, isA<Function>());
      expect(service.getManifest, isA<Function>());
    });
  });
}
