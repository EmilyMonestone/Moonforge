# Navigation Enhancements Plan

1. **Normalize chapter/adventure/scene navigation controls**
    - Move chapter navigation controls to the bottom of the chapter detail column (after other sections) and ensure labels reflect chapter order.
    - Ensure adventure detail view renders back/forward controls at the bottom (already started; verify placement and async handling).
    - Add a bottom navigation footer to scene detail pages, mirroring the existing header controls, so users can move between scenes without scrolling.

2. **Fix sidebar/auth button overflow**
    - When the navigation rail is collapsed, constrain `AuthUserButton` to an icon-only chip (or hide the text) and adjust padding so the account button never clips.
    - Verify expanded mode still shows the full button label.

3. **Display adventure order numbers everywhere**
    - Audit `ChapterView`, `AdventureListView`, and any other adventure listings to ensure the visible titles include their order number (fallback to index+1 if null).

4. **Campaign Quill loading regression**
    - Update the campaign view/edit controllers so the Quill editor always loads from `campaign.content['ops']` when present, falling back to summary/description only when content
      is empty.
    - Add regression widget tests that create a fake campaign with rich-text delta and assert the editor preloads it when entering edit mode twice.

5. **Validation**
    - Run `flutter analyze` and the affected widget/tests (at least the new regression test file) to ensure everything passes.

