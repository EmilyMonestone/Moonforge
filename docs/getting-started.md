# Getting Started with Moonforge Development

This guide helps new developers set up their development environment and understand the Moonforge codebase.

## Prerequisites

### Required Software

1. **Flutter SDK** (stable channel)
   ```bash
   flutter --version
   # Should show Flutter 3.x or later
   ```

   Install from: https://docs.flutter.dev/get-started/install

2. **Dart SDK** (included with Flutter)
   ```bash
   dart --version
   ```

3. **Git** for version control
   ```bash
   git --version
   ```

### Optional but Recommended

- **VS Code** or **Android Studio** with Flutter extensions
- **Firebase CLI** for Firebase configuration (if modifying backend)
- **Platform-specific tools** (see [Platform-Specific Guide](development/platform-specific.md)):
    - **Windows**: Visual Studio 2022 with C++ workload
    - **macOS**: Xcode 14+ and command line tools
    - **Linux**: GTK 3 development libraries

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/EmilyMoonstone/Moonforge.git
cd Moonforge/moonforge
```

### 2. Install Dependencies

```bash
flutter pub get
```

This downloads all Dart/Flutter packages defined in `pubspec.yaml`.

### 3. Create Environment File

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and add your Firebase Web API key:

```
FIREBASE_API_KEY=your-firebase-web-api-key-here
```

> **Note**: Get your API key from the [Firebase Console](https://console.firebase.google.com/) under Project Settings > General > Your apps > Web apps > Config.

The `.env` file is gitignored for security.

### 4. Generate Code

Moonforge uses code generation extensively for models, routes, and assets:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:

- `*.g.dart` files (JSON serialization, Firestore ODM)
- `*.freezed.dart` files (immutable models)
- `*.gr.dart` files (go_router routes)
- Asset helpers in `lib/gen/`

**For continuous development**, use watch mode:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 5. Run the App

Choose your target platform:

```bash
# Desktop
flutter run -d windows    # Windows
flutter run -d linux      # Linux
flutter run -d macos      # macOS

# Web
flutter run -d chrome

# Mobile
flutter run -d <device_id>  # List devices with: flutter devices
```

## Verify Your Setup

Run these commands to ensure everything is working:

```bash
# Check Flutter installation
flutter doctor -v

# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test
```

All should complete without errors (warnings are okay for doctor).

## Project Structure Overview

```
moonforge/
├── lib/
│   ├── core/              # Core app functionality
│   │   ├── models/        # Data models (Campaign, Entity, etc.)
│   │   ├── services/      # Services (router, auth, storage, etc.)
│   │   ├── providers/     # Riverpod providers
│   │   ├── widgets/       # Reusable UI components
│   │   └── utils/         # Utility functions
│   ├── features/          # Feature modules
│   │   ├── campaign/      # Campaign management
│   │   ├── entities/      # Entity management (NPCs, monsters, etc.)
│   │   ├── encounters/    # Encounter builder
│   │   ├── session/       # Session planning
│   │   └── ...
│   ├── layout/            # App-level layout and navigation
│   ├── data/              # Data layer (Drift, Firebase sync)
│   ├── gen/               # Generated code (assets, colors)
│   └── l10n/              # Localization files
├── test/                  # Unit and widget tests
├── assets/                # Images, fonts, etc.
└── platform folders/      # android/, ios/, web/, windows/, linux/, macos/
```

See [Folder Structure Reference](reference/folder-structure.md) for details.

## Key Technologies

Understanding these will help you navigate the codebase:

- **[Flutter](https://flutter.dev/)** - UI framework
- **[Provider]** - State management
- **[go_router](https://pub.dev/packages/go_router)** - Navigation ([guide](architecture/routing.md))
- **[Freezed](https://pub.dev/packages/freezed)** - Immutable models
- **[Drift](https://drift.simonbinder.eu/)** - SQLite for offline-first ([guide](architecture/offline-sync.md))
- **[Firebase](https://firebase.google.com/)** - Backend (Auth, Firestore, Storage) ([guide](architecture/data-layer.md))

## Development Workflow

### Making Changes

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our [code style guidelines](../CONTRIBUTING.md)

3. **Generate code** if you modified models/routes:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Test your changes**:
   ```bash
   flutter analyze    # Check for issues
   dart format .      # Format code
   flutter test       # Run tests
   ```

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request** on GitHub

### Common Tasks

#### Adding a New Screen

1. Create route in `lib/core/services/app_router.dart`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Create view in appropriate feature folder
4. Add to navigation (see [Routing Guide](architecture/routing.md))

#### Adding a New Model

1. Create model in `lib/core/models/` or feature-specific folder
2. Add Freezed and JSON annotations
3. Run code generation
4. Update Drift tables if needed (see [Offline Sync Guide](architecture/offline-sync.md))

#### Adding Localized Strings

1. Add strings to `lib/l10n/app_en.arb`
2. Add translations to `lib/l10n/app_de.arb` (if applicable)
3. Run `flutter pub get` to regenerate
4. Use via `AppLocalizations.of(context)!.yourString`

See [Localization Guide](development/localization.md) for details.

## Next Steps

Now that you're set up, explore:

1. **[Architecture Overview](architecture/overview.md)** - Understand the system design
2. **[Feature Docs](features/)** - Learn about specific features
3. **[Code Generation Guide](development/code-generation.md)** - Deep dive into generators
4. **[Contributing Guide](../CONTRIBUTING.md)** - Contribution guidelines

## Getting Help

- **Build issues?** → Check [Troubleshooting Guide](reference/troubleshooting.md)
- **Architecture questions?** → Read [Architecture docs](architecture/)
- **Feature questions?** → See [Feature docs](features/)
- **General questions?** → Open a GitHub issue

## Common Issues

### Code generation fails

```bash
# Clean and regenerate
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Import errors after generation

- Restart your IDE/analyzer
- Run `flutter pub get`

### Firebase connection issues

- Check your `.env` file has the correct API key
- Verify Firebase project is configured correctly

### Platform-specific build failures

See [Platform-Specific Guide](development/platform-specific.md) for detailed troubleshooting.

## Resources

- [Main README](../README.md) - Project overview
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute
- [Firebase Schema](reference/firebase-schema.md) - Database structure
- [Folder Structure](reference/folder-structure.md) - Code organization

Happy coding! 🚀
