# Building Moonforge

Build instructions for different platforms.

## Prerequisites

- Flutter SDK (stable channel)
- Platform-specific SDKs (see [Platform-Specific](../development/platform-specific.md))

## Desktop

### Windows

```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

### Linux

```bash
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

### macOS

```bash
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/`

## Web

```bash
flutter build web --release
```

Output: `build/web/`

## Mobile

### Android

```bash
# APK
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

Requires macOS and Xcode.

## Build Modes

- `--release`: Optimized production build
- `--profile`: Performance profiling build
- `--debug`: Development build (default for `flutter run`)

## Packaging

For distributable packages, see [Packaging Guide](packaging-setup.md).

## Related Documentation

- [Packaging](packaging-setup.md)
- [Releases](releases.md)
- [CI/CD](ci-cd.md)
