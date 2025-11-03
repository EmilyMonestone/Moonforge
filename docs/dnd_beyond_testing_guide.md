# Testing Guide for D&D Beyond Character Import

This guide provides detailed testing instructions for the D&D Beyond character import feature.

## Pre-Test Setup

### 1. Code Generation
First, regenerate the Drift database code:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

Expected output: New `.g.dart` files should be generated without errors.

### 2. Build the Application

```bash
cd moonforge
flutter pub get
flutter run
```

## Test Cases

### Test 1: Import with Numeric ID

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Enter a numeric character ID: `152320860`
4. Click "Import"

**Expected Result:**
- Loading indicator appears
- Character is imported successfully
- Success notification shows
- App navigates to the new entity
- Entity has:
  - Correct character name
  - Ability scores (STR, DEX, CON, INT, WIS, CHA)
  - HP values
  - AC (Armor Class)
  - Speed
  - Class and level information
  - Race

### Test 2: Import with Full URL

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Enter full URL: `https://www.dndbeyond.com/characters/152320860`
4. Click "Import"

**Expected Result:**
- Same as Test 1
- Character is imported successfully
- All data is present

### Test 3: Import with Partial URL

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Enter partial URL: `dndbeyond.com/characters/152320860`
4. Click "Import"

**Expected Result:**
- Character is imported successfully (ID extracted correctly)

### Test 4: Invalid Numeric ID

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Enter an invalid ID: `999999999999`
4. Click "Import"

**Expected Result:**
- Loading indicator appears briefly
- Error notification shows
- Message indicates character not found or failed to import
- User remains in import dialog

### Test 5: Invalid URL Format

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Enter invalid text: `not-a-valid-url`
4. Click "Import"

**Expected Result:**
- Error notification shows
- Message indicates invalid ID/URL format

### Test 6: Empty Input

**Steps:**
1. Navigate to a campaign
2. Trigger the import function
3. Leave input field empty
4. Click "Import"

**Expected Result:**
- Dialog closes without action
- No error message (handled gracefully)

### Test 7: Network Error Simulation

**Steps:**
1. Disable network connection
2. Navigate to a campaign
3. Trigger the import function
4. Enter a valid ID
5. Click "Import"

**Expected Result:**
- Loading indicator appears
- Error notification shows after timeout
- Message indicates network error or failure to fetch

### Test 8: Duplicate Import

**Steps:**
1. Import a character successfully (use ID: `152320860`)
2. Note the character name and entity ID
3. Import the same character again using the same ID
4. Click "Import"

**Expected Result:**
- Existing character is updated (not duplicated)
- Character data is refreshed
- Same entity ID is returned

### Test 9: Update Existing Character

**Steps:**
1. Import a character
2. Make changes to the character on D&D Beyond (if you have access)
3. Use the update function with the entity's ID
4. Verify changes are reflected

**Expected Result:**
- Character data is updated
- Success notification shows
- Changes from D&D Beyond are reflected

### Test 10: Multiple Ability Scores

**Steps:**
1. Import a character
2. Check the entity's statblock
3. Verify all ability scores are present:
   - strength
   - dexterity
   - constitution
   - intelligence
   - wisdom
   - charisma

**Expected Result:**
- All 6 ability scores are present
- Each has both value and modifier
- Modifiers are calculated correctly: `(score - 10) / 2` (rounded down)

## Data Validation Tests

### Ability Score Modifiers

Check that modifiers are calculated correctly:
- Score 8 → Modifier -1
- Score 10 → Modifier 0
- Score 12 → Modifier +1
- Score 14 → Modifier +2
- Score 16 → Modifier +3
- Score 18 → Modifier +4
- Score 20 → Modifier +5

### Hit Points

Verify HP calculations:
- `hp_max` should be `baseHitPoints + bonusHitPoints`
- `hp` should be `hp_max - removedHitPoints`
- `temp_hp` should be present if character has temporary HP

### Class and Level

For multiclass characters:
- All classes should be listed
- Each class should have correct level
- Total level should match sum of all class levels

## Edge Cases

### Test 11: Multiclass Character

Find and import a multiclass character (e.g., Fighter 3 / Wizard 2)

**Expected Result:**
- All classes are listed in statblock
- Levels are correct for each class

### Test 12: High-Level Character

Import a high-level character (level 15+)

**Expected Result:**
- All stats are correctly imported
- No overflow or calculation errors

### Test 13: Character with Unusual Race

Import a character with a non-standard race

**Expected Result:**
- Race name is imported correctly
- Race-specific stats are calculated

## Regression Tests

### Test 14: Create Regular Entity

**Steps:**
1. Create a new entity normally (not via import)
2. Verify all fields work correctly
3. Verify the new `dndBeyondCharacterId` field is null

**Expected Result:**
- Entity creation works as before
- No errors related to new field

### Test 15: Edit Existing Entity

**Steps:**
1. Open an existing entity (created before this feature)
2. Edit and save
3. Verify no errors occur

**Expected Result:**
- Entity editing works as before
- Migration has applied correctly

## Performance Tests

### Test 16: Import Speed

**Steps:**
1. Import a character
2. Measure time from click to completion

**Expected Result:**
- Import completes in < 5 seconds on good network
- UI remains responsive during import

### Test 17: Concurrent Imports

**Steps:**
1. Start importing a character
2. While first is loading, trigger another import

**Expected Result:**
- Both imports complete successfully
- No race conditions or data corruption

## Database Tests

### Test 18: Database Migration

**Steps:**
1. Install old version (before this feature)
2. Create some entities
3. Update to new version
4. Launch app

**Expected Result:**
- App launches successfully
- Migration runs automatically
- Old entities still work
- New field is available for new imports

### Test 19: Persistence

**Steps:**
1. Import a character
2. Close and reopen the app
3. Navigate to the imported character

**Expected Result:**
- Character data is persisted
- All fields remain correct
- D&D Beyond ID is stored

## Error Recovery

### Test 20: Partial Data Import

**Steps:**
1. Import a character with incomplete data on D&D Beyond
2. Verify error handling

**Expected Result:**
- Import handles missing fields gracefully
- Available data is imported
- No crash or exception

## Test Data

### Public Test Characters

Use these public D&D Beyond characters for testing:
- `152320860` - Example character
- (Add more public character IDs here)

### Creating Test Characters

To create your own test characters:
1. Go to https://www.dndbeyond.com
2. Create a character
3. Make it public in character settings
4. Use the character ID for testing

## Reporting Issues

When reporting issues, include:
- Test case number
- Steps to reproduce
- Expected vs actual result
- Character ID used
- Error messages or logs
- Screenshots if relevant

## Test Checklist

Use this checklist when testing:

- [ ] Test 1: Import with numeric ID
- [ ] Test 2: Import with full URL
- [ ] Test 3: Import with partial URL
- [ ] Test 4: Invalid numeric ID
- [ ] Test 5: Invalid URL format
- [ ] Test 6: Empty input
- [ ] Test 7: Network error
- [ ] Test 8: Duplicate import
- [ ] Test 9: Update existing character
- [ ] Test 10: Ability scores validation
- [ ] Test 11: Multiclass character
- [ ] Test 12: High-level character
- [ ] Test 13: Unusual race
- [ ] Test 14: Create regular entity
- [ ] Test 15: Edit existing entity
- [ ] Test 16: Import speed
- [ ] Test 17: Concurrent imports
- [ ] Test 18: Database migration
- [ ] Test 19: Persistence
- [ ] Test 20: Partial data import
