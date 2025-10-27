# Fastforge Implementation Summary

## What Was Implemented

This document summarizes the Fastforge and auto_updater integration implemented for Moonforge, including support for production and beta release channels.

## Release Channels

Moonforge now supports two separate release channels:

- **Production Channel**: Stable releases built from the `main` branch
- **Beta Channel**: Pre-release versions built from the `beta` branch

Users receive updates only for their installed channel. Beta users get beta updates, and production users get production updates. This is determined at build time using the `APP_ENV` compile-time constant.

## Files Added

### Configuration Files

1. **`distribute_options.yaml`** (Root directory)
   - Main Fastforge configuration file
   - Defines build targets for Windows, macOS, and Linux
   - Configures production and beta release pipelines
   - Sets up GitHub Releases as the distribution platform

2. **`appcast/appcast.xml`** (macOS production update feed)
   - Sparkle-compatible appcast for macOS auto-updates
   - Contains template for version 0.1.0
   - Needs to be updated for each new production release

3. **`appcast/appcast.json`** (Windows production update feed)
   - WinSparkle-compatible appcast for Windows auto-updates
   - Contains template for version 0.1.0
   - Needs to be updated for each new production release

4. **`appcast/appcast-beta.xml`** (macOS beta update feed)
   - Sparkle-compatible appcast for macOS beta auto-updates
   - Contains template for version 0.1.0-beta.1
   - Needs to be updated for each new beta release

5. **`appcast/appcast-beta.json`** (Windows beta update feed)
   - WinSparkle-compatible appcast for Windows beta auto-updates
   - Contains template for version 0.1.0-beta.1
   - Needs to be updated for each new beta release

### Source Code

4. **`moonforge/lib/core/services/auto_updater_service.dart`**
   - Service class that wraps the auto_updater package
   - Initializes update checking on app startup
   - Platform-specific feed URL configuration
   - **Channel detection**: Reads `APP_ENV` compile-time constant to determine production vs beta
   - Automatically selects appropriate appcast feed based on channel
   - Provides methods for manual update checks

### CI/CD

5. **`.github/workflows/release.yml`**
   - GitHub Actions workflow for automated builds
   - **Triggers on**:
     - Push to `main` branch → production release
     - Push to `beta` branch → beta release
     - Tag push (e.g., `v0.2.0` or `v0.2.0-beta.1`)
   - **Setup job**: Determines environment (production/beta) based on branch/tag
   - Builds for Windows, macOS, and Linux in parallel
   - Passes `APP_ENV` to build process as dart-define flag
   - Creates GitHub Release with all artifacts
   - Marks beta releases as pre-release
   - Supports manual workflow dispatch

### Scripts

6. **`scripts/release.sh`**
   - Helper script for common release tasks
   - Commands: check, version, build, tag, appcast
   - Simplifies local testing and release process

### Documentation

7. **`docs/fastforge_setup.md`** (12KB comprehensive guide)
   - Complete setup and deployment guide
   - Prerequisites and installation instructions
   - Building and packaging instructions
   - GitHub release process (automated and manual)
   - Auto-update setup and appcast maintenance
   - Code signing information
   - Troubleshooting section

8. **`docs/fastforge_quickref.md`** (5KB quick reference)
   - Quick command reference
   - Common workflows
   - Appcast update templates
   - Environment variables
   - File locations

9. **`appcast/README.md`**
   - Detailed guide for maintaining appcast files
   - Step-by-step instructions for updating feeds
   - **Documents both production and beta channels**
   - Code signing notes
   - Testing procedures
   - Release workflow for each channel

## Files Modified

1. **`moonforge/lib/main.dart`**
   - Added import for `auto_updater_service.dart`
   - Added initialization call in post-frame callback
   - Auto-updater now starts when the app launches
   - App environment is determined at compile time via `APP_ENV` dart-define

2. **`moonforge/lib/core/services/auto_updater_service.dart`**
   - Modified to read `APP_ENV` compile-time constant
   - Selects appropriate appcast feed (production or beta) based on environment
   - Logs channel information on startup

