# Fastforge Setup and Distribution Guide

This guide explains how to build, package, and distribute Moonforge using Fastforge and auto_updater for automatic updates.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Local Development and Testing](#local-development-and-testing)
- [Building and Packaging](#building-and-packaging)
- [Releasing to GitHub](#releasing-to-github)
- [Setting Up Auto-Updates](#setting-up-auto-updates)
- [Manual Release Process](#manual-release-process)
- [Troubleshooting](#troubleshooting)

## Overview

Moonforge uses:
- **Fastforge**: For building and packaging desktop applications (Windows, macOS, Linux)
- **auto_updater**: For automatic updates on desktop platforms (based on Sparkle for macOS and WinSparkle for Windows)
- **GitHub Releases**: For hosting and distributing packages
- **GitHub Actions**: For automated CI/CD builds

## Prerequisites

### Required Software

1. **Flutter SDK** (stable channel)
   ```bash
   flutter --version
   # Should show Flutter 3.x or later
   ```

2. **Dart SDK** (included with Flutter)
   ```bash
   dart --version
   ```

3. **Fastforge CLI**
   ```bash
   dart pub global activate fastforge
   ```
   
   Make sure your PATH includes the global Dart packages directory:
   - **Windows**: `%APPDATA%\Pub\Cache\bin`
   - **macOS/Linux**: `$HOME/.pub-cache/bin`

### Platform-Specific Requirements

#### Windows
- Visual Studio 2022 or later with "Desktop development with C++" workload
- Windows 10 SDK

#### macOS
- Xcode 14 or later
- Xcode Command Line Tools: `xcode-select --install`
- For signed builds and updates: Apple Developer account

#### Linux
- GTK 3 development libraries:
  ```bash
  sudo apt-get install ninja-build libgtk-3-dev
  ```

### GitHub Requirements

- A GitHub account with access to the Moonforge repository
- Personal Access Token (PAT) with `repo` scope for GitHub Releases (if releasing manually)

## Local Development and Testing

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/EmilyMoonstone/Moonforge.git
cd Moonforge/moonforge

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs
```

### 2. Run the Application

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### 3. Build for Testing

```bash
# Build without packaging
flutter build windows --release  # or macos, linux
```

## Building and Packaging

### Using Fastforge Locally

The `distribute_options.yaml` configuration file defines how Fastforge packages the application.

#### Package for a Single Platform

```bash
# From the repository root
cd /path/to/Moonforge

# Package for Windows
fastforge package --platform windows --target exe

# Package for macOS
fastforge package --platform macos --target dmg

# Package for Linux (AppImage)
fastforge package --platform linux --target appimage

# Package for Linux (DEB)
fastforge package --platform linux --target deb
```

#### Package Using Predefined Release Configurations

```bash
# Production release (all platforms defined in config)
fastforge release --name production

# Beta release
fastforge release --name beta
```

### Output Location

Packaged applications will be in the `dist/` directory:
```
dist/
├── <version>/
│   ├── Moonforge-<version>-windows.exe
│   ├── Moonforge-<version>-macos.dmg
│   ├── Moonforge-<version>-linux.AppImage
│   └── Moonforge-<version>-linux.deb
```

## Releasing to GitHub

### Automated Release via GitHub Actions

The repository includes a GitHub Actions workflow (`.github/workflows/release.yml`) that automatically builds and releases when you push a tag.

#### Creating a Release

1. **Update the version** in `moonforge/pubspec.yaml`:
   ```yaml
   version: 0.2.0+2
   ```

2. **Update the changelog** (optional but recommended):
   - Edit `CHANGELOG.md` to document changes

3. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Bump version to 0.2.0"
   git push origin main
   ```

4. **Create and push a tag**:
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```

5. **Monitor the workflow**:
   - Go to the "Actions" tab in GitHub
   - Watch the "Build and Release with Fastforge" workflow
   - Once complete, check the "Releases" page

### Manual Release

If you need to release manually:

1. **Build and package locally** (see [Building and Packaging](#building-and-packaging))

2. **Create a GitHub Release**:
   - Go to https://github.com/EmilyMoonstone/Moonforge/releases/new
   - Choose or create a tag (e.g., `v0.2.0`)
   - Fill in the release title and description
   - Upload the files from the `dist/` directory
   - Publish the release

3. **Update appcast files** (see [Setting Up Auto-Updates](#setting-up-auto-updates))

## Setting Up Auto-Updates

Auto-updates allow users to receive new versions automatically without manually downloading.

### How It Works

- **macOS**: Uses Sparkle framework, reads `appcast.xml`
- **Windows**: Uses WinSparkle, reads `appcast.json`
- The app checks for updates on startup and periodically (default: every 24 hours)

### Appcast Files

The appcast files are located in the `appcast/` directory:
- `appcast/appcast.xml` - for macOS
- `appcast/appcast.json` - for Windows

### Updating Appcast for a New Release

When you publish a new release, you need to update these files:

#### For macOS (appcast.xml)

Add a new `<item>` entry at the top of the feed:

```xml
<item>
  <title>Version 0.2.0</title>
  <link>https://github.com/EmilyMoonstone/Moonforge/releases/tag/v0.2.0</link>
  <description><![CDATA[
    <h2>What's New in Version 0.2.0</h2>
    <ul>
      <li>New feature: Campaign templates</li>
      <li>Bug fix: Fixed character import</li>
      <li>Improvement: Faster sync</li>
    </ul>
  ]]></description>
  <pubDate>Mon, 01 Jan 2024 12:00:00 +0000</pubDate>
  <sparkle:version>0.2.0</sparkle:version>
  <sparkle:shortVersionString>0.2.0</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>10.13</sparkle:minimumSystemVersion>
  <enclosure 
    url="https://github.com/EmilyMoonstone/Moonforge/releases/download/v0.2.0/Moonforge-0.2.0-macos.dmg" 
    length="52428800"
    type="application/octet-stream" />
</item>
```

**Note**: For signed builds (recommended for production), add `sparkle:edSignature` attribute. See [Code Signing](#code-signing).

#### For Windows (appcast.json)

Add a new entry to the `items` array:

```json
{
  "title": "Version 0.2.0",
  "version": "0.2.0",
  "description": "<h2>What's New in Version 0.2.0</h2><ul><li>New feature: Campaign templates</li><li>Bug fix: Fixed character import</li><li>Improvement: Faster sync</li></ul>",
  "pubDate": "2024-01-01T12:00:00Z",
  "link": "https://github.com/EmilyMoonstone/Moonforge/releases/tag/v0.2.0",
  "url": "https://github.com/EmilyMoonstone/Moonforge/releases/download/v0.2.0/Moonforge-0.2.0-windows.exe"
}
```

#### Important Notes

1. **File Size**: Update the `length` (macOS) to the actual file size in bytes:
   ```bash
   ls -l dist/v0.2.0/Moonforge-0.2.0-macos.dmg | awk '{print $5}'
   ```

2. **Date Format**: 
   - macOS: RFC 822 format (e.g., `Mon, 01 Jan 2024 12:00:00 +0000`)
   - Windows: ISO 8601 format (e.g., `2024-01-01T12:00:00Z`)

3. **Commit and Push**: After updating appcast files:
   ```bash
   git add appcast/
   git commit -m "Update appcast for v0.2.0"
   git push origin main
   ```

### Hosting Appcast Files

The appcast files need to be publicly accessible. Current setup uses raw GitHub URLs:
- macOS: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.xml`
- Windows: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.json`

**Alternative hosting options**:
- GitHub Pages (recommended for production)
- Your own web server
- CDN (e.g., CloudFlare, AWS S3)

### Testing Auto-Updates

1. **Build and run your app** with the auto_updater integration
2. **Publish a test release** with a higher version number
3. **Update the appcast files** to point to the test release
4. **Restart your app** - it should detect the update

To manually trigger an update check, you can add a "Check for Updates" menu item that calls:
```dart
AutoUpdaterService.instance.checkForUpdates();
```

## Code Signing

### macOS

Code signing is highly recommended (and required for distribution outside the App Store).

1. **Get a Developer ID certificate** from Apple Developer portal

2. **Sign your app**:
   ```bash
   codesign --deep --force --verify --verbose \
     --sign "Developer ID Application: Your Name (TEAM_ID)" \
     /path/to/Moonforge.app
   ```

3. **Generate Sparkle signature** for appcast:
   ```bash
   # Install Sparkle's generate_appcast tool
   # From https://sparkle-project.org/
   
   ./generate_appcast /path/to/releases
   ```
   
   This will generate signatures for your appcast entries.

4. **Notarize your app** (required for macOS 10.15+):
   ```bash
   xcrun notarytool submit Moonforge-0.2.0-macos.dmg \
     --apple-id your@email.com \
     --team-id TEAM_ID \
     --password app-specific-password \
     --wait
   ```

### Windows

While not strictly required, signing prevents "Unknown Publisher" warnings.

1. **Get a code signing certificate** (e.g., from Sectigo, DigiCert)

2. **Sign your executable**:
   ```bash
   signtool sign /f certificate.pfx /p password \
     /tr http://timestamp.digicert.com \
     /td sha256 /fd sha256 \
     Moonforge-0.2.0-windows.exe
   ```

## Manual Release Process

If you need to do everything manually without GitHub Actions:

1. **Update version** in `pubspec.yaml`

2. **Build for each platform**:
   ```bash
   # On Windows
   fastforge package --platform windows --target exe
   
   # On macOS
   fastforge package --platform macos --target dmg
   
   # On Linux
   fastforge package --platform linux --target appimage
   fastforge package --platform linux --target deb
   ```

3. **Sign executables** (see [Code Signing](#code-signing))

4. **Create GitHub Release**:
   - Go to https://github.com/EmilyMoonstone/Moonforge/releases/new
   - Create tag `v0.2.0`
   - Add release notes
   - Upload all files from `dist/`
   - Publish

5. **Update appcast files** (see [Setting Up Auto-Updates](#setting-up-auto-updates))

6. **Test the update**:
   - Install the previous version
   - Run it and verify it detects the new update

## Troubleshooting

### Fastforge Issues

**Problem**: `fastforge: command not found`
- **Solution**: Make sure Dart global packages are in your PATH:
  ```bash
  export PATH="$PATH:$HOME/.pub-cache/bin"  # macOS/Linux
  set PATH=%PATH%;%APPDATA%\Pub\Cache\bin   # Windows
  ```

**Problem**: Build fails on Linux
- **Solution**: Install required dependencies:
  ```bash
  sudo apt-get install ninja-build libgtk-3-dev
  ```

### Auto-Updater Issues

**Problem**: App doesn't check for updates
- **Solution**: 
  - Check that the feed URL is correct in `auto_updater_service.dart`
  - Verify appcast files are accessible at the URLs
  - Check logs for errors (use `flutter run` to see console output)

**Problem**: Update available but won't download
- **Solution**:
  - Verify the download URL in the appcast is correct
  - Check file permissions and accessibility
  - On macOS, ensure the app is signed

**Problem**: "This app can't run on your PC" (Windows)
- **Solution**: The app needs to be signed, or users need to click "More info" → "Run anyway"

### GitHub Actions Issues

**Problem**: Workflow fails during build
- **Solution**: 
  - Check the Actions logs for specific errors
  - Ensure all dependencies are correctly specified
  - Verify Flutter version compatibility

**Problem**: Release created but no assets uploaded
- **Solution**: 
  - Check that artifacts were uploaded successfully in previous jobs
  - Verify the `files` pattern in the release step
  - Check repository permissions

## Additional Resources

- [Fastforge Documentation](https://fastforge.dev/)
- [auto_updater Documentation](https://pub.dev/packages/auto_updater)
- [Sparkle Framework](https://sparkle-project.org/) (macOS)
- [WinSparkle](https://winsparkle.org/) (Windows)
- [Flutter Desktop Documentation](https://docs.flutter.dev/platform-integration/desktop)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Support

If you encounter issues not covered in this guide:
1. Check the [Issues](https://github.com/EmilyMoonstone/Moonforge/issues) page
2. Create a new issue with detailed information
3. Join the discussion in Fastforge or auto_updater communities

---

**Last Updated**: October 27, 2025
