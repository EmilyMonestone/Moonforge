# Moonforge

A multiplatform manager for Dungeons&Dragons campaigns written in flutter.

## Features

- Campaign management
- Writing story content with markdown-compatible editor
- Entity management (locations, items, characters)
- Tagging and linking between entities and story content
- Session notes
- Media management (images, audio, video)
- Synchronization across devices with firebase; offline-first
- Player view for read-only access to campaign content
- Encounter builder and initiative tracker
- NPC and monster management; integration with D&D SRD
- Multi-window support on desktop

## Platforms

| Platform                                | Features                                                                                                             |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **Desktop (Win/macOS (planned)/Linux)** | Full feature set; multi-window; drag-drop media; split panes.                                                        |
| **Web**                                 | Same as desktop; Player opens in new tab; filesystem access limited.                                                 |
| **Mobile (Android/iOS (planned))**      | No multi-window; trimmed editor; read-only Player view; limited media management; background sync defaults to Wi-Fi. |

## Docs

- Firebase data schema: [docs/firebase_schema.md](docs/firebase_schema.md)

## Contributing

Contributions are welcome! Please read the contributing guide for setup, coding standards, and the PR
checklist: [CONTRIBUTING.md](CONTRIBUTING.md).

Quick start:

- Ensure Flutter (stable channel) is installed
- Install deps: `flutter pub get`
- Run codegen: `dart run build_runner build -d`
- Run tests: `flutter test`

If you open a PR, please keep changes focused, follow (recommended) Conventional Commits, and make sure lints/tests
pass.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
