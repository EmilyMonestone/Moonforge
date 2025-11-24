# Step 6: Repository Pattern Consistency

**Priority**: Medium  
**Effort**: M (3-5 days)  
**Branch**: `refactor/06-repository-pattern`

## Goal

Standardize how data is accessed across the application by ensuring all repositories follow a consistent pattern. This improves code predictability, makes testing easier, and
provides a clear separation between business logic and data access.

By the end of this step:

- All repositories implement a common interface pattern
- Data access methods follow naming conventions
- Error handling is consistent across repositories
- Mock repositories can be easily created for testing

## Scope

**What's included:**

- All repository classes in `lib/data/repo/`
- Data access patterns
- Repository interfaces
- Error handling in repositories

**What's excluded:**

- DAOs and database tables (Drift-specific)
- Service layer (covered in Step 7)
- Firebase/Firestore direct access (use repositories)

**Types of changes allowed:**

- Creating base repository classes
- Standardizing method signatures
- Adding repository interfaces
- Improving error handling

---

## Progress update (current workspace)

I implemented the majority of Step 6 in the codebase and added tests to validate repository construction and basic CRUD behavior.

Completed items (implemented in this branch/workspace):

- Base repository/interface
    - `lib/data/repo/base_repository.dart` — `IRepository` + `BaseRepository` with `handleError` / `handleStreamError` utilities.
- Repository errors & caching
    - `lib/data/repo/repository_errors.dart` — typed repository exceptions (EntityNotFoundError, Validation, Conflict, ...).
    - `lib/data/repo/repository_cache.dart` — small in-memory cache used by repositories.
- Pagination helpers
    - `lib/data/repo/pagination.dart` — `PaginationParams` and `PaginatedResult`.
- RepositoryFactory
    - `lib/data/repo/repository_factory.dart` — centralized construction of repositories.
    - `lib/data/db_providers.dart` — wired to provide `RepositoryFactory` and constructed repositories via factory.
- Repositories refactored to follow the BaseRepository pattern (error handling + watch/get naming):
    - `lib/data/repo/campaign_repository.dart`
    - `lib/data/repo/chapter_repository.dart`
    - `lib/data/repo/adventure_repository.dart`
    - `lib/data/repo/scene_repository.dart`
    - `lib/data/repo/encounter_repository.dart`
    - `lib/data/repo/entity_repository.dart`
    - `lib/data/repo/party_repository.dart`
    - `lib/data/repo/player_repository.dart`
    - `lib/data/repo/session_repository.dart`
    - `lib/data/repo/media_asset_repository.dart`
    - `lib/data/repo/combatant_repository.dart`
- Tests added
    - `test/data/repository_factory_test.dart` — verifies factory constructs repos.
    - `test/data/repo/campaign_repository_test.dart` — integration-style CRUD test using in-memory DB.
    - `test/data/repo/adventure_repository_test.dart` — integration-style CRUD test using in-memory DB (chapter/campaign setup included to satisfy FK constraints).
    - Several small debug tests created during the work to validate parser behavior.

Notes about verification runs so far:

- `flutter analyze` completed with only informational lints (no blocking type errors introduced by the refactor edits).
- New factory test passed (in-memory DB).
- Some existing tests in the repo were failing before this change in the environment (e.g., SafeDataParser expectation, and tests that require platform plugins). I improved the
  SafeDataParser parsing robustness and adjusted a db unit test to use an in-memory DB to avoid plugin issues in tests.
- Integration tests for repositories were added and exercised; I adjusted the tests to satisfy foreign key constraints and companion `Value` typing.

---

## What's left to finish in Step 6

- [ ] Systematically add small unit tests for each repository (happy-path + error case) — iterate repository-by-repository.
- [ ] Replace any remaining direct Firestore usage in services with repository calls (this is a low-risk scan & replace).
- [ ] Finalize the step verification checklist (run full `flutter test` in CI-friendly environment; fix any environment-specific test harness issues such as missing plugin mocks).

---

## Verification checklist (current status)

- [x] All repositories extend `BaseRepository` (or implement `IRepository`)
- [x] Method names follow conventions (getById/getAll/create/update/delete/watchById/watchAll)
- [x] Error handling standardized via `handleError` / `handleStreamError`
- [x] RepositoryFactory implemented and wired into DI providers
- [x] Pagination helpers added
- [x] Simple caching helper added
- [x] Basic repository tests added (factory + campaign + adventure smoke tests)
- [ ] `flutter analyze` passes with zero errors (INFO/warnings remain; no blocking errors)
- [ ] `flutter test` passes completely in a CI-like environment (two pre-existing tests required environment helpers; see notes)

---

## Next actions I will take (pick-up tasks for finishing Step 6)

1. Add targeted unit tests for the other repositories (Entity, Party, Player, MediaAsset, Combatant, Scene, Encounter, Session) using `NativeDatabase.memory()` to keep them fast
   and isolated.
2. Add `lib/data/repo/README.md` documenting the RepositoryFactory usage and how to mock repositories in tests.
3. Run `flutter test` across the codebase and address any failing tests (focus on environment/plugin mocks and parser expectations). Fixes should be minimal and safe.
4. Once tests are green, prepare a concise PR with commits grouped by file/type (base repo, errors/cache, factory, per-repository refactors, tests).

If you want I can continue now with step 1 above (create the remaining repository unit tests and run them). This will make the Step 6 coverage comprehensive and bring us much
closer to marking the step complete.

---

## Safety & rollbacks

Follow the repo's usual branch/commit guidelines. Each set of repository changes was made incrementally so the refactor can be reviewed and reverted in small chunks if necessary.

---

(End of progress update)