3. **`.github/workflows/release.yml`**
   - Modified to trigger on both `main` and `beta` branches
   - Added setup job to determine environment from branch/tag
   - Updated all build jobs to pass `APP_ENV` as dart-define
   - Updated release job to mark beta releases as pre-release

4. **`appcast/README.md`**
   - Updated to document production and beta channels
   - Added workflow instructions for each channel

5. **`README.md`**
   - Added "Packaging & Distribution" section
   - Links to new documentation
   - Describes supported platforms and update mechanism

6. **`.gitignore`**
   - Added `dist/` to exclude build artifacts from git

## How It Works

### Release Channels

The application supports two independent update channels:

1. **Production Channel** (`APP_ENV=production`)
   - Built from `main` branch or non-beta tags
   - Uses `appcast.xml` and `appcast.json` feeds
   - For stable releases
   - Users get production-only updates

2. **Beta Channel** (`APP_ENV=beta`)
   - Built from `beta` branch or beta/alpha tags
   - Uses `appcast-beta.xml` and `appcast-beta.json` feeds
   - For testing and early access
   - Users get beta-only updates

### Build Process

1. **Automated (CI/CD)**:
   
   **For Production Releases:**
   - Push to `main` branch or create tag like `v0.2.0`
   - GitHub Actions workflow triggers
   - Setup job detects environment as `production`
   - Builds packages with `--dart-define=APP_ENV=production`
   - Creates GitHub Release (not marked as pre-release)
   - Artifacts available for download
   
   **For Beta Releases:**
   - Push to `beta` branch or create tag like `v0.2.0-beta.1`
   - GitHub Actions workflow triggers
   - Setup job detects environment as `beta`
   - Builds packages with `--dart-define=APP_ENV=beta`
   - Creates GitHub Release (marked as pre-release)
   - Artifacts available for download

2. **Manual (Local)**:
   - Run `./scripts/release.sh build [platform]`
   - Or use Fastforge directly: `fastforge package --platform windows --target exe`
   - Packages are output to `dist/` directory

### Distribution

- Packages are uploaded to GitHub Releases
- Users download from the Releases page
- Release assets include:
  - `Moonforge-X.Y.Z-windows.exe`
  - `Moonforge-X.Y.Z-macos.dmg`
  - `Moonforge-X.Y.Z-linux.AppImage`
  - `Moonforge-X.Y.Z-linux.deb`

### Auto-Updates

1. **On App Startup**:
   - `AutoUpdaterService.instance.initialize()` is called
   - Reads `APP_ENV` compile-time constant (production or beta)
   - Sets feed URL based on platform and channel:
     - **Production macOS**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.xml`
     - **Production Windows**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.json`
     - **Beta macOS**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast-beta.xml`
     - **Beta Windows**: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast-beta.json`
   - Checks for updates every 24 hours by default

2. **When Update is Available**:
   - Sparkle (macOS) or WinSparkle (Windows) shows update dialog
   - Only shows updates from the matching channel
   - User can download and install the update
   - App restarts with new version

3. **After Each Release**:
   - **For production**: Update `appcast.xml` and `appcast.json` with new version info
   - **For beta**: Update `appcast-beta.xml` and `appcast-beta.json` with new version info
   - Commit and push to GitHub
   - Users on that channel will receive update notification on next check

## Supported Platforms

| Platform | Package Format | Auto-Update Support |
|----------|---------------|-------------------|
| Windows  | EXE Installer | ✅ Yes (WinSparkle) |
| macOS    | DMG Disk Image | ✅ Yes (Sparkle) |
| Linux    | AppImage, DEB | ❌ No (manual updates) |

## Next Steps for Users

### First-Time Setup

1. **Install Fastforge**:
   ```bash
   dart pub global activate fastforge
   ```

2. **Test Local Build**:
   ```bash
   cd Moonforge
   ./scripts/release.sh build
   ```

