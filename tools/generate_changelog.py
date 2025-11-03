#!/usr/bin/env python3
"""
Generate Keep a Changelog-compliant CHANGELOG from git commits.
Maps commits to 0.y.0 (huge) or 0.y.x (medium) releases based on impact.
"""

import re
from datetime import datetime
from collections import defaultdict
from typing import List, Dict, Tuple

# Configuration constants for commit categorization
CORE_FEATURE_KEYWORDS = {
    'authentication', 'auth', 'firebase', 'firestore', 'database',
    'routing', 'navigation', 'localization', 'internationalization',
}

SIGNIFICANT_KEYWORDS = {
    'responsive', 'layout', 'theme', 'theming',
    'initial commit', 'project structure', 'configuration',
    'odm', 'models', 'schema', 'serialization',
    'platform', 'android', 'ios', 'web', 'desktop',
    'integration', 'workflow', 'ci/cd', 'pipeline'
}

ALL_HUGE_KEYWORDS = CORE_FEATURE_KEYWORDS | SIGNIFICANT_KEYWORDS

# Keywords for inferring commit type
TYPE_INFERENCE_KEYWORDS = {
    'feat': {'add', 'implement', 'create', 'new'},
    'fix': {'fix', 'resolve', 'correct'},
    'refactor': {'update', 'refactor', 'improve'},
    'docs': {'doc', 'readme'},
}

# Patterns for trivial commits that should be excluded
TRIVIAL_PATTERNS = (
    r'^\s*$',  # Empty
    r'^merge ',
    r'^wip',
    r'^tmp',
    r'^temporary',
)

# Release grouping configuration
MIN_COMMITS_FOR_HUGE_RELEASE = 3
MIN_COMMITS_FOR_MEDIUM_RELEASE = 8

# Commit parsing configuration
EXPECTED_COMMIT_PARTS = 4  # Format: SHA|Date|Author|Message


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
            self.type = 'chore'  # Default
            
            for commit_type, keywords in TYPE_INFERENCE_KEYWORDS.items():
                if any(word in msg_lower for word in keywords):
                    self.type = commit_type
                    break
            
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
        
        msg_lower = self.message.lower()
        
        # Check for multiple features or major scope
        if 'and' in msg_lower and any(kw in msg_lower for kw in ALL_HUGE_KEYWORDS):
            return True
        
        # Check for core architectural features
        if any(kw in msg_lower for kw in CORE_FEATURE_KEYWORDS):
            return True
        
        return False
    
    def is_significant(self) -> bool:
        """Determine if this is significant enough to include in CHANGELOG"""
        msg_lower = self.message.lower()
        return not any(re.match(p, msg_lower) for p in TRIVIAL_PATTERNS)


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
                        lines.append(self._format_commit_entry(commit))
                    
                    lines.append("")
        
        return '\n'.join(lines)
    
    @staticmethod
    def _format_commit_entry(commit: Commit) -> str:
        """Format a single commit as a changelog entry"""
        desc = commit.description.strip()
        if not desc.endswith('.'):
            desc += '.'
        return f"- {desc}"


def parse_commits_file(filepath: str) -> List[Commit]:
    """Parse commits from file with format: SHA|Date|Author|Message"""
    commits = []
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            parts = line.split('|', 3)
            if len(parts) == EXPECTED_COMMIT_PARTS:
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
        # - Group commits and create release every MIN_COMMITS_FOR_MEDIUM_RELEASE commits OR on huge change
        # - If batch has huge change: 0.y.0, otherwise: 0.y.x
        should_release = False
        
        if has_huge_in_batch and len(commits_since_release) >= MIN_COMMITS_FOR_HUGE_RELEASE:
            # Huge change with some context commits
            should_release = True
        elif len(commits_since_release) >= MIN_COMMITS_FOR_MEDIUM_RELEASE:
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
    # Header section
    header_lines = [
        "# Changelog",
        "",
        "All notable changes to this project will be documented in this file.",
        "",
        "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),",
        "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).",
        "",
    ]
    
    # Unreleased section
    unreleased_lines = [
        "## [Unreleased]",
        "",
        "### Changed",
        "- Upcoming changes will be listed here.",
        "",
    ]
    
    # Release sections (newest first)
    release_lines = [release.to_markdown() for release in reversed(releases)]
    
    # Combine all sections
    lines = header_lines + unreleased_lines + release_lines
    
    return '\n'.join(lines)


def main():
    import sys
    import os
    import tempfile
    
    if len(sys.argv) < 2:
        print("Usage: python generate_changelog.py <commits_file> [output_file]")
        sys.exit(1)
    
    commits_file = sys.argv[1]
    
    # Use provided output file or default to temp directory
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    else:
        output_file = os.path.join(tempfile.gettempdir(), 'CHANGELOG.md')
    
    print(f"Parsing commits from {commits_file}...")
    commits = parse_commits_file(commits_file)
    print(f"Found {len(commits)} commits")
    
    print("Grouping commits into releases...")
    releases = group_commits_into_releases(commits)
    print(f"Created {len(releases)} releases")
    
    print("Generating CHANGELOG...")
    changelog = generate_changelog(releases)
    
    # Write to output file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(changelog)
    
    print(f"CHANGELOG written to {output_file}")
    
    # Print summary
    print("\nRelease Summary:")
    for release in releases:
        print(f"  {release.version} ({release.date.strftime('%Y-%m-%d')})")


if __name__ == '__main__':
    main()
