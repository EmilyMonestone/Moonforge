# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Upcoming changes will be listed here.

## [0.46.1] - 2025-11-03

### Changed

- rename implementation summary to dnd_beyond_import for clarity.
- clear CHANGELOG.

## [0.46.0] - 2025-11-03

### Added

- Add quick reference guide for D&D Beyond import.
- Add comprehensive implementation summary.
- Address code review feedback - fix resource leaks and code duplication.
- add ddbCharacterId and lastDdbSync fields to Player model for D&D Beyond integration.

### Changed

- Final code quality improvements - optimize stats lookup and remove unused code.

## [0.45.0] - 2025-11-03

### Added

- Add D&D Beyond character import service and player repository.
- Fix stats parsing and add D&D Beyond import documentation.
- Add D&D Beyond import usage examples.
- Add database migration guide for v2 to v3.

## [0.44.0] - 2025-11-03

### Added

- add Player DAO and Firestore integration for player synchronization.

### Changed

- update workspace configuration and clean up migration documentation.
- Initial plan.

## [0.43.0] - 2025-11-02

### Added

- Migrate Campaign feature to new Drift database (15/45 files).

### Changed

- add watchAll stream methods to DAOs, format Firestore mappers, improve provider streams in db_providers.dart.
- rename migration and build notes, add custom query methods to various DAOs, many fixes.

## [0.42.0] - 2025-10-31

### Added

- Migrate entity_gatherer service to new Drift database (4/45 files).
- Migrate permissions_utils to new Drift database (5/45 files).
- Migrate core widgets to new Drift database (11/45 files).

## [0.41.0] - 2025-10-31

### Added

- Migrate core providers to new Drift database (2/45 files).
- Migrate breadcrumb_service to new Drift database (3/45 files).

### Changed

- Revert commit 76ee3f0 - restore files to state at 07a6454.

## [0.40.0] - 2025-10-31

### Added

- Add foreign key constraints for referential integrity.
- Add schema dump documentation for version control.
- Update all files to use new Drift database models.

## [0.39.0] - 2025-10-30

### Added

- Fix main.dart and providers to use new Drift database.

### Changed

- Use drift_flutter for simplified multi-platform database setup.
- run code gen.

## [0.38.0] - 2025-10-30

### Added

- Complete repository layer and provider wiring for new database.
- Add Sessions table, complete documentation and migration helper.
- Add quick reference guide for developers.

## [0.37.0] - 2025-10-30

### Added

- Create new database infrastructure with Drift tables, DAOs, and sync.

### Changed

- restrict auto updater to release builds and streamline adaptive button group widget.
- update CMake version and enhance error handling in StreamProviders.
- diff export.
- Initial plan.

## [0.36.0] - 2025-10-29

### Changed

- add documentation for core logger instance in logger.dart.
- improve logging and Firebase sync mechanisms in SyncEngine and DAO.
- update CMake version and enhance error handling in StreamProviders.

## [0.35.0] - 2025-10-29

### Changed

- replace SizedBox with ConstrainedBox for adaptive button group layout.
- update imports to include new Firebase model types in app_database.dart.
- replace Row with Wrap for improved layout in adaptive_scaffold.dart.

## [0.34.1] - 2025-10-29

### Added

- Migrate create_entity utility to use Drift repository.
- Migrate chapter create utilities for adventure and scene.
- Address code review: use startsWith() for more precise ID filtering.
- Create initial docs structure with README, getting-started, and architecture docs.
- Add development, deployment, and features docs (code-gen, ci-cd, multi-window, quill-mentions, bestiary, deep-links testing).
- Complete new documentation structure: add remaining architecture, features, development, and reference docs.
- Remove old documentation files and update root README.md with new structure.

### Fixed

- Fix parent ID filtering in campaign and chapter screens.

## [0.34.0] - 2025-10-28

### Changed

- rename files and update imports to use new data structure.
- rename files and update imports to use new data structure.
- Initial plan.
- Initial plan.
- Migrate home and campaign screens from ODM to Drift.

## [0.33.0] - 2025-10-28

### Added

- Add party player loading, encounter saving, and inline combatant editing.
- Add Initiative Tracker UI with combat log and HP/condition tracking.
- Add Drift tables, DAOs, and repositories for Party and Player models.

### Changed

- Refactor to use Drift repositories instead of ODM directly.

## [0.32.0] - 2025-10-28

### Added

- Implement party selection, monster browser, and live difficulty display.
- Add code generation instructions.
- Add image display and editing support to entity screens.

### Changed

- Switch to AdaptiveBreadcrumb widget with breadcrumb_service integration.
- update copilot-instructions to include offline-first data persistence details.
- add offline-first data persistence details to copilot instructions.
- Update Drift schema and DAO for Session share fields.