3. **Verify Output**:
   ```bash
   ls -l dist/
   ```

### Creating a Release

#### Production Release (from main branch)

1. **Update Version** in `moonforge/pubspec.yaml`:
   ```yaml
   version: 0.2.0+2
   ```

2. **Commit and Push to main**:
   ```bash
   git commit -am "Bump version to 0.2.0"
   git push origin main
   ```
   
   Or create a tag:
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```

3. **Monitor GitHub Actions**:
   - Go to Actions tab in GitHub
   - Wait for workflow to complete
   - Check Releases page for new release

4. **Update Production Appcast Files**:
   ```bash
   # Edit appcast/appcast.xml and appcast/appcast.json
   # Add new version entry at the top
   git commit -am "Update appcast for v0.2.0"
   git push origin main
   ```

#### Beta Release (from beta branch)

1. **Update Version** in `moonforge/pubspec.yaml`:
   ```yaml
   version: 0.2.0-beta.1+2
   ```

2. **Commit and Push to beta**:
   ```bash
   git commit -am "Bump version to 0.2.0-beta.1"
   git push origin beta
   ```
   
   Or create a beta tag:
   ```bash
   git tag v0.2.0-beta.1
   git push origin v0.2.0-beta.1
   ```

3. **Monitor GitHub Actions**:
   - Go to Actions tab in GitHub
   - Wait for workflow to complete
   - Check Releases page for new pre-release

4. **Update Beta Appcast Files**:
   ```bash
   # Edit appcast/appcast-beta.xml and appcast/appcast-beta.json
   # Add new version entry at the top
   git commit -am "Update appcast for v0.2.0-beta.1"
   git push origin beta
   ```

### Optional: Code Signing

For production releases, consider:
- **macOS**: Apple Developer ID certificate + notarization
- **Windows**: Code signing certificate (Sectigo, DigiCert, etc.)

See `docs/fastforge_setup.md` for detailed instructions.

## Maintenance

### Regular Tasks

- **Before Each Release**: Update version in `pubspec.yaml`
- **After Each Production Release**: Update `appcast.xml` and `appcast.json`
- **After Each Beta Release**: Update `appcast-beta.xml` and `appcast-beta.json`
- **Periodically**: Review and update documentation
- **When Promoting Beta to Production**: Consider updating production feeds with stable version

### Troubleshooting

Common issues and solutions are documented in:
- `docs/fastforge_setup.md` - Troubleshooting section
- `appcast/README.md` - Appcast-specific issues

## Technical Details

### Dependencies

- **Fastforge**: Not in pubspec.yaml (CLI tool installed globally)
- **auto_updater**: Already in `moonforge/pubspec.yaml` at version `^1.0.0`

### Configuration

- **Feed URLs**: Configured in `auto_updater_service.dart`
- **Build Arguments**: Defined in `distribute_options.yaml`
- **GitHub Token**: Provided via `GITHUB_TOKEN` environment variable (GitHub Actions provides this automatically)

### Architecture

```
User's Machine
    │
    ├─> Installs Moonforge from GitHub Release
    │
    └─> App starts
        │
        └─> AutoUpdaterService.initialize()
            │
            ├─> Sets feed URL
            │
            └─> Checks for updates periodically
                │
                └─> If newer version found
                    │
                    ├─> Shows update dialog
                    │
                    └─> Downloads & installs update
```

## Resources

- **Fastforge Documentation**: https://fastforge.dev/
- **auto_updater Package**: https://pub.dev/packages/auto_updater
- **Sparkle Framework**: https://sparkle-project.org/ (macOS)
- **WinSparkle**: https://winsparkle.org/ (Windows)

## Support

For issues or questions:
1. Check the documentation in `docs/`
2. Review the troubleshooting sections
3. Open an issue on GitHub
4. Consult Fastforge and auto_updater communities

---

**Implementation Date**: October 27, 2025  
**Implemented By**: GitHub Copilot  
**Tested**: No (requires user setup and Flutter environment)
