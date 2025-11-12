import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';

void main() {
  group('DomainVisuals', () {
    test('returns valid config for all domain types', () {
      for (final type in DomainType.values) {
        final config = DomainVisuals.getConfig(type);
        expect(config, isNotNull);
        expect(config.icon, isNotNull);
        // semanticLabel is optional but should exist for most types
      }
    });

    test('campaign has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.campaign);
      expect(icon, equals(Icons.book_outlined));
    });

    test('chapter has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.chapter);
      expect(icon, equals(Icons.menu_book_outlined));
    });

    test('adventure has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.adventure);
      expect(icon, equals(Icons.auto_stories_outlined));
    });

    test('scene has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.scene);
      expect(icon, equals(Icons.theaters_outlined));
    });

    test('session has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.session);
      expect(icon, equals(Icons.event_note_outlined));
    });

    test('party has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.party);
      expect(icon, equals(Icons.group_outlined));
    });

    test('encounter has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.encounter);
      expect(icon, equals(Icons.gavel_outlined));
    });

    test('entityNpc has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.entityNpc);
      expect(icon, equals(Icons.face_outlined));
    });

    test('entityMonster has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.entityMonster);
      expect(icon, equals(Icons.bug_report_outlined));
    });

    test('entityPlace has correct icon', () {
      final icon = DomainVisuals.getIcon(DomainType.entityPlace);
      expect(icon, equals(Icons.place_outlined));
    });
  });

  group('DomainVisuals - Entity Kind Conversion', () {
    test('converts "npc" to entityNpc', () {
      final type = DomainVisuals.entityKindToDomainType('npc');
      expect(type, equals(DomainType.entityNpc));
    });

    test('converts "monster" to entityMonster', () {
      final type = DomainVisuals.entityKindToDomainType('monster');
      expect(type, equals(DomainType.entityMonster));
    });

    test('converts "group" to entityGroup', () {
      final type = DomainVisuals.entityKindToDomainType('group');
      expect(type, equals(DomainType.entityGroup));
    });

    test('converts "place" to entityPlace', () {
      final type = DomainVisuals.entityKindToDomainType('place');
      expect(type, equals(DomainType.entityPlace));
    });

    test('converts "item" to entityItem', () {
      final type = DomainVisuals.entityKindToDomainType('item');
      expect(type, equals(DomainType.entityItem));
    });

    test('converts "handout" to entityHandout', () {
      final type = DomainVisuals.entityKindToDomainType('handout');
      expect(type, equals(DomainType.entityHandout));
    });

    test('converts "journal" to entityJournal', () {
      final type = DomainVisuals.entityKindToDomainType('journal');
      expect(type, equals(DomainType.entityJournal));
    });

    test('converts unknown kind to entityGeneric', () {
      final type = DomainVisuals.entityKindToDomainType('unknown');
      expect(type, equals(DomainType.entityGeneric));
    });

    test('is case-insensitive', () {
      expect(
        DomainVisuals.entityKindToDomainType('NPC'),
        equals(DomainType.entityNpc),
      );
      expect(
        DomainVisuals.entityKindToDomainType('MONSTER'),
        equals(DomainType.entityMonster),
      );
    });

    test('getEntityKindIcon returns correct icon for "npc"', () {
      final icon = DomainVisuals.getEntityKindIcon('npc');
      expect(icon, equals(Icons.face_outlined));
    });

    test('getEntityKindIcon returns correct icon for "place"', () {
      final icon = DomainVisuals.getEntityKindIcon('place');
      expect(icon, equals(Icons.place_outlined));
    });
  });

  group('DomainTypeVisuals Extension', () {
    test('extension provides icon access', () {
      final icon = DomainType.campaign.icon;
      expect(icon, equals(Icons.book_outlined));
    });

    test('extension provides visuals config access', () {
      final visuals = DomainType.scene.visuals;
      expect(visuals, isNotNull);
      expect(visuals.icon, equals(Icons.theaters_outlined));
    });

    test('extension provides color access', () {
      final color = DomainType.adventure.color;
      // Color may be null, just verify it doesn't throw
      expect(color, isA<Color?>());
    });

    test('extension provides semanticLabel access', () {
      final label = DomainType.party.semanticLabel;
      expect(label, isNotNull);
      expect(label, equals('Party'));
    });

    testWidgets('extension toIcon creates valid Icon widget',
        (WidgetTester tester) async {
      final icon = DomainType.campaign.toIcon();
      expect(icon, isA<Icon>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: icon,
          ),
        ),
      );

      expect(find.byIcon(Icons.book_outlined), findsOneWidget);
    });

    testWidgets('extension toIcon respects custom size and color',
        (WidgetTester tester) async {
      final icon = DomainType.chapter.toIcon(
        size: 32,
        color: Colors.red,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: icon,
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, equals(32));
      expect(iconWidget.color, equals(Colors.red));
    });
  });

  group('DomainVisualConfig', () {
    test('can be created with icon only', () {
      const config = DomainVisualConfig(
        icon: Icons.star,
      );
      expect(config.icon, equals(Icons.star));
      expect(config.color, isNull);
      expect(config.semanticLabel, isNull);
    });

    test('can be created with all properties', () {
      const config = DomainVisualConfig(
        icon: Icons.star,
        color: Colors.blue,
        semanticLabel: 'Star',
      );
      expect(config.icon, equals(Icons.star));
      expect(config.color, equals(Colors.blue));
      expect(config.semanticLabel, equals('Star'));
    });
  });
}
