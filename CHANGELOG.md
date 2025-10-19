# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog (https://keepachangelog.com/en/1.1.0/),
and this project adheres to Semantic Versioning (https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Documentation

- Update Markdown docs to reflect app moved to moonforge/ subfolder (paths, commands, structure).

## [0.1.0] - 2025-10-14

This release is a init of the project (feature additions without breaking changes).

### Added

- Implement responsive layout with adaptive navigation and two-pane support ([a85ca61](https://github.com/EmilyMonestone/Moonforge/commit/a85ca61)).
- Integrate Firebase authentication and Firestore with Riverpod; add dynamic theming support ([8a98903](https://github.com/EmilyMonestone/Moonforge/commit/8a98903)).
- Add Firestore ODM models for campaign, chapter, adventure, scene, encounter, and media asset with JSON serialization
  support ([c3eff6c](https://github.com/EmilyMonestone/Moonforge/commit/c3eff6c)).
- Add generated models and builders for JoinCode, ChapterDoc, AdventureDoc, SceneDoc, EncounterDoc, and MediaAssetDoc with JSON serialization
  support ([8871e37](https://github.com/EmilyMonestone/Moonforge/commit/8871e37)).
- Initial project structure and configuration files for Moonforge ([8253bc0](https://github.com/EmilyMonestone/Moonforge/commit/8253bc0)).

### Changed

- Simplify Campaign model by removing unused fields and updating JSON serialization ([7b6748e](https://github.com/EmilyMonestone/Moonforge/commit/7b6748e)).

### Documentation

- Add contributing guide and license information ([2948608](https://github.com/EmilyMonestone/Moonforge/commit/2948608)).

### CI

- Add GitHub Actions workflow for Dart CI ([0dfbf99](https://github.com/EmilyMonestone/Moonforge/commit/0dfbf99)).

### Chore

- Refactor workspace configuration and update task summaries for clarity ([02b05fd](https://github.com/EmilyMonestone/Moonforge/commit/02b05fd)).
