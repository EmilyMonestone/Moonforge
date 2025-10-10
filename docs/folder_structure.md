# Folder Structure
This is a rough example of the project structure. The actual structure may differ, depending on technical decisions and project requirements.
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