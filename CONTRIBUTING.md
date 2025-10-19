# Contributing to Moonforge

Thanks for your interest in contributing! This guide helps you get set up and submit high‑quality pull requests with minimal friction.

- Project type: Flutter (Dart), multi‑platform (Windows, Linux, macOS, Web, Android, iOS)
- Key libs: Riverpod, go_router (typesafe), Freezed, Firebase (Auth, Firestore, Storage, Remote Config), Firestore ODM
- Structure: see docs/folder_structure.md

## Quick start

Prerequisites:
- Flutter SDK (stable channel) installed and on PATH
- Dart comes with Flutter
- Optional: Firebase CLI for configuring your own Firebase project

Install and run:

```cmd
flutter --version
cd moonforge
flutter pub get

:: Generate code for freezed/json_serializable/go_router/odm/i18n
dart run build_runner build --delete-conflicting-outputs

:: Run tests
flutter test

:: Launch app (choose a device/platform you have installed)
flutter run -d windows
```

Tip: For iterative development with generators, use a file watcher:

```cmd
dart run build_runner watch --delete-conflicting-outputs
```

## Development workflow

1) Fork and clone
- Fork the repo on GitHub, then clone your fork.
- Add the upstream remote so you can sync later.

2) Create a branch
- Use a descriptive branch name:
  - feature/<short‑slug>
  - fix/<short‑slug>
  - chore/<short‑slug>

3) Code style and quality
- Format: `dart format .`
- Lint: `flutter analyze`
- Tests: `flutter test`
- Keep PRs focused and reasonably small; add unit/widget tests for new behavior when practical.

4) Code generation
- When you edit models/routes/odm annotations, run:
  - `dart run build_runner build --delete-conflicting-outputs` (one‑off) or `dart run build_runner watch --delete-conflicting-outputs` (continuous)
- Don’t commit `.g.dart` files if the project ignores them; otherwise commit generated files to keep CI green.

5) Firebase configuration
- The repo contains `moonforge/lib/firebase_options.dart` and platform configs under moonforge/ for development.
- If you use your own Firebase project, run `firebase login` and `flutterfire configure` to regenerate options.
- Avoid committing private keys or project‑specific secrets.

6) Commit messages
- Prefer Conventional Commits style (recommended, not mandatory):
  - feat: add XYZ
  - fix: correct crash when ABC
  - chore: update deps
  - docs: improve README
  - refactor/test/build/ci/etc.

7) Open a Pull Request
- Base branch: `main` (unless otherwise specified)
- Fill out the PR description with context, screenshots/GIFs for UI changes, and any migration notes
- Link related issues (e.g., Closes #123)

### PR checklist
- [ ] Code formatted and lints pass (`dart format .` and `flutter analyze`)
- [ ] Tests pass (`flutter test`) and new tests added where it makes sense
- [ ] Ran codegen if needed (`dart run build_runner build --delete-conflicting-outputs`)
- [ ] No secrets or private configs committed
- [ ] Updated docs (README/inline) when changing behavior or adding features

## Reporting bugs and requesting features
- Use GitHub Issues with a clear title and reproduction steps.
- For bugs, include environment info (OS, Flutter version), logs, and screenshots if UI‑related.

## Code of conduct
Be respectful and constructive. Harassment, discrimination, and toxic behavior are not tolerated. By participating, you agree to foster a welcoming, inclusive environment for all contributors and users.

## License
Contributions are made under the MIT License. By submitting a PR, you agree your contributions will be licensed under the repository’s LICENSE.

