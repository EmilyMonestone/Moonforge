# CI/CD and GitHub Actions

This guide covers Moonforge-specific CI/CD setup, GitHub Actions workflows, and automation.

## Overview

Moonforge uses GitHub Actions for:
- Automated builds on push to `main` and `beta` branches
- Release builds when version tags are pushed
- Package distribution via GitHub Releases
- Multi-platform builds (Windows, macOS, Linux)

## GitHub Secrets

### Required Secrets

Configure these in **Settings → Secrets and variables → Actions**:

#### FIREBASE_WEB_API_KEY

Firebase Web API key for building the application.

**How to get it:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click gear icon → Project settings
4. Scroll to "Your apps" → Web app
5. Find `apiKey` in the configuration

**How to add:**
1. Repository → Settings → Secrets and variables → Actions
2. New repository secret
3. Name: `FIREBASE_WEB_API_KEY`
4. Value: Your API key (e.g., `AIzaSyABC123...`)

The workflow creates a `.env` file during build:

```yaml
- name: Create .env file
  working-directory: moonforge
  run: |
    echo "FIREBASE_API_KEY=${{ secrets.FIREBASE_WEB_API_KEY }}" > .env
```

## Workflow Files

### Release Workflow (`.github/workflows/release.yml`)

Triggers on:
- Push to `main` branch → production build
- Push to `beta` branch → beta build  
- Tags matching `v*` → production or beta based on tag name

#### Key Jobs

**1. Setup Job**
- Determines environment (`production` or `beta`) based on branch/tag
- Sets `app_env` and `is_prerelease` outputs

**2. Build Jobs** (Windows, macOS, Linux)
- Run in parallel after setup
- Use Fastforge to package applications
- Pass `APP_ENV` from setup job
- Upload artifacts

**3. Release Job**
- Creates GitHub Release
- Uploads all platform packages
- Marks as pre-release if beta

## Environment Detection

The workflow automatically determines the build environment:

```yaml
- name: Determine environment
  id: determine_env
  run: |
    if [[ "${{ github.ref }}" == "refs/heads/beta" ]] || \
       [[ "${{ github.ref }}" =~ beta|alpha ]]; then
      echo "app_env=beta" >> $GITHUB_OUTPUT
      echo "is_prerelease=true" >> $GITHUB_OUTPUT
    else
      echo "app_env=production" >> $GITHUB_OUTPUT
      echo "is_prerelease=false" >> $GITHUB_OUTPUT
    fi
```

**Logic:**
- `main` branch or `v1.0.0` tag → `production`
- `beta` branch or `v1.0.0-beta.1` tag → `beta`

## Release Process

### Production Release

1. Update version in `moonforge/pubspec.yaml`:
   ```yaml
   version: 1.0.0+1
   ```

2. Commit and push to main:
   ```bash
   git add moonforge/pubspec.yaml
   git commit -m "chore: bump version to 1.0.0"
   git push origin main
   ```

3. Create and push tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. GitHub Actions builds automatically

5. Update appcast files:
   ```bash
   # Edit appcast/appcast.xml and appcast/appcast.json
   git add appcast/
   git commit -m "chore: update appcast for v1.0.0"
   git push origin main
   ```

### Beta Release

Same process but:
- Push to `beta` branch
- Use beta version: `1.0.0-beta.1+1`
- Tag as `v1.0.0-beta.1`
- Update `appcast-beta.xml` and `appcast-beta.json`

## Build Configuration

Fastforge build command in workflow:

```yaml
- name: Package with Fastforge
  run: |
    fastforge package --platform windows --target exe \
      --build-args="dart-define:APP_ENV=${{ needs.setup.outputs.app_env }}"
```

The `APP_ENV` constant is baked into the binary at build time.

## Artifacts

Built packages are uploaded as artifacts:

```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: windows-package
    path: dist/**/*
```

## Release Assets

The release job downloads all artifacts and uploads them:

```yaml
- name: Create Release
  uses: softprops/action-gh-release@v1
  with:
    files: dist/**/*
    prerelease: ${{ needs.setup.outputs.is_prerelease }}
```

## Monitoring Workflows

1. Go to repository **Actions** tab
2. Select a workflow run
3. View logs for each job
4. Download artifacts if needed

## Troubleshooting

### Workflow Fails During Build

- Check Flutter/Dart versions match project requirements
- Verify dependencies in `pubspec.yaml`
- Check build logs for specific errors

### Release Created But No Assets

- Verify artifacts uploaded successfully in build jobs
- Check `files` pattern in release step
- Verify repository permissions

### Environment Variable Not Set

- Check secret is configured in repository settings
- Verify secret name matches workflow
- Check `.env` file creation step succeeded

## Local Testing

Test the build process locally:

```bash
# Set environment variable
export FIREBASE_API_KEY="your-key-here"

# Create .env file
echo "FIREBASE_API_KEY=$FIREBASE_API_KEY" > moonforge/.env

# Package with Fastforge
fastforge package --platform windows --target exe \
  --build-args="dart-define:APP_ENV=production"
```

## Best Practices

1. **Test locally first** - Use Fastforge locally before pushing
2. **Semantic versioning** - Follow semver for version numbers
3. **Update changelogs** - Document changes for each release
4. **Update appcasts** - Don't forget appcast files after release
5. **Monitor workflows** - Check Actions tab after pushing tags

## What's Unique to Moonforge

- **Dual channels**: production and beta with separate appcast feeds
- **APP_ENV constant**: Baked into binary at build time
- **Fastforge packaging**: Uses Fastforge instead of manual builds
- **Multi-platform**: Parallel builds for Windows, macOS, Linux
- **Appcast updates**: Manual step after automated release

## Related Documentation

- [Releases](releases.md) - Release channels and workflow
- [Packaging Setup](packaging-setup.md) - Fastforge configuration
- [Packaging Quick Reference](packaging-quickref.md) - Common commands

## External Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Fastforge Documentation](https://fastforge.dev/)
- [action-gh-release](https://github.com/softprops/action-gh-release)
