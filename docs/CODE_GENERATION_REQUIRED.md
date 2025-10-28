# Code Generation Required Before Testing

Before the encounter builder UI can be tested, you need to generate the Freezed boilerplate code for the Combatant model.

## Steps

1. Install dependencies (if not already done):
```bash
cd moonforge
flutter pub get
```

2. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/features/encounters/models/combatant.freezed.dart`
- `lib/features/encounters/models/combatant.g.dart`

## Expected Output

You should see output like:
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 1.2s

[INFO] Creating build script snapshot......
[INFO] Creating build script snapshot... completed, took 3.5s

[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 2.1s

[INFO] Checking for unexpected pre-existing outputs....
[INFO] Checking for unexpected pre-existing outputs. completed, took 0.2s

[INFO] Running build...
[INFO] 1.2s elapsed, 0/3 actions completed.
[INFO] 2.5s elapsed, 1/3 actions completed.
[INFO] 3.7s elapsed, 2/3 actions completed.
[INFO] Running build completed, took 4.1s

[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 0.3s

[INFO] Succeeded after 4.4s with 2 outputs
```

## Verifying

After generation, verify the files exist:
```bash
ls -la lib/features/encounters/models/combatant.*.dart
```

You should see:
- `combatant.dart` (already exists)
- `combatant.freezed.dart` (generated)
- `combatant.g.dart` (generated)

## Testing the UI

Once generated, you can test the encounter builder:

1. Run the app:
```bash
flutter run
```

2. Navigate to a campaign
3. Click "Create Encounter" from the menu
4. You should see:
   - Party selection with custom player group editor
   - Live difficulty calculation display
   - Monster browser with Bestiary and Campaign tabs
   - Real-time XP threshold updates

## Troubleshooting

If code generation fails:

1. Clean the build:
```bash
flutter clean
flutter pub get
```

2. Try again:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. If still failing, check:
   - All dependencies in pubspec.yaml are correct
   - No syntax errors in combatant.dart
   - build_runner version is compatible with Dart SDK

## Implementation Details

The encounter builder now includes:

### Party Selection
- **Custom Player Group**: Add/remove players with level selection (1-20)
- **Existing Party**: Dropdown to select from campaign parties (partially implemented)
- **Real-time Calculation**: XP thresholds update as you change party composition

### Monster Browser
- **Bestiary Tab**: Browse all D&D 5e monsters from BestiaryProvider
- **Campaign Tab**: Select monsters/NPCs from your campaign entities (with statblocks)
- **One-Click Add**: Click the + button to add a creature to the encounter
- **Stats Display**: Shows CR, XP, HP, and AC for each creature

### Live Difficulty Display
- **Four Thresholds**: Color-coded chips showing Easy (green), Medium (yellow), Hard (orange), Deadly (red)
- **Adjusted XP**: Real-time calculation including encounter multipliers
- **Difficulty Classification**: Large card showing overall difficulty (Trivial to Deadly)
- **Auto-Update**: Recalculates when you add/remove combatants or change party

### Combatant List
- **Visual Cards**: Each combatant shown with icon (shield for allies, danger for enemies)
- **Stats**: CR, XP, HP, AC displayed
- **Remove Button**: Click trash icon to remove from encounter
- **Real-time Updates**: Difficulty recalculates automatically

## Next Steps

After code generation and testing, the following features can be implemented:
1. Load actual party data (fetch players from party)
2. Save encounters to database
3. Inline combatant editing
4. Initiative tracker UI
