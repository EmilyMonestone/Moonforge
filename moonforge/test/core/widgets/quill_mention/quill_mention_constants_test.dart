import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention_constants.dart';

/// Basic tests for quill mention constants
void main() {
  group('Quill Mention Constants', () {
    test('prefixes are correctly defined', () {
      expect(prefixHashtag, '-moonforge-hashtag-entity-');
      expect(prefixMention, '-moonforge-mention-entity-');
    });

    test('prefixes are different', () {
      expect(prefixHashtag, isNot(equals(prefixMention)));
    });

    test('prefixes start with dash', () {
      expect(prefixHashtag.startsWith('-'), isTrue);
      expect(prefixMention.startsWith('-'), isTrue);
    });

    test('prefixes end with dash', () {
      expect(prefixHashtag.endsWith('-'), isTrue);
      expect(prefixMention.endsWith('-'), isTrue);
    });

    test('default styles are configured', () {
      expect(defaultMentionStyles, isNotNull);
      expect(defaultMentionStyles.link, isNotNull);
    });
  });
}
