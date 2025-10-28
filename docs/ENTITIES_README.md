# Entities Feature - Quick Start

This PR adds a reusable entities widget to display related entities on Campaign, Chapter, Adventure, Scene, and Encounter pages.

## Before Running the App

You **must** run code generation before the app will compile:

```bash
cd moonforge
./scripts/generate_code.sh
```

Or manually:

```bash
cd moonforge
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This generates the necessary `.freezed.dart` and `.g.dart` files for Firestore ODM and Drift local database.

## What's New

### Model Changes

All these models now have an `entityIds` field to store related entities:
- Campaign
- Chapter
- Adventure
- Scene
- Encounter

**Firestore ODM**: Updated freezed models  
**Drift (Local Sync)**: Added `entityIds` column to all content tables with automatic migration from schema v2 to v3

### New Widget

The `EntitiesWidget` displays entities in three grouped tables:
1. NPCs, Monsters & Groups
2. Places
3. Items & Others

Entities from child parts show an origin badge (e.g., "Scene 1.3.2").

### Screen Integration

The entities widget appears on:
- Campaign screen (all entities in campaign)
- Chapter screen (entities from chapter + adventures + scenes)
- Adventure screen (entities from adventure + scenes)
- Scene screen (entities from scene)
- Encounter screen (entities from encounter)

## Documentation

See `docs/entities_feature.md` for complete documentation.

## Testing

After generating code, you can:
1. Run the app: `flutter run`
2. Navigate to a campaign/chapter/adventure/scene/encounter
3. The entities widget will appear at the bottom of the page

To add entities to a part, you'll need to update the `entityIds` field in the Firestore database or through the app's entity management UI (if available).
