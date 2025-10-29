# Platform-Specific Configuration

Platform-specific notes and configurations.

## Android

### Minimum SDK
- minSdkVersion: 21
- targetSdkVersion: 34

### Deep Linking
See [Routing](../architecture/routing.md) for AndroidManifest.xml configuration.

### Permissions
Add to AndroidManifest.xml as needed:
- INTERNET (included by default)
- WRITE_EXTERNAL_STORAGE (for media downloads)

## iOS

### Minimum Version
- iOS 12.0+

### Deep Linking
See [Routing](../architecture/routing.md) for Info.plist configuration.

### Permissions
Add to Info.plist:
- NSPhotoLibraryUsageDescription (for image picker)
- NSCameraUsageDescription (for camera access)

## Web

### Firebase Configuration
Ensure `firebase_options.dart` is configured for web.

### Deep Linking
Uses hash-based routing automatically.

## Windows

### Requirements
- Visual Studio 2022 with C++ workload
- Windows 10 SDK

### Protocol Registration
Requires MSIX packaging (see [Packaging](../deployment/packaging-setup.md)).

## Linux

### Requirements
```bash
sudo apt-get install ninja-build libgtk-3-dev
```

### Deep Linking
Configure `.desktop` file for protocol handling.

## macOS

### Requirements
- Xcode 14+
- macOS 10.15+

### Deep Linking
See [Routing](../architecture/routing.md) for Info.plist configuration.

## Related Documentation

- [Routing](../architecture/routing.md)
- [Testing Deep Links](testing-deep-links.md)
- [Building](../deployment/building.md)
