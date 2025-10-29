# Beta and Production Release Channels

This document explains how the beta and production release channels work in Moonforge.

## Overview

Moonforge supports two independent update channels:

1. **Production Channel**: Stable releases for end users
2. **Beta Channel**: Pre-release versions for testing and early access

Users only receive updates for the channel they installed. This ensures beta testers get bleeding-edge features while production users get stable releases.

## How It Works

### At Build Time

The release channel is determined at **build time** using the `APP_ENV` compile-time constant:

```dart
// In auto_updater_service.dart
static const String _appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'production');
```

When building, this constant is set via `--dart-define`:
```bash
flutter build windows --dart-define=APP_ENV=production
flutter build windows --dart-define=APP_ENV=beta
```

### At Runtime

When the app starts:

1. `AutoUpdaterService.initialize()` is called
2. It reads the `APP_ENV` constant (baked into the binary)
3. It selects the appropriate appcast feed URL:
   - Production: `appcast.xml` / `appcast.json`
   - Beta: `appcast-beta.xml` / `appcast-beta.json`
4. The auto-updater only checks the selected feed for updates

### In CI/CD

The GitHub Actions workflow (`.github/workflows/release.yml`) automatically determines the environment:

**Triggers:**
- Push to `main` branch → production build
- Push to `beta` branch → beta build
- Tag `v1.0.0` → production build
- Tag `v1.0.0-beta.1` → beta build (contains "beta" or "alpha")

**Setup Job:**
```yaml
setup:
  runs-on: ubuntu-latest
  outputs:
    app_env: ${{ steps.determine_env.outputs.app_env }}
    is_prerelease: ${{ steps.determine_env.outputs.is_prerelease }}
  steps:
    - name: Determine environment
      # Checks github.ref to determine if main, beta, or tag
      # Sets app_env to "production" or "beta"
```

**Build Jobs:**
All platform builds receive the `app_env` from setup:
```yaml
run: fastforge package --platform windows --target exe --build-args="dart-define:APP_ENV=${{ needs.setup.outputs.app_env }}"
```

## Release Workflow

### Production Release

1. **Make changes on main branch**:
   ```bash
   git checkout main
   # ... make changes ...
   git commit -m "Add new feature"
   git push origin main
   ```

2. **CI automatically builds** with `APP_ENV=production`

3. **Update production appcast feeds**:
   ```bash
   # Edit appcast/appcast.xml and appcast/appcast.json
   # Add new version at the top
   git commit -am "Update appcast for v1.0.0"
   git push origin main
   ```

4. **Production users get notified** on next update check

### Beta Release

1. **Make changes on beta branch**:
   ```bash
   git checkout beta
   # ... make changes ...
   git commit -m "Add experimental feature"
   git push origin beta
   ```

2. **CI automatically builds** with `APP_ENV=beta`

3. **Update beta appcast feeds**:
   ```bash
   # Edit appcast/appcast-beta.xml and appcast/appcast-beta.json
   # Add new version at the top
   git commit -am "Update appcast for v1.0.0-beta.1"
   git push origin beta
   ```

4. **Beta users get notified** on next update check

## Version Numbering

### Production Versions
- Format: `MAJOR.MINOR.PATCH` (e.g., `1.0.0`, `1.2.3`)
- In pubspec.yaml: `version: 1.0.0+1`
- Tag: `v1.0.0`

### Beta Versions
- Format: `MAJOR.MINOR.PATCH-beta.N` (e.g., `1.0.0-beta.1`, `1.0.0-beta.2`)
- In pubspec.yaml: `version: 1.0.0-beta.1+1`
- Tag: `v1.0.0-beta.1`

## Appcast Feed Structure

### Production Feeds
- **Location**: `appcast/appcast.xml`, `appcast/appcast.json`
- **URL**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.xml`
- **Contains**: Only stable production releases
- **Users**: Production installations

### Beta Feeds
- **Location**: `appcast/appcast-beta.xml`, `appcast/appcast-beta.json`
- **URL**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast-beta.xml`
- **Contains**: Only beta/pre-release versions
- **Users**: Beta installations

## Channel Isolation

The channels are completely isolated:

- **Production app** → checks production feed → sees only production releases
- **Beta app** → checks beta feed → sees only beta releases

This means:
- Beta users can test new features without affecting production
- Production users never see beta releases
- You can have different versions in each channel simultaneously

## Promoting Beta to Production

When a beta version is stable enough for production:

1. **Merge beta changes to main** (or cherry-pick commits)
2. **Update version** to remove `-beta.N` suffix
3. **Push to main** to trigger production build
4. **Update production appcast feeds** with the new stable version
5. Production users will upgrade to the new stable release

## FAQ

**Q: Can a user switch from beta to production?**
A: They would need to uninstall the beta version and install the production version. The channels are determined at build time.

**Q: What happens if I forget to update the appcast files?**
A: Users won't be notified of the new version until the appcast is updated.

**Q: Can I have both production and beta installed?**
A: No, they would conflict since they have the same app ID. Users need to choose one channel.

**Q: How do users know which channel they're on?**
A: The app logs the channel on startup (check console logs). You could also add a UI indicator if desired.

**Q: Can I create other channels like "alpha"?**
A: Yes! You'd need to:
1. Create an `alpha` branch
2. Add `appcast-alpha.xml` and `appcast-alpha.json` feeds
3. Update the workflow to detect "alpha" in tags/branches
4. Update `auto_updater_service.dart` to handle the alpha channel

## Technical Details

### Code Location

**AutoUpdaterService** (`moonforge/lib/core/services/auto_updater_service.dart`):
```dart
static const String _appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'production');

Future<void> initialize() async {
  // ...
  final isBeta = _appEnv == 'beta';
  final feedSuffix = isBeta ? '-beta' : '';
  
  if (Platform.isMacOS) {
    feedURL = '$_feedURLBase/appcast$feedSuffix.xml';
  } else if (Platform.isWindows) {
    feedURL = '$_feedURLBase/appcast$feedSuffix.json';
  }
  // ...
}
```

**Workflow** (`.github/workflows/release.yml`):
```yaml
on:
  push:
    branches:
      - main    # production
      - beta    # beta
    tags:
      - 'v*'    # both (detected by name)

jobs:
  setup:
    # Determines app_env based on ref
  
  build-windows:
    needs: setup
    # Uses app_env in build command
```

## Troubleshooting

**Problem: Beta users seeing production updates**
- Check that the app was built with `APP_ENV=beta`
- Verify the workflow is passing the correct `app_env` value
- Check logs to see which feed URL is being used

**Problem: No updates available**
- Verify the appcast files are accessible via raw GitHub URLs
- Check that version in appcast is higher than installed version
- Ensure you updated the correct channel's appcast files

**Problem: Wrong channel after update**
- The channel is baked into the binary at build time
- If an update has the wrong channel, the build was incorrect
- Check the CI logs to verify `APP_ENV` was passed correctly
