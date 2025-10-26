# Deep Linking in Moonforge

This document describes the deep linking implementation in Moonforge and how to test it on various platforms.

## Overview

Moonforge supports deep linking across all platforms (Web, Android, iOS, macOS, Windows, and Linux) using the `moonforge://` URL scheme. The implementation uses the `app_links` package integrated with `go_router`.

## Supported Deep Link Format

```
moonforge://campaign/[id]
moonforge://party/[id]
moonforge://settings
```

## Architecture

- **DeepLinkService** (`lib/core/services/deep_link_service.dart`): Main service that handles deep link parsing and routing
- **AppRouter** (`lib/core/services/app_router.dart`): Existing go_router configuration
- **main.dart**: Initializes the deep link service

## Platform-Specific Setup

### Android

**Configuration**: `android/app/src/main/AndroidManifest.xml`

- Disabled Flutter's default deep linking with `flutter_deeplinking_enabled` meta-data
- Added intent filters for `moonforge://` scheme

**Testing**:
```bash
adb shell am start -a android.intent.action.VIEW \
  -d "moonforge://campaign/abc123"

adb shell am start -a android.intent.action.VIEW \
  -d "moonforge://party/xyz789"
```

Note: Special characters must be escaped when using ADB.

### iOS

**Configuration**: `ios/Runner/Info.plist`

- Disabled Flutter deep linking with `FlutterDeepLinkingEnabled`
- Added `CFBundleURLTypes` for the `moonforge://` scheme

**Testing** (on Simulator):
```bash
xcrun simctl openurl booted "moonforge://campaign/abc123"
xcrun simctl openurl booted "moonforge://party/xyz789"
```

### macOS

**Configuration**:
- `macos/Runner/Info.plist`: URL scheme configuration
- `macos/Runner/AppDelegate.swift`: Universal link handling

**Testing** (open in browser or terminal):
```bash
open "moonforge://campaign/abc123"
```

### Windows

**Configuration**: `windows/runner/main.cpp`

- Added app_links plugin header
- Implemented `SendAppLinkToInstance` for single-instance handling
- Protocol registration happens via MSIX packaging (see notes below)

**Testing**: Open in browser
```
moonforge://campaign/abc123
```

**Note for Packaged Apps**: 
If using MSIX packaging (recommended), add to your `msix_config`:
```yaml
msix_config:
  protocol_activation: moonforge
```

### Linux

**Configuration**: `linux/runner/my_application.cc`

- Modified application activation to support single instance
- Changed flags to handle command line and open events
- Returns FALSE from `local_command_line` to propagate to plugin

**Testing** (open in browser or terminal):
```bash
xdg-open "moonforge://campaign/abc123"
```

**Additional Setup for Distribution**:
- Ensure `APPLICATION_ID` matches your `.desktop` file name
- For Flatpak: Follow setup at [FlatHub example](https://github.com/flathub/io.appflowy.AppFlowy)
- For Snap: Add DBus slot to `snapcraft.yaml`
- For .deb/.rpm: Add to `make_config.yaml`:
  ```yaml
  supported_mime_type:
    - x-scheme-handler/moonforge
  ```

### Web

Deep linking on web works automatically through the browser's URL handling and go_router.

**Testing**: Navigate to
```
http://localhost:[port]/#/campaign
http://localhost:[port]/#/party/xyz789
```

## Implementation Details

### How Deep Links are Processed

1. **App Launch**: When the app launches from a deep link, `DeepLinkService.initialize()` retrieves the initial link via `AppLinks.getInitialLink()`
2. **Runtime**: When a link arrives while the app is running, the `uriLinkStream` delivers it
3. **Routing**: The service parses the URI and calls appropriate `GoRouter` methods to navigate

### Adding New Deep Link Routes

To add support for a new deep link path:

1. Update `DeepLinkService._handleDeepLink()` in `lib/core/services/deep_link_service.dart`:
   ```dart
   case 'mynewroute':
     if (pathSegments.length > 1) {
       final id = pathSegments[1];
       router.go('/mynewroute/$id');
     } else {
       router.go('/mynewroute');
     }
     break;
   ```

2. For Android, optionally add a specific host in `AndroidManifest.xml`:
   ```xml
   <data android:scheme="moonforge" android:host="mynewroute" />
   ```

3. Ensure your route exists in `app_router.dart`

## Troubleshooting

### Links Not Working on Android 13+

On Android 13 and later, you may need to manually activate deep links in development:
1. Go to App Info/Settings
2. Open by default
3. Add link
4. Your links should be pre-filled

### Links Not Working on iOS

Ensure:
- `FlutterDeepLinkingEnabled` is set to `false`
- Your AppDelegate returns `true` from `didFinishLaunchingWithOptions`
- No other packages are intercepting the links

### Links Not Working on Windows (Debug Mode)

Windows protocol registration only works in packaged apps. Use MSIX for testing or manual registry setup for development.

### Links Not Working on Linux

Ensure:
- `APPLICATION_ID` is correctly set
- For distribution, the proper mime type handlers are registered

## Security Considerations

- Always validate deep link parameters before using them
- Don't trust user-provided IDs - verify they exist and the user has access
- Consider rate limiting deep link handling to prevent abuse

## Future Enhancements

- Support for more complex routing patterns
- Query parameter handling
- Deep link analytics
- Campaign invite codes via deep links
