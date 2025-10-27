# Drift Implementation - Files Created

This document lists all files created as part of the Drift offline-first implementation.

## Production Code (18 files)

### Dependencies
- `moonforge/pubspec.yaml` (modified) - Added Drift dependencies

### Database Layer (11 files)
```
moonforge/lib/data/drift/
├── connect/
│   ├── connect.dart          # Conditional export shim
│   ├── native.dart           # Native platform connection (mobile/desktop)
│   └── web.dart              # Web WASM connection
├── converters/
│   └── string_list_converter.dart  # JSON converter for List<String>
├── tables/
│   ├── campaigns.dart              # Campaign table (@UseRowClass)
│   ├── campaign_local_metas.dart   # Local metadata (dirty flags)
│   └── outbox_ops.dart             # Outbox queue table
├── dao/
│   ├── campaigns_dao.dart          # Campaign data access
│   └── outbox_dao.dart             # Outbox data access
└── app_database.dart               # Main database class
```

### Application Layer (4 files)
```
moonforge/lib/data/
├── repo/
│   └── campaign_repository.dart    # Business logic & patch operations
├── sync/
│   └── sync_engine.dart            # Firestore ↔ Drift sync with CAS
├── examples/
│   └── campaign_list_example.dart  # Example widget
└── drift_providers.dart            # Provider wiring
```

### Configuration (2 files)
- `moonforge/build.yaml` (modified) - Build configuration for drift_dev
- `firebase/firestore.rules.drift` - Firestore security rules with CAS

## Tests (3 files)
```
moonforge/test/data/
├── drift/
│   ├── dao_test.dart        # DAO operations and streams
│   └── migration_test.dart  # Schema migrations
└── repo/
    └── campaign_repository_test.dart  # Repository patch operations
```

## Documentation (7 files)

### Root Level (4 files)
- `DRIFT_SUMMARY.md` (9.9 KB) - Complete implementation summary
- `DRIFT_QUICKREF.md` (6.8 KB) - Quick reference and commands
- `DRIFT_USAGE.md` (8.3 KB) - Full usage guide with examples
- `DRIFT_CHANGELOG.md` (5.2 KB) - Architecture decisions

### Docs Directory (2 files)
- `docs/drift_web_setup.md` (2.2 KB) - Web WASM asset setup
- `moonforge/lib/data/README.md` (3.2 KB) - Data layer overview

### This File
- `DRIFT_FILES.md` - This file listing

## Tooling (1 file)
- `scripts/drift_setup.sh` (executable) - Automated setup script

## Summary

| Category | Count | Total Size |
|----------|-------|------------|
| Production Code | 18 files | ~2,000+ LOC |
| Tests | 3 files | ~400 LOC |
| Documentation | 7 files | ~35 KB |
| Tooling | 1 file | ~3 KB |
| **TOTAL** | **29 files** | **~2,400+ LOC + 38 KB docs** |

## Generated Files (Not in Git)

These will be created by `build_runner`:
- `moonforge/lib/data/drift/app_database.g.dart`
- `moonforge/lib/data/drift/dao/campaigns_dao.g.dart`
- `moonforge/lib/data/drift/dao/outbox_dao.g.dart`

## Web Assets (Not in Git, Must Download)

Required for web platform:
- `moonforge/web/sqlite3.wasm`
- `moonforge/web/drift_worker.dart.js`

See `docs/drift_web_setup.md` for download instructions.

## File Organization

```
Moonforge/
├── moonforge/                      # Flutter app
│   ├── lib/data/                  # New data layer (15 files)
│   │   ├── drift/                 # Database infrastructure (11 files)
│   │   ├── repo/                  # Repositories (1 file)
│   │   ├── sync/                  # Sync engine (1 file)
│   │   ├── examples/              # Examples (1 file)
│   │   └── drift_providers.dart   # Provider wiring (1 file)
│   ├── test/data/                 # New tests (3 files)
│   ├── pubspec.yaml               # Modified (dependencies)
│   └── build.yaml                 # Modified (drift_dev config)
├── firebase/
│   └── firestore.rules.drift      # New security rules (1 file)
├── docs/
│   └── drift_web_setup.md         # New guide (1 file)
├── scripts/
│   └── drift_setup.sh             # New script (1 file)
├── DRIFT_SUMMARY.md               # New doc (1 file)
├── DRIFT_QUICKREF.md              # New doc (1 file)
├── DRIFT_USAGE.md                 # New doc (1 file)
├── DRIFT_CHANGELOG.md             # New doc (1 file)
└── DRIFT_FILES.md                 # This file (1 file)
```

## Quick Reference

**Generate code**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Run tests**:
```bash
flutter test test/data/
```

**Set up web**:
```bash
dart run drift_dev web
# or
../scripts/drift_setup.sh
```

**Location of key files**:
- Main database: `lib/data/drift/app_database.dart`
- Repository: `lib/data/repo/campaign_repository.dart`
- Sync engine: `lib/data/sync/sync_engine.dart`
- Providers: `lib/data/drift_providers.dart`
- Documentation: `DRIFT_*.md` (4 files in root)

---

**Created**: 2025-10-26  
**Total Files**: 29 (18 production + 3 tests + 7 docs + 1 tooling)  
**Status**: ✅ Complete and ready for integration
