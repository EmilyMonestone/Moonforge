# CHANGELOG Versioning Strategy

This document explains the versioning strategy used in the CHANGELOG.md for the Moonforge project.

## Version Format

We follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html) with the format `MAJOR.MINOR.PATCH` (e.g., 0.46.1).

Since Moonforge is in pre-1.0 development:
- **MAJOR** version is 0 (indicating initial development)
- **MINOR** version increments for "huge" changes
- **PATCH** version increments for "medium" changes

## Release Types

### Huge Releases (0.y.0)

These releases represent significant milestones, major features, or architectural changes. Examples include:

- **Authentication & Security**: Firebase authentication, Google sign-in, Firestore integration
- **Core Infrastructure**: Database migrations, ODM models, Drift database setup
- **Major Features**: Deep linking, responsive layout, localization/internationalization
- **Platform Support**: Multi-platform configuration, platform-specific features
- **Breaking Changes**: Any changes that require significant code updates

**Current huge releases**: 46 releases from 0.1.0 to 0.46.0

### Medium Releases (0.y.x)

These releases represent incremental improvements, bug fixes, and minor features. Examples include:

- **Bug Fixes**: Specific issue resolutions
- **Documentation Updates**: README improvements, doc reorganization
- **Minor Features**: UI enhancements, small utility additions
- **Refactoring**: Code cleanup without functional changes
- **Dependency Updates**: Package version updates

**Current medium releases**: 14 releases (e.g., 0.12.1, 0.16.1, 0.21.1)

## Release Grouping Strategy

The CHANGELOG was generated using an automated script that analyzes commit history and groups commits into releases based on:

1. **Impact Analysis**: Commits are analyzed for keywords indicating major features (auth, database, routing, localization, etc.)
2. **Batch Size**: Commits are grouped in batches of 3-8 commits to create meaningful release entries
3. **Release Determination**: 
   - If a batch contains a "huge" commit, it becomes a 0.y.0 release
   - If a batch contains only "medium" commits, it becomes a 0.y.x release

## Keep a Changelog Sections

Each release is organized using the standard [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) categories:

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Now removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

## Current State

As of the current release:
- **Total Releases**: 60
- **Version Range**: 0.1.0 to 0.46.1
- **Total Commits Processed**: 327
- **Commits Per Release**: ~5.5 average

## Updating the CHANGELOG

To regenerate or update the CHANGELOG:

```bash
# Export commits from the main branch
cd /path/to/Moonforge
git log origin/main --pretty=format:"%H|%ai|%an|%s" --reverse > /tmp/commits.txt

# Generate CHANGELOG to the repository
python3 tools/generate_changelog.py /tmp/commits.txt ./CHANGELOG.md

# Or generate to default location and then copy
python3 tools/generate_changelog.py /tmp/commits.txt
# The script will output the location, then copy it:
cp <output_path> ./CHANGELOG.md
```

See `tools/README.md` for detailed script usage and customization options.

## Future Considerations

When the project reaches version 1.0.0:
- **MAJOR** version will increment to 1
- **MINOR** version will increment for backward-compatible features
- **PATCH** version will increment for backward-compatible bug fixes
- Breaking changes will increment the MAJOR version

Until then, the 0.y.z format clearly indicates that the API may change at any time during initial development.
