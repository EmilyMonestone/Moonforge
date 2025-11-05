# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2025-11-04

### Added
- New database migration to schema version 4 with OutboxEntries table for improved offline sync
- Legacy date normalization for better data consistency
- Enhanced Firestore mapping for better data synchronization

**Commits:** 1dcb416

## [0.4.0] - 2025-11-03

### Added
- D&D Beyond character import feature with full stat parsing
- Player DAO and Firestore integration for player synchronization
- Quick reference guide and comprehensive documentation for D&D Beyond integration
- Database migration guide from v2 to v3

### Changed
- Player model now includes ddbCharacterId and lastDdbSync fields for D&D Beyond integration
- Optimized stats lookup and removed unused code
- Fixed resource leaks and code duplication

**Commits:** a94916d, 568df74, ebbb298, 2a1c455, a7ef001, 134d498, fefe7b9, 713a5de, 110a49c, c1214c1

## [0.3.0] - 2025-11-02

### Added
- Complete rewrite of database implementation using Drift for offline-first architecture
- Foreign key constraints for referential integrity
- Schema dump documentation for version control
- Custom query methods for various DAOs
- Sessions table with complete documentation and migration helper
- Quick reference guide for developers

### Changed
- Migrated all features from Firestore ODM to Drift database
- Migrated 45 files across Campaign, core widgets, permissions, entity gatherer, breadcrumb service, and core providers
- Enhanced error handling in StreamProviders
- Improved provider streams in db_providers.dart
- Added watchAll stream methods to DAOs
- Formatted Firestore mappers for consistency

**Commits:** b5909b1, e6bc194, b309359, de22457, a33d17d, ba0e9bb, ba40a21, 40b2e8e, 7240fd2, 76ee3f0, 07a6454, f0bc815, a8e2460, 4dc9717, ac40f30, 34cc807, 1a83533, c46178e, b0f9bef, eaf1b16

## [0.2.0] - 2025-10-30

### Added
- Multi-window support with desktop integration
- Comprehensive developer documentation reorganization
- Encounter builder feature with initiative tracker UI
- Combat log with HP and condition tracking
- Party and Player Drift tables, DAOs, and repositories
- Entity screens with image display and editing support
- Session view and edit pages with share field support
- Reusable entities widget
- Monster browser with party selection
- Live encounter difficulty display
- Code generation instructions

### Changed
- Restricted auto updater to release builds
- Replaced Row with Wrap for improved adaptive layout
- Streamlined adaptive button group widget
- Enhanced logging and Firebase sync mechanisms
- Updated imports for new Firebase model types
- Fixed breadcrumbs and window top bar issues
- Fixed top bar overflow issues on smaller screens
- Improved Drift schema for entityIds field with migration

### Fixed
- Flutter build for Windows platform
- Parent ID filtering in campaign and chapter screens
- ODM instance access in EntityGatherer service
- DateFormat to use automatic locale detection

**Commits:** 7948f75, cec9c32, 096ee7a, d757c43, afe1d75, 8d18841, 345dc30, ce9dfc4, 99dc248, 25c062c, 64b2706, 8b8c8f6, 4c5021b, 44d48d7, 70c60cb, 086761e, ebd6dbf, 0c7a617, d1cacd1, dbcc4ce, aaab69b, ca52c76, 1c39ac1, 060fbf6, 37cde35, 1171482, 1a5441d, 61be607, e1f7c90, 6cc8f2f, d402489, 638aff6, d522af0, a6ecd5b, 17b1996, 5ba7be0, 7c75430, d2b0b42, 419655c, 4572db2, 2e9f49a, 3805fab

## [0.1.0] - 2025-10-28 and earlier

### Added
- Initial project structure with Flutter application for tabletop RPG campaign management
- Firebase authentication (email/password and Google sign-in)
- Firestore integration with Riverpod state management
- Responsive layout with adaptive navigation and two-pane support
- Dynamic theming support
- Localization with German and English translations
- Theme and language settings UI
- Firestore ODM models for Campaign, Chapter, Adventure, Scene, Encounter, MediaAsset, Session, Party, and Player
- Typed routing system with auto_route
- Hotkey system
- Asset management with multiple app icons and logos
- GitHub Actions workflow for Dart CI
- Deep linking support for all platforms
- Menu registry for route-specific actions
- Comprehensive Firestore security rules
- CardList widget for list rendering
- Loading, empty, and error placeholders for async content
- Creation functionality for campaigns, chapters, adventures, entities, and scenes
- Breadcrumb navigation system
- Contributing guide and license information
- Platform support documentation (Android, iOS, Web, macOS, Linux, Windows)
- Detailed README with setup instructions

### Changed
- Organized dependencies in pubspec.yaml
- Folder structure with detailed component documentation
- Expanded README with platform support and tech stack details

**Commits:** e208ad9, 59a4a79, 8253bc0, 02b05fd, 0dfbf99, 2948608, cadf94f, a85ca61, 8a98903, c3eff6c, 8871e37, 7b6748e, 9ef2947, dcf5320, 9a12f88, 9d07979, fca36b5, ac79263, bc8311d, befb48c (and earlier)
