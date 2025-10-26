# Testing Deep Links in Moonforge

This guide provides step-by-step instructions for testing deep links on each platform.

## Prerequisites

Before testing, ensure you have:
1. Built the app for your target platform
2. The app is either running or installed on your device/emulator

## Supported Deep Link Formats

```
moonforge://campaign
moonforge://party/[id]
moonforge://settings
```

Note: Campaign-specific deep links with IDs are planned for future implementation.

## Platform-Specific Testing Instructions

### Android

#### Using ADB (for emulators or connected devices):

1. **Start the app** (if not already running)
2. **Test campaign link**:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "moonforge://campaign"
   ```

3. **Test party link with ID**:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "moonforge://party/test123"
   ```

4. **Test settings link**:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "moonforge://settings"
   ```

#### Notes:
- Special characters in URLs must be escaped when using ADB
- On Android 13+, you may need to manually enable deep links:
  - Go to **App Info** → **Open by default** → **Add link**
  - Your links should appear pre-filled

#### Using Android Studio App Links Assistant:

1. Open **Tools** → **App Links Assistant**
2. In the "Test App Links" section, enter your URL
3. Click **Run Test**

### iOS (Simulator)

1. **Ensure the app is built and running** on the simulator
2. **Open Terminal** and run:
   ```bash
   xcrun simctl openurl booted "moonforge://campaign"
   xcrun simctl openurl booted "moonforge://party/test123"
   xcrun simctl openurl booted "moonforge://settings"
   ```

3. **Verify** the app navigates to the correct screen

#### iOS (Physical Device):

1. **Create a test HTML page** with links:
   ```html
   <!DOCTYPE html>
   <html>
   <body>
     <h1>Moonforge Deep Link Tests</h1>
     <a href="moonforge://campaign">Open Campaign</a><br>
     <a href="moonforge://party/test123">Open Party test123</a><br>
     <a href="moonforge://settings">Open Settings</a>
   </body>
   </html>
   ```

2. **Host it** or email it to yourself
3. **Tap the links** on your device

### macOS

#### Using Terminal:
```bash
open "moonforge://campaign"
open "moonforge://party/test123"
open "moonforge://settings"
```

#### Using Browser:
1. Open Safari or any browser
2. Type in the address bar:
   ```
   moonforge://campaign
   ```
3. Press Enter and allow the app to open

#### Using a Test HTML File:
Create `test_links.html`:
```html
<!DOCTYPE html>
<html>
<body>
  <h1>Moonforge Deep Link Tests</h1>
  <a href="moonforge://campaign">Open Campaign</a><br>
  <a href="moonforge://party/test123">Open Party test123</a><br>
  <a href="moonforge://settings">Open Settings</a>
</body>
</html>
```

Open it in a browser and click the links.

### Windows

#### Using Browser:
1. Open Edge, Chrome, or Firefox
2. Type in the address bar:
   ```
   moonforge://campaign
   ```
3. Press Enter
4. Allow the browser to open Moonforge

#### Using Run Dialog:
1. Press `Win + R`
2. Type: `moonforge://party/test123`
3. Press Enter

#### Notes:
- **Protocol registration** only works in packaged apps (MSIX)
- For development builds, you may need to manually register the protocol in the Windows Registry
- If you're using MSIX, ensure `protocol_activation` is configured in `pubspec.yaml`

### Linux

#### Using Terminal:
```bash
xdg-open "moonforge://campaign"
xdg-open "moonforge://party/test123"
xdg-open "moonforge://settings"
```

#### Using Browser:
1. Open Firefox or Chromium
2. Type in the address bar:
   ```
   moonforge://campaign
   ```
3. Press Enter and allow the app to open

#### Notes:
- Ensure the `.desktop` file is properly configured
- For Flatpak/Snap distributions, additional setup may be required (see main docs)

### Web

#### Development Server:
1. Start the development server: `flutter run -d chrome`
2. Navigate to URLs directly:
   ```
   http://localhost:[port]/#/campaign
   http://localhost:[port]/#/party/test123
   http://localhost:[port]/#/settings
   ```

#### Production Build:
Deep links work as regular web URLs through the hash-based routing.

## Expected Behavior

When clicking/opening a deep link:

1. **If the app is not running**: The app should launch and navigate to the specified screen
2. **If the app is running**: The app should come to the foreground and navigate to the specified screen
3. **Invalid or unknown paths**: The app should navigate to the home screen

## Verification Checklist

For each platform, verify:

- [ ] App launches from deep link when closed
- [ ] App comes to foreground from deep link when in background
- [ ] Navigation occurs to the correct screen
- [ ] Deep link with ID parameter works correctly
- [ ] Deep link without ID parameter works correctly
- [ ] Invalid deep links navigate to home screen
- [ ] Console shows debug messages (in debug builds):
  - "Initial deep link: [uri]" or "Received deep link: [uri]"

## Debug Messages

In debug mode, the app logs deep link events to the console:

```
Initial deep link: moonforge://campaign/abc123
Received deep link: moonforge://party/xyz789
Unknown deep link path: unknown
```

Check these messages to verify deep links are being received correctly.

## Troubleshooting

### No navigation occurs
1. Check console for error messages
2. Verify the route exists in `app_router.dart`
3. Ensure `DeepLinkService` is initialized in `main.dart`

### App doesn't open
1. **Android**: Check if deep links are enabled in App Info
2. **iOS**: Verify `FlutterDeepLinkingEnabled` is `false` in Info.plist
3. **Windows**: Ensure protocol is registered (use MSIX packaging)
4. **Linux**: Check `.desktop` file and mime type registration

### App opens but doesn't navigate
1. Check the `DeepLinkService._handleDeepLink()` implementation
2. Verify the URI scheme is "moonforge"
3. Check that `go_router` routes match the deep link paths

## Advanced Testing

### Testing with Custom IDs

Replace placeholders with real IDs from your database:

```bash
# Android
adb shell am start -a android.intent.action.VIEW -d "moonforge://party/actual-party-id-123"

# iOS Simulator
xcrun simctl openurl booted "moonforge://party/actual-party-id-123"

# macOS/Linux
open "moonforge://party/actual-party-id-123"
```

### Testing Error Handling

Test with malformed or invalid deep links:

```bash
# Invalid scheme
moonforge-invalid://campaign

# Unknown path
moonforge://unknown-path

# Missing required ID (if applicable)
moonforge://party/
```

Verify the app handles these gracefully.

## Automated Testing

For CI/CD pipelines, consider:

1. **Android**: Use UI Automator or Espresso with intents
2. **iOS**: Use XCTest with URL schemes
3. **Integration tests**: Mock `AppLinks` for unit testing deep link logic

## Notes

- Deep link testing requires the app to be properly signed on iOS
- Some platforms may require the app to be in the foreground for deep links to work reliably
- Browser security settings may block custom URL schemes - allow them when prompted
