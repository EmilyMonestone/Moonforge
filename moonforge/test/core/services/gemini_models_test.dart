import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/models/ai/generation_request.dart';
import 'package:moonforge/core/models/ai/story_context.dart';

void main() {
  group('StoryContext', () {
    test('creates instance with required fields', () {
      const context = StoryContext(
        campaignName: 'Test Campaign',
      );

      expect(context.campaignName, 'Test Campaign');
      expect(context.entities, isEmpty);
    });

    test('serializes to JSON', () {
      const context = StoryContext(
        campaignName: 'Test Campaign',
        campaignDescription: 'A test campaign',
        entities: [
          EntityInfo(
            id: '1',
            name: 'Test NPC',
            kind: 'character',
            summary: 'A friendly NPC',
          ),
        ],
      );

      final json = context.toJson();

      expect(json['campaignName'], 'Test Campaign');
      expect(json['campaignDescription'], 'A test campaign');
      expect(json['entities'], isA<List>());
      expect((json['entities'] as List).length, 1);
    });

    test('deserializes from JSON', () {
      final json = {
        'campaignName': 'Test Campaign',
        'campaignDescription': 'A test campaign',
        'entities': [
          {
            'id': '1',
            'name': 'Test NPC',
            'kind': 'character',
            'summary': 'A friendly NPC',
            'tags': ['friendly', 'merchant'],
          }
        ],
      };

      final context = StoryContext.fromJson(json);

      expect(context.campaignName, 'Test Campaign');
      expect(context.campaignDescription, 'A test campaign');
      expect(context.entities.length, 1);
      expect(context.entities.first.name, 'Test NPC');
      expect(context.entities.first.tags, ['friendly', 'merchant']);
    });
  });

  group('CompletionRequest', () {
    test('creates instance with required fields', () {
      const context = StoryContext(campaignName: 'Test');
      const request = CompletionRequest(
        context: context,
        currentContent: 'The party entered the tavern...',
      );

      expect(request.currentContent, 'The party entered the tavern...');
      expect(request.maxTokens, 500);
    });

    test('serializes to JSON', () {
      const context = StoryContext(campaignName: 'Test');
      const request = CompletionRequest(
        context: context,
        currentContent: 'The party entered the tavern...',
        desiredDirection: 'Introduce a mysterious stranger',
        maxTokens: 600,
      );

      final json = request.toJson();

      expect(json['currentContent'], 'The party entered the tavern...');
      expect(json['desiredDirection'], 'Introduce a mysterious stranger');
      expect(json['maxTokens'], 600);
    });
  });

  group('SectionGenerationRequest', () {
    test('creates instance with required fields', () {
      const context = StoryContext(campaignName: 'Test');
      const request = SectionGenerationRequest(
        context: context,
        sectionType: 'scene',
        title: 'The Tavern Brawl',
      );

      expect(request.sectionType, 'scene');
      expect(request.title, 'The Tavern Brawl');
      expect(request.keyElements, isEmpty);
    });

    test('includes key elements and outline', () {
      const context = StoryContext(campaignName: 'Test');
      const request = SectionGenerationRequest(
        context: context,
        sectionType: 'scene',
        title: 'The Tavern Brawl',
        outline: 'A fight breaks out in the tavern',
        keyElements: ['bar fight', 'mysterious thief', 'stolen artifact'],
      );

      expect(request.outline, 'A fight breaks out in the tavern');
      expect(request.keyElements.length, 3);
      expect(request.keyElements.first, 'bar fight');
    });
  });

  group('NpcGenerationRequest', () {
    test('creates instance with required fields', () {
      const context = StoryContext(campaignName: 'Test');
      const request = NpcGenerationRequest(
        context: context,
      );

      expect(request.context.campaignName, 'Test');
      expect(request.traits, isEmpty);
    });

    test('includes NPC constraints', () {
      const context = StoryContext(campaignName: 'Test');
      const request = NpcGenerationRequest(
        context: context,
        role: 'Tavern keeper',
        species: 'Dwarf',
        alignment: 'Lawful Good',
        relationshipToParty: 'Friendly',
        traits: ['gruff', 'loyal', 'wise'],
      );

      expect(request.role, 'Tavern keeper');
      expect(request.species, 'Dwarf');
      expect(request.alignment, 'Lawful Good');
      expect(request.traits.length, 3);
    });
  });
}