## [0.31.1] - 2025-10-28

### Added

- Add PR summary document.
- Add comprehensive reviewer checklist.
- Add architectural documentation for multi-window feature.
- Add comprehensive implementation summary.
- Add user experience demo documentation.
- Add Drift table support for entityIds field with schema migration.

### Changed

- Simplify isSupported logic after code review.

### Fixed

- Fix platform checks for web compilation.

## [0.31.0] - 2025-10-28

### Added

- Add summary and checklist documents.
- Add comprehensive implementation summary.
- Add context menu to navigation lists and create documentation.

### Fixed

- Fix DateFormat to use automatic locale detection instead of explicit locale string.
- Fix ODM instance access in EntityGatherer service.

## [0.30.1] - 2025-10-28

### Added

- Add FutureBuilder key optimization and improve documentation.
- Add basic encounter builder and view screens.
- Address code review feedback: remove unused imports, use proper date formatting, add clarifying comments.
- Add comprehensive documentation for encounter builder feature.
- Add multi-window service and context menu widget.
- Add documentation and code generation script for entities feature.

### Changed

- Integrate entities widget into all screens (Campaign, Chapter, Adventure, Scene, Encounter).
- Apply final code review suggestions: improve comments and use locale-specific date formatting.

## [0.30.0] - 2025-10-28

### Added

- Add tests for adaptive breadcrumb and button group widgets.
- Add entityIds field to models and create entities widget infrastructure.

### Fixed

- Fix session breadcrumb to use datetime instead of non-existent name field.

## [0.29.2] - 2025-10-28

### Added

- Add build instructions and performance notes.
- Add comprehensive implementation summary.
- Add breadcrumb service to resolve entity IDs to names.
- Add adaptive breadcrumb and button group widgets with overflow handling.
- Add encounter difficulty calculation service and tests.

### Changed

- Initial plan.
- Initial plan.
- Integrate AdaptiveButtonGroup in wide mode layout.

## [0.29.1] - 2025-10-28

### Added

- Address code review feedback - improve documentation clarity.
- Implement entity screen and entity edit screen with kind-specific fields.
- Add Session view/edit screens and share functionality.

### Changed

- Initial plan.
- Initial plan.
- Initial plan.
- Initial plan.
- Initial plan.

## [0.29.0] - 2025-10-27

### Added

- Add .env.example, create assets/images directory, and update workflows.
- Add documentation for GitHub secrets setup.

### Changed

- Initial plan.

## [0.28.0] - 2025-10-27

### Added

- Add implementation summary for beta/production channels.
- add beta badge to indicate beta version in adaptive scaffold.
- enhance WindowTopBar with dynamic title widget and adjust layout for improved UI.

### Changed

- rename documentation files for improved organization.
- improve code readability and organization in auto_updater_service and persistence_service.

### Fixed

- update .gitignore to ignore all workspace.xml files.
- refine .gitignore to exclude specific IDE and Flutter ephemeral directories.

## [0.27.1] - 2025-10-27

### Added

- Add release helper script and update README with packaging info.
- Add implementation summary and setup checklist documentation.
- Add visual implementation summary.
- Add beta/production release channels with separate appcast feeds.
- Add comprehensive release channels documentation.

### Changed

- Initial plan.
- gitignore.

### Fixed

- Resolve merge conflicts - move docs and integrate drift_providers.

## [0.27.0] - 2025-10-27

### Added

- Add BestiaryProvider and comprehensive documentation.
- Address code review feedback - improve testability and error handling.
- Add Fastforge configuration and auto_updater integration.

### Changed

- Initial plan.

## [0.26.0] - 2025-10-27

### Added

- integrate SyncStateProvider and SyncStateWidget for improved synchronization status display.
- Add multi-box support to PersistenceService and implement BestiaryService.
- enhance adaptive scaffold layout with synchronized state display and new asset icons.

### Changed

- Initial plan.

### Fixed

- Fix card flip - front face now hidden after flip.

## [0.25.1] - 2025-10-27

### Added

- add NonNullJsonMapConverter for safe JSON mapping in Drift storage.
- update entity and campaign DAOs to use NonNullJsonMapConverter for improved JSON handling.
- add generated color constants for consistent theming in Flutter app.

### Changed

- rename library in quill_mention.dart for clarity.
- improve code formatting and readability in custom_quill_editor.dart.
- Initial plan.

### Fixed

- improve error handling in hotkey service and update variable declaration in custom editor.
- update isDirty checks in campaign repository tests for correct parameter usage.

## [0.25.0] - 2025-10-27

### Changed

- remove unused database connection constructor from AppDatabase.

