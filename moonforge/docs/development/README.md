# Developer Guide

This developer guide summarizes common tasks, conventions, and commands for contributors.

Getting started

1. Install Flutter (matching the project's SDK constraint)
2. Run `flutter pub get`
3. Initialize code generation (if needed):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Useful commands

- Static analysis: `flutter analyze`
- Format code: `dart format .`
- Run unit/widget tests: `flutter test`
- Run a subset of tests: `flutter test test/features/campaign`

Project conventions

- One public class per file
- File names in snake_case
- Public APIs documented with dartdoc (use `///`)
- Keep UI logic inside widgets; business logic goes to `services/` files

Testing

- See `test/README.md` for test conventions and running tests

Code generation

- Generated files (e.g., `*.g.dart`) are committed when necessary. To regenerate use the build_runner command above.

CI

- GitHub Actions commands are in `.github/workflows/test.yml` — CI runs `flutter analyze` and a subset of tests on PRs.

Contact

If you need help, ask the team or open an issue in the repo's issue tracker.

