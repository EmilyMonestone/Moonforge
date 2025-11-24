# Architecture Overview

This document summarizes Moonforge's high-level architecture and key patterns.

Project layout

```
lib/
├── core/        # Shared utilities, models, widgets and DI
├── data/        # Persistence layer (drift, repositories, DAOs)
├── features/    # Feature modules (campaign, encounters, entities, etc.)
├── layout/      # App-level layout and navigation scaffolding
└── main.dart
```

Key patterns

- Feature-first organization: keep controllers, services, views, and widgets
  together under `lib/features/<feature>`.
- Layers: View (widgets) → Provider (state) → Service (business logic) →
  Repository (data access) → DAO/DB.
- Dependency injection: `get_it` is used to wire services and repositories at
  application startup (see `core/di/service_locator.dart`).
- Offline-first persistence: `drift` the local DB with sync helpers and an
  outbox for remote sync.

State management

- Provider is the primary state management solution. Providers expose
  `AsyncState<T>` which represents idle/loading/error/data states.
- Services encapsulate business logic and return domain models or state
  primitives to providers.

Data flow

1. UI triggers action in provider (e.g., create campaign)
2. Provider delegates to Service for business logic
3. Service uses Repository to persist/read data
4. Repository uses DAOs and the Drift database
5. Repository may enqueue outbox entries for sync
6. Provider updates state and UI reacts

Testing

- Unit tests target services and utilities (under `test/features/<feature>/services`).
- Widget tests exercise widgets with `pumpWidget` wrappers and small fakes.
- Integration tests that require DB or emulators should be isolated in
  `test/integration/`.

Notes & best practices

- Keep business logic out of widgets; prefer small, focused widgets.
- Use feature READMEs to document feature-specific flows and public APIs.
- Document complex algorithms in dartdoc close to the implementation.
- Add tests for service logic before modifying behavior.

This file is intentionally concise; see the `docs/refactor/` and individual
feature READMEs for more details.

