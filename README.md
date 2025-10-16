# Moonforge

A multi-platform campaign manager for Dungeons & Dragons built with Flutter. Moonforge helps Game Masters plan, run, and archive entire campaigns: chapters, scenes, encounters,
entities, sessions, media, and more — all synchronized across devices.

<p align="left">
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Platforms" src="https://img.shields.io/badge/Platforms-Desktop%20%7C%20Web%20%7C%20Mobile-6a5acd">
  <img alt="State" src="https://img.shields.io/badge/State-Riverpod-0aa">
  <img alt="Router" src="https://img.shields.io/badge/Routing-go__router-blueviolet">
  <img alt="Backend" src="https://img.shields.io/badge/Backend-Firebase-orange">
</p>

- Website/Docs coming soon — see docs folder for developer docs.
- Status: Actively developed. Desktop and Web are primary targets; iOS/macOS planned.

---

## Table of Contents

- [Features](#features)
- [Platform Support](#platform-support)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Internationalization (i18n)](#internationalization-i18n)
- [Routing](#routing)
- [Data & Firebase Schema](#data--firebase-schema)
- [Assets](#assets)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [FAQ](#faq)
- [License](#license)

## Features

- Campaign management with chapters, adventures, and scenes
- Rich text authoring with a markdown-compatible editor (Flutter Quill)
- Entity management: locations, items, NPCs/creatures, organizations
- Tagging and cross-linking between entities and story content
- Session planning and note-taking
- Media library: images, audio, video, with drag-and-drop on desktop
- Offline-first sync powered by Firebase; automatic conflict handling
- Player view for read-only campaign access
- Encounter builder and initiative tracker
- NPC and monster management; integration with the D&D SRD
- Multi-window support on desktop, split panes, keyboard shortcuts

## Platform Support

| Platform                               | Notes                                                                                                      |
|----------------------------------------|------------------------------------------------------------------------------------------------------------|
| Desktop (Windows/Linux; macOS planned) | Full feature set; multi-window; drag-and-drop media; split panes.                                          |
| Web                                    | Parity with desktop where possible; Player view opens in new tab; filesystem APIs limited by browser.      |
| Mobile (Android; iOS planned)          | Streamlined editor; read-only Player view; constrained media workflows; background sync defaults to Wi‑Fi. |

## Architecture & Tech Stack

- Flutter + Dart (stable channel)
- State management: Riverpod (flutter_riverpod)
- Navigation: go_router with type-safe routes via go_router_builder
- Data: Firebase (Auth, Firestore, Storage, Remote Config), offline-first patterns
- Data modeling: Freezed, Json Serializable, Firestore ODM
- Code generation: build_runner, flutter_gen (assets, colors)
- UI: Material 3, dynamic_color, window_manager, flutter_acrylic
- Rich text: flutter_quill
- Utilities: uuid, shared_preferences, package_info_plus, share_plus, hotkey_manager, command_palette
- Notifications & logging: toastification, logger (see lib/core/utils/logger.dart)

## Project Structure

High-level layout:

- lib/
    - core/
        - models/ — Domain models, schema annotations, converters (generated *.g.dart committed)
        - providers/, repositories/, services/, utils/, widgets/ — App foundation
    - features/
        - adventure, auth, campaign, chapter, encounters, entities, home, parties, scene, session, settings — Feature modules
    - layout/ — App-level scaffolding and navigation shells
    - gen/ — Generated asset accessors via FlutterGen
    - l10n/ — App localization ARB files
- docs/ — Developer documentation (e.g., firebase_schema.md, app_router.md)
- test/ — Unit/widget tests
- platform folders — android/, ios/, macos/, linux/, windows/, web/

See also: analysis_options.yaml for lints and code style.

## Getting Started

Prerequisites:

- Flutter SDK (stable). Install and set up per https://docs.flutter.dev/get-started/install
- A configured Firebase project (optional to run read-only features; required for sync/auth)

### Setup

**1\. Install dependencies**

```sh
flutter pub get
```

**2\. Generate code (models, router, assets)**

```sh
dart run build_runner build --delete-conflicting-outputs
```

**3\. Run the app**

- **Windows/Linux/macOS:**
  ```sh
  flutter run -d windows|linux|macos
  ```
- **Web:**
  ```sh
  flutter run -d chrome
  ```
- **Android/iOS:**
  ```sh
  flutter run -d <device_id>
  ```

**4\. Quality checks**

- **Static analysis:**
  ```sh
  flutter analyze
  ```
- **Format:**
  ```sh
  dart format .
  ```
- **Tests:**
  ```sh
  flutter test
  ```

## Development Workflow

- Code generation in watch mode during active development:
    - dart run build_runner watch --delete-conflicting-outputs
- Keep lints clean; follow the repository’s analysis_options.yaml
- Prefer small, focused widgets and keep business logic out of UI when possible
- Generated files (*.g.dart, *.gr.dart) must not be edited by hand
- When changing routes or models, update annotations and rerun build_runner

## Internationalization (i18n)

- All user-facing text is internationalized
- ARB source files live under lib/l10n (e.g., app_de.arb)
- After adding new strings, run: flutter pub get (to regenerate l10n delegates)
- See l10n.yaml for configuration

## Routing

Moonforge uses go_router with type-safe route definitions. Start with the developer doc:

- docs/app_router.md

Key files:

- lib/core/services/app_router.dart (annotations and configuration)
- lib/core/services/app_router.g.dart (generated; do not edit)

## Data & Firebase Schema

The canonical Firestore and Storage layout, index recommendations, and security notes are documented here:

- docs/firebase_schema.md

## Assets

- Asset management is powered by FlutterGen
- Access assets via generated helpers (e.g., lib/gen/assets.gen.dart)
- Configure assets in pubspec.yaml under flutter/assets and flutter_gen

## Contributing

Contributions are welcome! Please read the contributing guide for setup, coding standards, and the PR checklist:

- CONTRIBUTING.md

Quick start for contributors:

- Ensure Flutter (stable) is installed
- flutter pub get
- dart run build_runner build --delete-conflicting-outputs
- flutter test

Please keep PRs focused, follow Conventional Commits when possible, and ensure lints/tests pass.

## Roadmap

- macOS and iOS runners and UI polish
- Extended Player mode for tablets/phones
- Deeper D&D 5e SRD integration and import tools
- Collaboration tooling (presence, comments), conflict resolution improvements
- Improved media workflows (batch uploads, clipping, annotations)

## FAQ

- Why Flutter? Single codebase for Desktop/Web/Mobile, excellent developer ergonomics, and strong community tooling.
- Offline-first? Firestore’s local cache and sync primitives are leveraged; we increment a rev field for conflict resolution patterns.
- Can I self-host? The app targets Firebase; advanced users can fork and adapt providers, but Moonforge ships with Firebase by default.

## License

This project is licensed under the MIT License. See LICENSE for details.