### Fixed

- Fix remaining Insertable errors in Adventures and Campaigns DAOs.
- Fix Entities table to match Entity model defaults for statblock and coords.

## [0.24.0] - 2025-10-27

### Added

- Fix build errors: update Drift API usage, add missing imports, fix DAO insertions.
- add generated DAO mixins for database accessors.

### Changed

- simplify entity DAO field assignments and improve code readability.

### Fixed

- Fix DAO insertions to use Companion classes explicitly.

## [0.23.0] - 2025-10-27

### Added

- Add SyncStateWidget with animated icons and provider.
- Add repositories for all models and wire to providers.
- Add completion documentation and sync state demo.

## [0.22.0] - 2025-10-27

### Added

- Add Drift tables and DAOs for all models (Adventure, Chapter, Encounter, Entity, Scene, Session, MediaAsset).
- Add generic sync engine and Firebase Storage sync service.
- update pubspec.yaml with new dependencies and icon assets.

## [0.21.2] - 2025-10-27

### Added

- Add complete Drift offline-first infrastructure.
- Add documentation and setup scripts for Drift implementation.
- Add final implementation summary.
- Add comprehensive file listing for Drift implementation.
- improve error logging in hotkey service for plugin availability and exceptions.

### Changed

- Initial plan.
- Aktualisieren von .gitignore.
- Aktualisieren von .env.

## [0.21.1] - 2025-10-26

### Added

- add GitHub label to stars count in index.html and update workspace.xml comments.
- Add animated background to Hero Section with accessibility support.
- Add performance optimizations and CSS variables for animated backgrounds.
- Add clarifying comment for reduced motion background position.

### Changed

- Initial plan.
- improve logging for hotkey manager error handling.
- Initial plan.
- Replace gradient decorations with animated mesh gradient background.

## [0.21.0] - 2025-10-26

### Added

- add initial project files including configuration and asset manifests.
- enhance hero section with new decorations and adjust logo size.

### Changed

- Move logo above title in hero section as requested.

## [0.20.0] - 2025-10-26

### Added

- Add tests for hotkey service and wrapper.
- update Vercel configuration for static site deployment paths.
- update Vercel configuration for static site deployment paths.
- update .gitignore to exclude build directory while including web subdirectory.
- add initial project files including configuration and asset manifests.

## [0.19.0] - 2025-10-26

### Added

- add Contents.json for Moonforge icons and logos.
- update download section to indicate upcoming releases and disable buttons.
- Implement landing page UI updates - hero, navbar, GitHub stars, and feature card flip.
- add Vercel configuration for static site deployment.

### Changed

- Initial plan.
- Remove test file.
- Initial plan.

### Fixed

- Fix Flutter web hotkey errors with platform guards and initialization.

## [0.18.1] - 2025-10-26

### Added

- Create modern dark-themed website for Moonforge.
- Add dynamic roadmap loading from roadmap.md file.
- add GitHub Actions workflow for deploying website to GitHub Pages.
- enhance GitHub Actions workflow for deploying website with conditional Pages setup.

### Changed

- Use official Moonforge colored icon from assets.
- remove.
- Update artifact upload path in static.yml.
- Rename static.yml to website.yml.

## [0.18.0] - 2025-10-26

### Added

- enhance UI components, editor functionality, and layout structure.

### Changed

- Initial plan.

### Fixed

- Fix entity retrieval to return entity directly.

## [0.17.0] - 2025-10-26

### Added

- Add datetime utility functions to handle sentinel timestamp values.
- Add comprehensive tests for datetime utility functions.
- improve Campaign screen state management and rich text display.

### Changed

- Initial plan.

### Fixed

- Fix datetime validation to include dates from 1900 onwards.
- Fix flutter_quill API usage and Firestore ODM integration.

## [0.16.2] - 2025-10-26

### Added

- Add tests and documentation for mention feature.
- Add chapter-specific menu actions in menu_registry.dart.
- Add const modifiers for better performance.
- Implement scene screen and scene edit screen with summary field.
- Add dedicated scene menu with newEntity button.

### Changed

- Update generated files for Scene model with summary field.
- Initial plan.

### Fixed

- Fix capitalization in documentation.

## [0.16.1] - 2025-10-26

### Added

- Add custom Quill editor and viewer with mention support.
- Implement chapter_screen.dart and chapter_edit_screen.dart with all required features.
- Implement adventure_screen.dart and adventure_edit_screen.dart with menu registry.

### Changed

- Initial plan.
- Initial plan.
- Initial plan.
- Initial plan.
- Integrate mention feature into campaign screens.

## [0.16.0] - 2025-10-26

### Added

