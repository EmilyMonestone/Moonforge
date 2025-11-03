# Tools

This directory contains utility scripts for the Moonforge project.

## generate_changelog.py

A Python script that generates a Keep a Changelog-compliant CHANGELOG.md from git commit history.

### Usage

```bash
# Generate CHANGELOG from all commits on origin/main
cd /path/to/Moonforge
git log origin/main --pretty=format:"%H|%ai|%an|%s" --reverse > /tmp/commits.txt
python3 tools/generate_changelog.py /tmp/commits.txt
```

The script will:
1. Parse commits and categorize them using conventional commit patterns (feat, fix, docs, etc.)
2. Group commits into releases based on impact:
   - **Huge releases (0.y.0)**: Breaking changes, major features (auth, database, routing, etc.)
   - **Medium releases (0.y.x)**: Incremental improvements, bug fixes, minor features
3. Generate CHANGELOG.md following Keep a Changelog format with sections:
   - Added: new features
   - Changed: changes in existing functionality
   - Deprecated: soon-to-be removed features
   - Removed: now-removed features
   - Fixed: bug fixes
   - Security: vulnerability fixes

### Customization

Edit the script to adjust:
- `is_huge()` method: Define what constitutes a "huge" change
- `group_commits_into_releases()`: Adjust grouping strategy (commits per release)
- `huge_keywords`: Add or remove keywords that identify major features

### References

- [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Other Scripts

- `build.ps1`: PowerShell build script for Windows
- `config_app.ps1`: PowerShell configuration script for app setup
