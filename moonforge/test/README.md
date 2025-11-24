# Tests

This folder contains unit and widget tests for the Moonforge app.

Quick commands

- Run all tests:

```bash
flutter test
```

- Run a single test file:

```bash
flutter test test/features/campaign/services/campaign_service_test.dart
```

- Run only widget tests:

```bash
flutter test test/widgets
```

Notes

- We prefer `mocktail` for lightweight mocking (no codegen). If you need generated mocks (mockito), run `flutter pub run build_runner build --delete-conflicting-outputs` before
  running tests.
- Integration tests that require DB access or emulators should live under `test/integration/` and are NOT run by default in CI.

