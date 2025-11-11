import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/scene/utils/scene_export.dart';

void main() {
  group('SceneExport.extractReadAloudText', () {
    Scene buildScene(Map<String, dynamic>? content) => Scene(
      id: 's1',
      adventureId: 'a1',
      name: 'Test Scene',
      order: 1,
      summary: null,
      content: content,
      entityIds: const [],
      createdAt: null,
      updatedAt: null,
      rev: 1,
    );

    test('returns empty list when content is null or empty', () {
      expect(SceneExport.extractReadAloudText(buildScene(null)), isEmpty);
      expect(
        SceneExport.extractReadAloudText(buildScene({'ops': []})),
        isEmpty,
      );
    });

    test('detects blockquote lines and merges consecutive ones', () {
      final content = {
        'ops': [
          // Non-quote paragraph
          {'insert': 'Intro not quoted'},
          {'insert': '\n'},

          // Quote block - two lines that should be merged
          {'insert': 'Auf dem Dorfplatz von Hohlried'},
          {
            'insert': '\n',
            'attributes': {'blockquote': true},
          },
          {'insert': 'hängt die Luft noch nach Regen. Mühlenflügel knarren.'},
          {
            'insert': '\n',
            'attributes': {'blockquote': true},
          },

          // Back to normal text
          {'insert': 'End normal'},
          {'insert': '\n'},
        ],
      };

      final result = SceneExport.extractReadAloudText(buildScene(content));

      expect(result.length, 1);
      expect(
        result.first,
        'Auf dem Dorfplatz von Hohlried\nhängt die Luft noch nach Regen. Mühlenflügel knarren.',
      );
    });

    test('accepts attribute name "quote" as well as "blockquote"', () {
      final content = {
        'ops': [
          {'insert': 'Line quoted'},
          {
            'insert': '\n',
            'attributes': {'quote': true},
          },
        ],
      };

      final result = SceneExport.extractReadAloudText(buildScene(content));
      expect(result, ['Line quoted']);
    });
  });
}
