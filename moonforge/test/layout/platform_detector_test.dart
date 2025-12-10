import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/layout/platform_detector.dart';

void main() {
  group('PlatformDetector', () {
    test('isMobilePlatform and isDesktopPlatform are mutually exclusive', () {
      // One and only one should be true
      expect(
        PlatformDetector.isMobilePlatform || PlatformDetector.isDesktopPlatform,
        isTrue,
      );
      expect(
        PlatformDetector.isMobilePlatform && PlatformDetector.isDesktopPlatform,
        isFalse,
      );
    });

    test('exactly one platform type should be detected', () {
      final mobileCount = PlatformDetector.isMobilePlatform ? 1 : 0;
      final desktopCount = PlatformDetector.isDesktopPlatform ? 1 : 0;
      expect(mobileCount + desktopCount, equals(1));
    });
  });
}