- integrate Quill editor and custom toolbar for enhanced rich text editing in campaign details.
- refactor home screen layout with SurfaceContainer and WrapLayout for improved UI structure.
- update breadcrumb divider from icon to text for improved clarity.

## [0.15.0] - 2025-10-26

### Added

- Implement get_storage persistence for campaign and autosave.
- Address code review feedback: fix memory leaks and auto-restore behavior.
- Add quick start guide for persistence features.
- enhance campaign editing experience with new UI components and localization support.

### Changed

- Initial plan.

## [0.14.0] - 2025-10-26

### Added

- enhance campaign screen with QuillEditor for rich text display and improve layout structure.
- add TitleCard and WrapLayout widgets for improved UI structure and layout flexibility.
- add get and get_storage packages for state management and data persistence.

## [0.13.0] - 2025-10-26

### Added

- refactor main.dart to use MultiProviderWrapper and improve app initialization.
- update project dependencies and reorganize workspace configuration for improved clarity.
- add localization support for description and content fields in multiple languages.

## [0.12.1] - 2025-10-26

### Added

- add MultiProviderWrapper for managing multiple providers in the widget tree.
- implement recent sections for campaigns, sessions, and parties in HomeScreen.
- add AppSettingsProvider for managing app settings and user preferences.
- refactor app initialization to use AppSettingsProvider and MultiProviderWrapper.
- update project dependencies and exclude unnecessary folders from build.
- Address code review feedback and clarify documentation.

### Changed

- Update documentation to reference deep linking.

### Fixed

- Fix docstring to reflect current supported deep link formats.

## [0.12.0] - 2025-10-26

### Added

- add User model with settings and localization support.
- add untranslated messages file for localization support.
- add project guidelines for Moonforge repository.

## [0.11.0] - 2025-10-26

### Added

- refactor AdaptiveScaffold to use state management and improve navigation handling.
- refactor command palette and hotkey management for improved state handling and logging.
- implement CampaignEditScreen with rich text editing and campaign management.

## [0.10.0] - 2025-10-26

### Added

- add generic CardList widget for rendering lists with title and subtitle.
- Add comprehensive testing guide for deep linking.
- refactor authentication handling with AuthProvider and improve user sign-in flow.

## [0.9.0] - 2025-10-26

### Added

- Implement deep linking support for all platforms.
- add loading, empty, and error placeholders for async content handling.
- implement creation functionality for campaigns, chapters, adventures, entities, and scenes.
- add menu registry for route-specific menu actions.
- enhance Firestore security rules for user and campaign access control.

### Changed

- update folder structure documentation with detailed explanations for app components.

## [0.8.0] - 2025-10-26

### Added

- add localization strings for chapters, adventures, and scenes in English and German.

### Changed

- Initial plan.
- reorganize dependencies in pubspec.yaml for clarity and maintainability.

## [0.7.0] - 2025-10-19

### Added

- integrate `flutter_dotenv` for environment variable management and update Firebase config to use `.env` file.

### Changed

- Aktualisieren von CONTRIBUTING.md.
- moved app to subfolder moonforge/.

## [0.6.0] - 2025-10-17

### Added

- add support for multiple app icons and logos with updated asset management.
- add localization support with German and English translations, and implement theme and language settings in the UI.

### Changed

- expand README with detailed platform support, tech stack, setup steps, and contribution guidelines.

## [0.5.0] - 2025-10-16

### Added

- implement user authentication with email/password and Google sign-in, add login and password reset screens.
- add hotkey system, forgot password screen, and generated asset management files with logo icons.
- update routing to use typed routes and add new dependencies for improved navigation.

## [0.4.0] - 2025-10-14

### Added

- add generated models and builders for JoinCode, ChapterDoc, AdventureDoc, SceneDoc, EncounterDoc, and MediaAssetDoc with JSON serialization support.
- simplify Campaign model by removing unused fields and updating JSON serialization.
- add Firestore ODM models for JoinCode, Session, Party, Chapter, and MediaAsset with JSON serialization support.

## [0.3.0] - 2025-10-14

### Added

- implement responsive layout with adaptive navigation and two-pane support.
- integrate Firebase authentication and Firestore with Riverpod, add dynamic theming support.
- add Firestore ODM models for campaign, chapter, adventure, scene, encounter, and media asset with JSON serialization support.

## [0.2.0] - 2025-10-13

### Added

- Add GitHub Actions workflow for Dart CI.

### Changed

- refactor workspace configuration and update task summaries for clarity.
- add contributing guide and license information.

## [0.1.0] - 2025-10-10

### Added

- add initial screens and routing for campaign, chapter, adventure, and encounter features.
- add initial project structure and configuration files for moonforge.

### Changed

- Initial commit.
