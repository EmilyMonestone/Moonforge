#!/usr/bin/env python3
"""
Generate Keep a Changelog-compliant CHANGELOG from git commits.
Maps commits to 0.y.0 (huge) or 0.y.x (medium) releases based on impact.
"""

import re
from datetime import datetime
from collections import defaultdict
from typing import List, Dict, Tuple

class Commit:
    def __init__(self, sha: str, date: str, author: str, message: str):
        self.sha = sha
        self.date = datetime.strptime(date.split()[0], '%Y-%m-%d')
        self.author = author
        self.message = message
        self.type = None
        self.scope = None
        self.description = None
        self.breaking = False
        self.category = None
        self._parse_message()
    
    def _parse_message(self):
        """Parse conventional commit format: type(scope): description"""
        # Match conventional commit pattern
        pattern = r'^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(?:\(([^)]+)\))?(!)?:\s*(.+)$'
        match = re.match(pattern, self.message, re.IGNORECASE)
        
        if match:
            self.type = match.group(1).lower()
            self.scope = match.group(2)
            self.breaking = match.group(3) == '!'
            self.description = match.group(4)
        else:
            # Try to infer type from message
            msg_lower = self.message.lower()
            if any(word in msg_lower for word in ['add', 'implement', 'create', 'new']):
                self.type = 'feat'
            elif any(word in msg_lower for word in ['fix', 'resolve', 'correct']):
                self.type = 'fix'
            elif any(word in msg_lower for word in ['update', 'refactor', 'improve']):
                self.type = 'refactor'
            elif any(word in msg_lower for word in ['doc', 'readme']):
                self.type = 'docs'
            else:
                self.type = 'chore'
            
            self.description = self.message
        
        # Map type to Keep a Changelog category
        type_to_category = {
            'feat': 'Added',
            'fix': 'Fixed',
            'docs': 'Changed',
            'refactor': 'Changed',
            'perf': 'Changed',
            'style': 'Changed',
            'test': 'Changed',
            'build': 'Changed',
            'ci': 'Changed',
            'chore': 'Changed',
            'revert': 'Changed',
        }
        
        if self.breaking:
            self.category = 'Changed'  # Breaking changes are usually "Changed"
        else:
            self.category = type_to_category.get(self.type, 'Changed')
    
    def is_huge(self) -> bool:
        """Determine if this is a "huge" change worthy of 0.y.0"""
        # Breaking changes are huge
        if self.breaking:
            return True
        
        # Major feature additions
        huge_keywords = [
            'authentication', 'auth', 'firebase', 'firestore', 'database',
            'routing', 'navigation', 'localization', 'internationalization',
            'responsive', 'layout', 'theme', 'theming',
            'initial commit', 'project structure', 'configuration',
            'odm', 'models', 'schema', 'serialization',
            'platform', 'android', 'ios', 'web', 'desktop',
            'integration', 'workflow', 'ci/cd', 'pipeline'
        ]
        
        msg_lower = self.message.lower()
        
        # Check for multiple features or major scope
        if 'and' in msg_lower and any(kw in msg_lower for kw in huge_keywords):
            return True
        
        # Check for explicit huge keywords
        if any(kw in msg_lower for kw in huge_keywords[:8]):  # Core features
            return True
        
        return False
    
    def is_significant(self) -> bool:
        """Determine if this is significant enough to include in CHANGELOG"""
        # Skip trivial commits
        trivial_patterns = [
            r'^\s*$',  # Empty
            r'^merge ',
            r'^wip',
            r'^tmp',
            r'^temporary',
        ]
        
        msg_lower = self.message.lower()
        return not any(re.match(p, msg_lower) for p in trivial_patterns)


class Release:
    def __init__(self, version: str, date: datetime):
        self.version = version
        self.date = date
        self.commits_by_category: Dict[str, List[Commit]] = defaultdict(list)
    
    def add_commit(self, commit: Commit):
        if commit.category:
            self.commits_by_category[commit.category].append(commit)
    
    def to_markdown(self) -> str:
        """Generate Keep a Changelog markdown for this release"""
        lines = [f"## [{self.version}] - {self.date.strftime('%Y-%m-%d')}"]
        lines.append("")
        
        # Order categories as per Keep a Changelog
        category_order = ['Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security']
        
        for category in category_order:
            if category in self.commits_by_category:
                commits = self.commits_by_category[category]
                if commits:
                    lines.append(f"### {category}")
                    lines.append("")
                    
                    for commit in commits:
                        # Format: - Description
                        desc = commit.description.strip()
                        if not desc.endswith('.'):
                            desc += '.'
                        lines.append(f"- {desc}")
                    
                    lines.append("")
        
        return '\n'.join(lines)


