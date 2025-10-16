# Moonforge Project Guidelines

These guidelines help contributors and Junie work efficiently in this repository.

## Project Overview

Moonforge is a Flutter application for tabletop RPG campaign management. It organizes content into core domain models (campaigns, chapters, encounters, entities, scenes, sessions,
media assets) and feature-specific UI flows. Data schemas and JSON serialization are defined in lib/core/models, with generated helpers committed to the repo.

## Project Structure (high-level)

- lib/
    - core/
        - models/ — Domain models, schema, and converters (beware of generated files like *.g.dart).
        - providers/, repositories/, services/, utils/, widgets/ — App foundation and cross-cutting utilities.
    - features/
        - adventure, auth, campaign, chapter, encounters, entities, home, parties, scene, session, settings — Feature modules containing views, controllers, and state.
    - layout/ — App-level layout and navigation scaffolding.
- test/ — Dart/Flutter unit and widget tests.
- docs/ — Project documentation (e.g., firebase_schema.md, responsive layout notes).
- platform folders (android/, ios/, macos/, linux/, windows/, web/) — Platform-specific runners and configs.

## Project Information

- The Layout (scaffold) is defined in lib/layout/app_scaffold.dart.
- For notification use package toastification.
- For logging use package logger with util lib/core/utils/logger.dart

## Generated Code

- Do not edit generated files by hand (e.g., *.g.dart, *.gr.dart). Update the source annotations and re-generate when necessary.
- Router and serialization code lives in files like app_router.gr.dart and schema.g.dart.

## How to Run Analysis and Tests

- Static analysis:
    - flutter analyze
- Format code:
    - dart format .
- Run tests (default):
    - flutter test
- Run a specific test file:
    - flutter test test/path/to/file_test.dart

Junie guidance: If you modify Dart code, run flutter analyze and flutter test before submitting, unless the change is doc-only.

## Build Notes

- Typical build commands (run only when requested or needed):
    - Android APK: flutter build apk
    - iOS: flutter build ios (requires macOS and Xcode)
    - Web: flutter build web
    - Desktop (example): flutter build windows

## Code Style

- Follow Dart style; ensure code is formatted via dart format .
- Keep lints clean according to analysis_options.yaml.
- Prefer small, focused widgets and keep business logic out of UI where practical.
- Prefer one file per class.
- Document public APIs and non-trivial logic with concise comments.

## Contribution Tips

- Keep changes minimal and scoped.
- Update or add tests when changing logic.
- Reflect model/schema changes in docs (e.g., docs/firebase_schema.md) when appropriate.

## Junie-specific Notes

- Use specialized tools for search and edits; avoid modifying generated files.
- When editing, prefer the minimal changes necessary to satisfy the issue.
- Communicate plan and progress via update_status, and submit once verified.
