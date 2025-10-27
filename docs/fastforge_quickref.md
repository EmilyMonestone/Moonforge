# Fastforge Quick Reference

Quick command reference for building and releasing Moonforge with Fastforge.

## Installation

```bash
# Install Fastforge globally
dart pub global activate fastforge

# Verify installation
fastforge --version
```

## Common Commands

### Local Packaging

```bash
# Package for current platform
fastforge package

# Package for specific platform
fastforge package --platform windows --target exe
fastforge package --platform macos --target dmg
fastforge package --platform linux --target appimage
fastforge package --platform linux --target deb

# Use predefined release configuration
fastforge release --name production
fastforge release --name beta
```

### Build Arguments

```bash
# With custom dart defines
fastforge package --platform windows --target exe \
  --build-args="dart-define:APP_ENV=production,dart-define:APP_NAME=Moonforge"

# With target platform specification
fastforge package --platform android --target apk \
  --build-args="target-platform:android-arm,android-arm64"
```

### Publishing

```bash
# Package and publish to GitHub
fastforge release --name production

# The config file specifies:
# - What to build (platforms/targets)
# - Where to publish (GitHub Releases)
# - Build arguments to use
```

## Configuration File Reference

The `distribute_options.yaml` file defines:

```yaml
# Environment variables
variables:
  GITHUB_TOKEN: ${GITHUB_TOKEN}

# Output directory for packages
output: dist/

# Release configurations
releases:
  - name: production
    jobs:
      - name: release-windows
        package:
          platform: windows
          target: exe
          build_args:
            dart-define:
              APP_ENV: production
        publish_to: github
```

## Release Workflow

1. **Update version** in `moonforge/pubspec.yaml`
2. **Commit changes**: `git commit -am "Bump version to X.Y.Z"`
3. **Create tag**: `git tag vX.Y.Z`
4. **Push**: `git push origin main && git push origin vX.Y.Z`
5. **GitHub Actions** builds and publishes automatically
6. **Update appcast files** for auto-updater:
   - Edit `appcast/appcast.xml` (macOS)
   - Edit `appcast/appcast.json` (Windows)
7. **Commit appcast**: `git commit -am "Update appcast for vX.Y.Z" && git push`

## Version Format

- **pubspec.yaml**: `version: X.Y.Z+BUILD` (e.g., `0.2.0+2`)
- **Git tag**: `vX.Y.Z` (e.g., `v0.2.0`)
- **Appcast**: `X.Y.Z` (e.g., `0.2.0`)

## Appcast Update Template

### macOS (appcast.xml)

```xml
<item>
  <title>Version X.Y.Z</title>
  <link>https://github.com/EmilyMoonstone/Moonforge/releases/tag/vX.Y.Z</link>
  <description><![CDATA[
    <h2>What's New</h2>
    <ul><li>Feature or fix</li></ul>
  ]]></description>
  <pubDate>Day, DD Mon YYYY HH:MM:SS +0000</pubDate>
  <sparkle:version>X.Y.Z</sparkle:version>
  <sparkle:shortVersionString>X.Y.Z</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>10.13</sparkle:minimumSystemVersion>
  <enclosure 
    url="https://github.com/EmilyMoonstone/Moonforge/releases/download/vX.Y.Z/Moonforge-X.Y.Z-macos.dmg" 
    length="FILE_SIZE_BYTES" 
    type="application/octet-stream" />
</item>
```

### Windows (appcast.json)

```json
{
  "title": "Version X.Y.Z",
  "version": "X.Y.Z",
  "description": "<h2>What's New</h2><ul><li>Feature or fix</li></ul>",
  "pubDate": "YYYY-MM-DDTHH:MM:SSZ",
  "link": "https://github.com/EmilyMoonstone/Moonforge/releases/tag/vX.Y.Z",
  "url": "https://github.com/EmilyMoonstone/Moonforge/releases/download/vX.Y.Z/Moonforge-X.Y.Z-windows.exe"
}
```

## Troubleshooting Quick Fixes

```bash
# Fastforge not found
export PATH="$PATH:$HOME/.pub-cache/bin"  # macOS/Linux
set PATH=%PATH%;%APPDATA%\Pub\Cache\bin   # Windows CMD
$env:Path += ";$env:APPDATA\Pub\Cache\bin"  # Windows PowerShell

# Clear Flutter cache
flutter clean && flutter pub get

# Regenerate code
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# Check Flutter doctor
flutter doctor -v

# Update Fastforge
dart pub global activate fastforge
```

## Environment Variables

Required for GitHub publishing:

```bash
# Set in CI (GitHub Actions secrets)
GITHUB_TOKEN=your_token_here

# Or export locally for testing
export GITHUB_TOKEN=your_token_here  # macOS/Linux
set GITHUB_TOKEN=your_token_here     # Windows
```

## File Locations

```
Moonforge/
├── distribute_options.yaml      # Fastforge configuration
├── appcast/
│   ├── appcast.xml             # macOS update feed
│   └── appcast.json            # Windows update feed
├── dist/                        # Build outputs (gitignored)
├── moonforge/
│   ├── pubspec.yaml            # Version specified here
│   └── lib/
│       └── core/services/
│           └── auto_updater_service.dart  # Update logic
└── .github/workflows/
    └── release.yml             # CI/CD pipeline
```

## Support Platforms

| Platform | Supported Targets |
|----------|------------------|
| Windows  | exe, msix        |
| macOS    | dmg, pkg         |
| Linux    | appimage, deb, rpm |
| Android  | apk, aab         |
| iOS      | ipa              |

## Resources

- [Fastforge Docs](https://fastforge.dev/)
- [Full Setup Guide](./fastforge_setup.md)
- [auto_updater Package](https://pub.dev/packages/auto_updater)