def parse_commits_file(filepath: str) -> List[Commit]:
    """Parse commits from file with format: SHA|Date|Author|Message"""
    commits = []
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            parts = line.split('|', 3)
            if len(parts) == 4:
                sha, date, author, message = parts
                commits.append(Commit(sha, date, author, message))
    
    return commits


def group_commits_into_releases(commits: List[Commit]) -> List[Release]:
    """Group commits into releases based on impact"""
    releases = []
    major_version = 0
    minor_version = 0
    patch_version = 0
    
    commits_since_release = []
    has_huge_in_batch = False
    
    for commit in commits:
        if not commit.is_significant():
            continue
        
        commits_since_release.append(commit)
        
        # Track if we have a huge commit in the current batch
        if commit.is_huge():
            has_huge_in_batch = True
        
        # Create release after accumulating commits
        # Strategy: 
        # - Group commits and create release every 5-15 commits OR on huge change
        # - If batch has huge change: 0.y.0, otherwise: 0.y.x
        should_release = False
        
        if has_huge_in_batch and len(commits_since_release) >= 3:
            # Huge change with some context commits
            should_release = True
        elif len(commits_since_release) >= 8:
            # Medium batch of changes
            should_release = True
        
        if should_release and commits_since_release:
            if has_huge_in_batch:
                # Huge release: increment minor, reset patch
                minor_version += 1
                patch_version = 0
                version = f"{major_version}.{minor_version}.0"
            else:
                # Medium release: increment patch
                patch_version += 1
                version = f"{major_version}.{minor_version}.{patch_version}"
            
            # Use the date of the last commit in the group
            release_date = commits_since_release[-1].date
            release = Release(version, release_date)
            
            for c in commits_since_release:
                release.add_commit(c)
            
            releases.append(release)
            commits_since_release = []
            has_huge_in_batch = False
    
    # Add remaining commits to final release
    if commits_since_release:
        if has_huge_in_batch:
            minor_version += 1
            patch_version = 0
            version = f"{major_version}.{minor_version}.0"
        else:
            patch_version += 1
            version = f"{major_version}.{minor_version}.{patch_version}"
        
        release_date = commits_since_release[-1].date
        release = Release(version, release_date)
        
        for c in commits_since_release:
            release.add_commit(c)
        
        releases.append(release)
    
    return releases


def generate_changelog(releases: List[Release]) -> str:
    """Generate complete CHANGELOG content"""
    lines = [
        "# Changelog",
        "",
        "All notable changes to this project will be documented in this file.",
        "",
        "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),",
        "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).",
        "",
    ]
    
    # Add releases in reverse order (newest first)
    for release in reversed(releases):
        lines.append(release.to_markdown())
    
    # Add unreleased section at the top (after header)
    unreleased = [
        "## [Unreleased]",
        "",
        "### Changed",
        "- Upcoming changes will be listed here.",
        "",
    ]
    
    # Insert unreleased section after the header
    header_end = 7  # After the intro text
    lines = lines[:header_end] + unreleased + lines[header_end:]
    
    return '\n'.join(lines)


def main():
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python generate_changelog.py <commits_file>")
        sys.exit(1)
    
    commits_file = sys.argv[1]
    
    print(f"Parsing commits from {commits_file}...")
    commits = parse_commits_file(commits_file)
    print(f"Found {len(commits)} commits")
    
    print("Grouping commits into releases...")
    releases = group_commits_into_releases(commits)
    print(f"Created {len(releases)} releases")
    
    print("Generating CHANGELOG...")
    changelog = generate_changelog(releases)
    
    # Write to CHANGELOG.md
    output_file = '/tmp/CHANGELOG.md'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(changelog)
    
    print(f"CHANGELOG written to {output_file}")
    
    # Print summary
    print("\nRelease Summary:")
    for release in releases:
        print(f"  {release.version} ({release.date.strftime('%Y-%m-%d')})")


if __name__ == '__main__':
    main()
