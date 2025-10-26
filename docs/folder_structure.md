# Folder Structure

Repository layout and app folder structure.

## Repo layout (root)

```
/ (repo root)
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── docs/
├── tools/
└── moonforge/
    ├── pubspec.yaml
    ├── analysis_options.yaml
    ├── lib/
    ├── test/
    ├── android/ ios/ linux/ macos/ windows/ web/
    └── assets/
```

## App folder structure (moonforge/)

```
lib/
├───  main.dart
├───  core/
│   ├──  models/
│   ├──  repositories/
│   ├──  services/
│   ├──  widgets/
│   ├──  providers/
│   ...
├───  features/
│   ├──  editor/
│   │   ├─── models/            # Data models representing the business logic entities
│   │   ├─── views/             # UI screens
│   │   ├─── widgets/             # widgets
│   │   ├─── controllers/       # Business logic controllers (For MVC/MVP patterns)
│   │   ├─── services/          # Services like API or database management
│   │   ├─── utils/             # Utility functions and constants
│   │   ...
│   ├──  campaign/
│   ├──  chapter/
│   ├──  adventure/
│   ├──  scene/
│   ├──  encounters/
│   ├──  entities/
│   ├──  parties/               # Groups/Parties feature of Players
│   ├──  session/
│   ├──  settings/
│   ├──  auth/
│   ...
...
```

## Explanations

### models/

Data classes and entities that represent the domain/business logic. These are typically plain Dart classes or freezed/json_serializable classes that define the shape of your data.
Examples: `User`, `Campaign`, `Character`, `Scene`.

### repositories/

Abstraction layer for data access. Repositories handle data operations from various sources (API, local database, cache) and provide a clean interface to the rest of the app. They
encapsulate the logic of where data comes from and how it's persisted.

### services/

Business logic and utility services that don't fit into repositories. These include API clients, authentication services, file handling, analytics, logging, and other cross-cutting
concerns. Services are typically singleton or provided via dependency injection.

### widgets/

Reusable UI components. In `core/widgets/`, these are shared across features. In `features/*/widgets/`, they're feature-specific. Widgets focus solely on presentation and should
receive data via parameters.

### views/

Full screens or pages in your app. Views compose multiple widgets and connect to providers/controllers to display data and handle user interactions. Each view typically represents
a route in your navigation.

### controllers/

Business logic layer that sits between views and data sources (in MVC/MVP patterns). Controllers handle user input, coordinate data fetching, manage state, and prepare data for the
UI. In Flutter, this role is often fulfilled by Riverpod providers or BLoC classes.

### providers/

Providers that manage state and dependency injection. These expose data and business logic to the UI layer. Providers can wrap repositories, services, or manage feature-specific
state. They enable reactive programming and proper dependency management.

### utils/

Helper functions, constants, extensions, and utility classes. These are pure functions or simple utilities that are reused across the feature or app. Examples: date formatters,
validators, string helpers, constants.
