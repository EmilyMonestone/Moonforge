# Moonforge Developer Documentation

Welcome to the Moonforge developer documentation! This guide helps developers understand, build, and contribute to Moonforge - a multi-platform campaign manager for D&D built with
Flutter.

## 📚 Documentation Structure

### Getting Started

- **[Getting Started Guide](getting-started.md)** - Quick setup for new developers

### Architecture

- **[Overview](architecture/overview.md)** - High-level architecture and tech stack
- **[Data Layer](architecture/data-layer.md)** - Firebase, Firestore, and sync patterns
- **[Offline Sync](architecture/offline-sync.md)** - Drift offline-first implementation
- **[Routing](architecture/routing.md)** - go_router, deep linking, and navigation
- **[State Management](architecture/overview.md)** - In-house state controllers and provider classes (see Architecture Overview)

### Features

- **[Campaigns](features/campaigns.md)** - Campaign management and rich text editing
- **[Entities](features/entities.md)** - NPCs, monsters, places, items, and bestiary
- **[Encounters](features/encounters.md)** - Encounter builder and initiative tracker
- **[Sessions](features/sessions.md)** - Session planning and logs
- **[Media](features/media.md)** - Media library and Firebase Storage
- **[Multi-Window](features/multi-window.md)** - Multi-window support (desktop/web)

### Development

- **[Code Generation](development/code-generation.md)** - build_runner, freezed, and ODM
- **[Testing](development/testing.md)** - Testing guidelines and tools
- **[Localization](development/localization.md)** - i18n setup and workflow
- **[Platform-Specific](development/platform-specific.md)** - Platform configs and notes

### Deployment

- **[Building](deployment/building.md)** - Building for different platforms
- **[Packaging](deployment/packaging-quickref.md)** - Fastforge packaging and distribution (quickref)
- **[Releases](deployment/releases.md)** - Release workflow and channels
- **[CI/CD](deployment/ci-cd.md)** - GitHub Actions and automation

### Reference

- **[Firebase Schema](reference/firebase-schema.md)** - Complete Firestore schema reference
- **[Folder Structure](reference/folder-structure.md)** - Project organization
- **[Troubleshooting](reference/troubleshooting.md)** - Common issues and solutions

## 🚀 Quick Links

### For New Contributors

1. Read [Getting Started](getting-started.md)
2. Review [Architecture Overview](architecture/overview.md)
3. Check [Code Generation](development/code-generation.md) guide
4. See [Contributing Guide](../CONTRIBUTING.md) in repo root

### For Feature Development

- Understand the [Data Layer](architecture/data-layer.md) and [Offline Sync](architecture/offline-sync.md)
- Review relevant feature docs in [Features](features/)
- Check [Architecture Overview](architecture/overview.md) for state management patterns

### For Platform Work

- See [Platform-Specific](development/platform-specific.md) configs
- Review [Routing](architecture/routing.md) for deep linking setup
- Check [Building](deployment/building.md) for platform-specific builds

### For Releases

- Read [Packaging](deployment/packaging-quickref.md) guide
- Understand [Release Workflow](deployment/releases.md)
- Check [CI/CD](deployment/ci-cd.md) automation

## 🔧 Generated code & files (important)

Moonforge relies on generated sources for models, routing, localization, and database helpers. These files are often committed to the repository but should not be edited manually —
instead update the source annotations and re-run the project's code generation steps.

Common generated patterns:

- `*.g.dart` (JSON serialization, Firestore ODM)
- `*.freezed.dart` (Freezed data classes)
- `*.gr.dart` (generated router code)
- Drift-generated database helpers
- `lib/gen/` (FlutterGen asset helpers)

See [CODEGEN_REQUIRED.md](CODEGEN_REQUIRED.md) and the Code Generation guide for commands and troubleshooting.

## 📖 External Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [go_router Documentation](https://pub.dev/packages/go_router)

## 🔍 Finding What You Need

- **Architecture questions?** → Start with [Architecture Overview](architecture/overview.md)
- **How to add a feature?** → Check relevant [Features](features/) doc
- **Build failing?** → See [Troubleshooting](reference/troubleshooting.md)
- **New to the codebase?** → Follow [Getting Started](getting-started.md)
- **Making a release?** → Read [Deployment](deployment/) guides
- **Feature incomplete?** → Check relevant feature docs in [Features](features/) for gaps and implementation needs

## 💡 Documentation Principles

These docs focus on:

- **Current state** - How things work now, not historical implementation details
- **Developer needs** - How to use, extend, and debug features
- **Practical examples** - Real code snippets and file paths
- **Clear organization** - Easy to find what you need

## 🤝 Contributing to Docs

Found an error or want to improve the docs? See [CONTRIBUTING.md](../CONTRIBUTING.md) and submit a PR!
