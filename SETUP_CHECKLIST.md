# Post-Implementation Checklist

Use this checklist to verify and complete the Fastforge setup after the implementation.

## ☐ Initial Verification

- [ ] Review all new files in the repository
  - [ ] `distribute_options.yaml`
  - [ ] `appcast/appcast.xml`
  - [ ] `appcast/appcast.json`
  - [ ] `moonforge/lib/core/services/auto_updater_service.dart`
  - [ ] `.github/workflows/release.yml`
  - [ ] `scripts/release.sh`
  - [ ] Documentation files in `docs/`

- [ ] Review changes to existing files
  - [ ] `moonforge/lib/main.dart` (auto_updater initialization)
  - [ ] `README.md` (new Packaging & Distribution section)
  - [ ] `.gitignore` (dist/ exclusion)

## ☐ Local Setup (First-Time)

- [ ] Install Fastforge CLI
  ```bash
  dart pub global activate fastforge
  fastforge --version  # Verify installation
  ```

- [ ] Add Dart global packages to PATH (if needed)
  - **macOS/Linux**: Add to `~/.bashrc` or `~/.zshrc`:
    ```bash
    export PATH="$PATH:$HOME/.pub-cache/bin"
    ```
  - **Windows**: Add to System Environment Variables:
    ```
    %APPDATA%\Pub\Cache\bin
    ```

- [ ] Make release script executable (Unix-like systems)
  ```bash
  chmod +x scripts/release.sh
  ```

## ☐ Test Local Build

- [ ] Navigate to repository root
  ```bash
  cd /path/to/Moonforge
  ```

- [ ] Test building for your current platform
  ```bash
  # Option 1: Use the helper script
  ./scripts/release.sh build

  # Option 2: Use Fastforge directly
  fastforge package --platform windows --target exe  # Windows
  fastforge package --platform macos --target dmg     # macOS
  fastforge package --platform linux --target appimage # Linux
  ```

- [ ] Verify output in `dist/` directory
  ```bash
  ls -la dist/
  ```

- [ ] Test the built application (optional but recommended)
  - Install/run the package
  - Verify it launches correctly
  - Check that it includes your latest changes

## ☐ Prepare for First Release

- [ ] Update version in `moonforge/pubspec.yaml`
  - Current: `version: 0.1.0+1`
  - Example new: `version: 0.2.0+2`

- [ ] Update `CHANGELOG.md` (if you maintain one)
  - Document new features
  - List bug fixes
  - Note breaking changes

- [ ] Commit version bump
  ```bash
  git add moonforge/pubspec.yaml CHANGELOG.md
  git commit -m "Bump version to 0.2.0"
  git push origin main
  ```

## ☐ Create First Release

- [ ] Create and push git tag
  ```bash
  # Option 1: Use the helper script
  ./scripts/release.sh tag

  # Option 2: Manual
  git tag v0.2.0
  git push origin v0.2.0
  ```

- [ ] Monitor GitHub Actions workflow
  - [ ] Go to https://github.com/EmilyMoonstone/Moonforge/actions
  - [ ] Find "Build and Release with Fastforge" workflow
  - [ ] Wait for it to complete (may take 15-30 minutes)
  - [ ] Check for any errors

- [ ] Verify GitHub Release created
  - [ ] Go to https://github.com/EmilyMoonstone/Moonforge/releases
  - [ ] Find the new release (v0.2.0)
  - [ ] Verify all artifacts are present:
    - [ ] Windows EXE
    - [ ] macOS DMG
    - [ ] Linux AppImage
    - [ ] Linux DEB

## ☐ Update Appcast Files

After the release is published and artifacts are available:

- [ ] Get file sizes
  ```bash
  # From GitHub release page or local dist/ directory
  ls -l dist/v0.2.0/Moonforge-0.2.0-macos.dmg | awk '{print $5}'
  ```

- [ ] Update `appcast/appcast.xml` for macOS
  - [ ] Add new `<item>` entry at the top
  - [ ] Update version number
  - [ ] Update download URL
  - [ ] Update file size in `length` attribute
  - [ ] Update `pubDate` (RFC 822 format)
  - [ ] Update release notes in `<description>`

- [ ] Update `appcast/appcast.json` for Windows
  - [ ] Add new entry at the beginning of `items` array
  - [ ] Update version number
  - [ ] Update download URL
  - [ ] Update `pubDate` (ISO 8601 format)
  - [ ] Update release notes in `description`

- [ ] Commit and push appcast updates
  ```bash
  git add appcast/
  git commit -m "Update appcast for v0.2.0"
  git push origin main
  ```

- [ ] Verify appcast files are accessible
  - [ ] Open in browser: https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.xml
  - [ ] Open in browser: https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.json

## ☐ Test Auto-Updates

- [ ] Install the previous version (if available)
- [ ] Run the application
- [ ] Check if update is detected
  - macOS: Sparkle dialog should appear
  - Windows: WinSparkle dialog should appear
- [ ] Test downloading and installing the update
- [ ] Verify the app updates successfully

## ☐ Optional: Code Signing Setup

### For Production Releases

#### macOS Code Signing

- [ ] Get Apple Developer account (if not already)
- [ ] Create Developer ID Application certificate
- [ ] Install certificate on build machine or CI
- [ ] Update build process to sign DMG
- [ ] Set up notarization for macOS 10.15+
- [ ] Generate Sparkle EdDSA signature
- [ ] Update appcast with signature

See `docs/fastforge_setup.md` section "Code Signing" for details.

#### Windows Code Signing

- [ ] Obtain code signing certificate (Sectigo, DigiCert, etc.)
- [ ] Install certificate on build machine or CI
- [ ] Update build process to sign EXE
- [ ] Test signed executable

See `docs/fastforge_setup.md` section "Code Signing" for details.

## ☐ Documentation Review

- [ ] Read `docs/fastforge_setup.md` (complete guide)
- [ ] Read `docs/fastforge_quickref.md` (quick reference)
- [ ] Read `appcast/README.md` (appcast maintenance)
- [ ] Read `FASTFORGE_IMPLEMENTATION.md` (implementation summary)
- [ ] Bookmark useful sections for future reference

## ☐ Update Project Documentation (Optional)

Consider updating your project docs to mention:

- [ ] How contributors can test builds locally
- [ ] Release process for maintainers
- [ ] Where users can download releases
- [ ] How to report issues with installers/updates

## ☐ Troubleshooting Common Issues

If you encounter problems, check:

- [ ] Fastforge installation and PATH configuration
- [ ] Flutter and platform-specific SDKs (Visual Studio, Xcode, etc.)
- [ ] GitHub Actions logs for build errors
- [ ] File permissions and network connectivity
- [ ] Appcast URL accessibility

Refer to the Troubleshooting sections in:
- `docs/fastforge_setup.md`
- `appcast/README.md`

## ☐ Future Releases

For subsequent releases, you'll only need to:

1. [ ] Update version in `pubspec.yaml`
2. [ ] Commit changes
3. [ ] Create and push tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
4. [ ] Wait for GitHub Actions to complete
5. [ ] Update appcast files
6. [ ] Push appcast updates

Use `./scripts/release.sh` to help with these tasks!

## Need Help?

- Check documentation in `docs/fastforge_setup.md`
- Review troubleshooting sections
- Consult Fastforge docs: https://fastforge.dev/
- Open an issue if you encounter problems

---

**Tip**: Print this checklist or save it for reference during your first few releases. The process will become routine after 2-3 releases.

**Last Updated**: October 27, 2025
