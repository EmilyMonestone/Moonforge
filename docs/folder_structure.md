# Folder Structure
Repository layout and app folder structure.

Repo layout (root):
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

App folder structure (moonforge/):
```
lib/
├───  main.dart
├───  core/
│   ├──  models/
│   ├──  repositories/
│   ├──  services/
│   ├──  widgets/
│   ...
├───  features/
│   ├──  editor/
│   │   ├─── models/            # Data models representing the business logic entities
│   │   ├─── views/             # UI screens and widgets
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