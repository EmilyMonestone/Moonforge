import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/firestore_mappers.dart';

void main() {
  group('Firestore Mappers Date Handling', () {
    group('_asDate via campaignFromFirestore', () {
      test('handles Firestore Timestamp', () {
        final timestamp = Timestamp.fromDate(DateTime(2023, 1, 15, 10, 30));
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': timestamp,
          'updatedAt': timestamp,
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles integer epoch seconds', () {
        // 1673779800 = 2023-01-15 10:30:00 UTC
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': 1673779800,
          'updatedAt': 1673779800,
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles integer epoch milliseconds', () {
        // Large number indicates milliseconds
        final millis = DateTime(2023, 1, 15, 10, 30).millisecondsSinceEpoch;
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': millis,
          'updatedAt': millis,
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles string epoch seconds with Z suffix', () {
        // This is the problematic format from the error: "1761490548Z"
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': '1673779800Z',
          'updatedAt': '1673779800Z',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles string epoch seconds without Z suffix', () {
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': '1673779800',
          'updatedAt': '1673779800',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles ISO8601 string', () {
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': '2023-01-15T10:30:00.000Z',
          'updatedAt': '2023-01-15T10:30:00.000Z',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNotNull);
        expect(companion.createdAt.value?.year, equals(2023));
        expect(companion.createdAt.value?.month, equals(1));
        expect(companion.createdAt.value?.day, equals(15));
      });

      test('handles null date gracefully', () {
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': null,
          'updatedAt': null,
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNull);
        expect(companion.updatedAt.value, isNull);
      });

      test('handles missing date fields gracefully', () {
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.createdAt.value, isNull);
        expect(companion.updatedAt.value, isNull);
      });

      test('handles invalid date string gracefully', () {
        final data = {
          'name': 'Test Campaign',
          'description': 'Test Description',
          'createdAt': 'not-a-date',
          'updatedAt': 'not-a-date',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        // Should return null without throwing
        expect(companion.createdAt.value, isNull);
        expect(companion.updatedAt.value, isNull);
      });
    });

    group('_reqString via campaignFromFirestore', () {
      test('uses provided string value', () {
        final data = {
          'name': 'My Campaign',
          'description': 'My Description',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.name.value, equals('My Campaign'));
        expect(companion.description.value, equals('My Description'));
      });

      test('uses fallback for null name', () {
        final data = {
          'name': null,
          'description': 'My Description',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.name.value, equals('Untitled Campaign'));
        expect(companion.description.value, equals('My Description'));
      });

      test('uses fallback for missing name', () {
        final data = {
          'description': 'My Description',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.name.value, equals('Untitled Campaign'));
        expect(companion.description.value, isNotNull);
      });

      test('uses empty string fallback for missing description', () {
        final data = {
          'name': 'My Campaign',
        };
        
        final companion = campaignFromFirestore('test-id', data);
        expect(companion.name.value, equals('My Campaign'));
        expect(companion.description.value, equals(''));
      });
    });

    group('Entity mapper safe defaults', () {
      test('handles missing kind with fallback', () {
        final data = {
          'name': 'Test Entity',
          'originId': 'origin-1',
        };
        
        final companion = entityFromFirestore('test-id', data);
        expect(companion.kind.value, equals('unknown'));
        expect(companion.name.value, equals('Test Entity'));
      });

      test('handles missing name with fallback', () {
        final data = {
          'kind': 'npc',
          'originId': 'origin-1',
        };
        
        final companion = entityFromFirestore('test-id', data);
        expect(companion.kind.value, equals('npc'));
        expect(companion.name.value, equals('Unnamed Entity'));
      });

      test('handles missing originId with fallback', () {
        final data = {
          'kind': 'npc',
          'name': 'Test Entity',
        };
        
        final companion = entityFromFirestore('test-id', data);
        expect(companion.originId.value, equals(''));
      });
    });

    group('Encounter mapper safe defaults', () {
      test('handles missing preset with false default', () {
        final data = {
          'name': 'Test Encounter',
          'originId': 'origin-1',
        };
        
        final companion = encounterFromFirestore('test-id', data);
        expect(companion.preset.value, equals(false));
      });
    });

    group('Chapter mapper safe defaults', () {
      test('handles missing order with 0 default', () {
        final data = {
          'campaignId': 'campaign-1',
          'name': 'Chapter 1',
        };
        
        final companion = chapterFromFirestore('test-id', data);
        expect(companion.order.value, equals(0));
      });
    });

    group('MediaAsset mapper safe defaults', () {
      test('handles missing size with 0 default', () {
        final data = {
          'filename': 'test.jpg',
          'mime': 'image/jpeg',
        };
        
        final companion = mediaAssetFromFirestore('test-id', data);
        expect(companion.size.value, equals(0));
        expect(companion.filename.value, equals('test.jpg'));
      });

      test('handles missing mime with fallback', () {
        final data = {
          'filename': 'test.bin',
          'size': 1024,
        };
        
        final companion = mediaAssetFromFirestore('test-id', data);
        expect(companion.mime.value, equals('application/octet-stream'));
      });
    });

    group('Player mapper safe defaults', () {
      test('handles missing level with default 1', () {
        final data = {
          'campaignId': 'campaign-1',
          'name': 'Test Character',
          'className': 'Fighter',
        };
        
        final companion = playerFromFirestore('test-id', data);
        expect(companion.level.value, equals(1));
      });

      test('handles missing ability scores with default 10', () {
        final data = {
          'campaignId': 'campaign-1',
          'name': 'Test Character',
          'className': 'Fighter',
        };
        
        final companion = playerFromFirestore('test-id', data);
        expect(companion.str.value, equals(10));
        expect(companion.dex.value, equals(10));
        expect(companion.con.value, equals(10));
        expect(companion.intl.value, equals(10));
        expect(companion.wis.value, equals(10));
        expect(companion.cha.value, equals(10));
      });
    });
  });
}
