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

## Instructions

### 1. Create Base Repository Interface

Define a common interface for CRUD operations:

**lib/data/repo/base_repository.dart:**

```dart
import 'package:moonforge/core/models/async_state.dart';

/// Base interface for repository operations.
///
/// All repositories should implement this interface or extend [BaseRepository].
abstract class IRepository<T, ID> {
  /// Fetch a single entity by ID
  Future<T?> getById(ID id);

  /// Fetch all entities
  Future<List<T>> getAll();

  /// Create a new entity
  Future<T> create(T entity);

  /// Update an existing entity
  Future<T> update(T entity);

  /// Delete an entity by ID
  Future<void> delete(ID id);

  /// Watch a single entity for changes (stream)
  Stream<T?> watchById(ID id);

  /// Watch all entities for changes (stream)
  Stream<List<T>> watchAll();
}

/// Base repository implementation with common functionality.
///
/// Extend this class for concrete repositories.
abstract class BaseRepository<T, ID> implements IRepository<T, ID> {
  /// Handle repository errors consistently
  Future<R> handleError<R>(
    Future<R> Function() operation, {
    String? context,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      logger.e(
        'Repository error${context != null ? " in $context" : ""}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Handle stream errors consistently
  Stream<R> handleStreamError<R>(
    Stream<R> Function() operation, {
    String? context,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      logger.e(
        'Repository stream error${context != null ? " in $context" : ""}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
```

### 2. Standardize Method Naming

Apply consistent naming across all repositories:

**Standard CRUD operations:**

- `getById(id)` - Fetch single entity
- `getAll()` - Fetch all entities
- `create(entity)` - Create new entity
- `update(entity)` - Update existing entity
- `delete(id)` - Delete entity
- `watchById(id)` - Stream single entity
- `watchAll()` - Stream all entities

**Query operations:**

- `getByField(value)` - Fetch by specific field
- `search(query)` - Search with criteria
- `paginate(page, size)` - Paginated results

**Bulk operations:**

- `createBatch(entities)` - Create multiple
- `updateBatch(entities)` - Update multiple
- `deleteBatch(ids)` - Delete multiple

### 3. Refactor Existing Repositories

Transform existing repositories to follow the pattern.

#### Before (inconsistent):

```dart
class CampaignRepository {
  final CampaignDao _dao;
  final FirebaseFirestore _firestore;

  CampaignRepository(this._dao, this._firestore);

  Future<Campaign?> getCampaignById(String id) async {
    return await _dao.getCampaignById(id);
  }

  Future<List<Campaign>> fetchCampaigns() async {
    return await _dao.getAllCampaigns();
  }

  Future<void> saveCampaign(Campaign campaign) async {
    await _dao.insertCampaign(campaign);
  }

  Stream<Campaign?> observeCampaign(String id) {
    return _dao.watchCampaign(id);
  }
}
```

#### After (consistent):

```dart
class CampaignRepository extends BaseRepository<Campaign, String> {
  final CampaignDao _dao;
  final FirebaseFirestore _firestore;

  CampaignRepository(this._dao, this._firestore);

  @override
  Future<Campaign?> getById(String id) async {
    return handleError(
      () => _dao.getCampaignById(id),
      context: 'getById',
    );
  }

  @override
  Future<List<Campaign>> getAll() async {
    return handleError(
      () => _dao.getAllCampaigns(),
      context: 'getAll',
    );
  }

  @override
  Future<Campaign> create(Campaign campaign) async {
    return handleError(
      () async {
        await _dao.insertCampaign(campaign);
        return campaign;
      },
      context: 'create',
    );
  }

  @override
  Future<Campaign> update(Campaign campaign) async {
    return handleError(
      () async {
        await _dao.updateCampaign(campaign);
        return campaign;
      },
      context: 'update',
    );
  }

  @override
  Future<void> delete(String id) async {
    return handleError(
      () => _dao.deleteCampaign(id),
      context: 'delete',
    );
  }

  @override
  Stream<Campaign?> watchById(String id) {
    return handleStreamError(
      () => _dao.watchCampaign(id),
      context: 'watchById',
    );
  }

  @override
  Stream<List<Campaign>> watchAll() {
    return handleStreamError(
      () => _dao.watchAllCampaigns(),
      context: 'watchAll',
    );
  }

  // Domain-specific methods
  Future<List<Campaign>> getByUser(String userId) async {
    return handleError(
      () => _dao.getCampaignsByUser(userId),
      context: 'getByUser',
    );
  }

  Stream<List<Campaign>> watchByUser(String userId) {
    return handleStreamError(
      () => _dao.watchCampaignsByUser(userId),
      context: 'watchByUser',
    );
  }
}
```

### 4. Add Query Builders for Complex Queries

For repositories with complex queries:

```dart
/// Query builder for campaigns
class CampaignQuery {
  String? userId;
  bool? isArchived;
  DateTime? createdAfter;
  String? searchTerm;
  int? limit;
  int? offset;

  CampaignQuery({
    this.userId,
    this.isArchived,
    this.createdAfter,
    this.searchTerm,
    this.limit,
    this.offset,
  });
}

// In repository:
Future<List<Campaign>> query(CampaignQuery query) async {
  return handleError(
    () => _dao.queryCampaigns(
      userId: query.userId,
      isArchived: query.isArchived,
      createdAfter: query.createdAfter,
      searchTerm: query.searchTerm,
      limit: query.limit,
      offset: query.offset,
    ),
    context: 'query',
  );
}
```

### 5. Implement Repository Factory

Create a factory for dependency injection:

**lib/data/repo/repository_factory.dart:**

```dart
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
// ... other imports

/// Factory for creating repository instances.
///
/// This centralizes repository creation and makes testing easier.
class RepositoryFactory {
  final AppDatabase _database;
  final FirebaseFirestore _firestore;

  // Cached repository instances
  CampaignRepository? _campaignRepository;
  EncounterRepository? _encounterRepository;
  EntityRepository? _entityRepository;
  // ... other repositories

  RepositoryFactory(this._database, this._firestore);

  CampaignRepository get campaigns {
    return _campaignRepository ??= CampaignRepository(
      _database.campaignDao,
      _firestore,
    );
  }

  EncounterRepository get encounters {
    return _encounterRepository ??= EncounterRepository(
      _database.encounterDao,
      _firestore,
    );
  }

  EntityRepository get entities {
    return _entityRepository ??= EntityRepository(
      _database.entityDao,
      _firestore,
    );
  }

  // ... other repository getters

  /// Clear cached instances (useful for testing)
  void clearCache() {
    _campaignRepository = null;
    _encounterRepository = null;
    _entityRepository = null;
    // ... clear others
  }
}
```

**Usage in providers:**

```dart
class CampaignProvider extends BaseAsyncProvider<List<Campaign>> {
  final RepositoryFactory _repos;

  CampaignProvider(this._repos);

  Future<void> loadCampaigns() async {
    await executeAsync(() => _repos.campaigns.getAll());
  }
}
```

### 6. Add Pagination Support

Standardize pagination across repositories:

**lib/data/repo/pagination.dart:**

```dart
/// Pagination parameters
class PaginationParams {
  final int page;
  final int pageSize;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 20,
  });

  int get offset => (page - 1) * pageSize;
  int get limit => pageSize;
}

/// Paginated result wrapper
class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}
```

**In repository:**

```dart
Future<PaginatedResult<Campaign>> getPaginated(
  PaginationParams params,
) async {
  return handleError(
    () async {
      final items = await _dao.getCampaignsPaginated(
        limit: params.limit,
        offset: params.offset,
      );
      final totalCount = await _dao.getCampaignsCount();

      return PaginatedResult(
        items: items,
        totalCount: totalCount,
        page: params.page,
        pageSize: params.pageSize,
      );
    },
    context: 'getPaginated',
  );
}
```

### 7. Add Caching Layer (Optional)

For frequently accessed data:

```dart
/// Simple in-memory cache for repository data
class RepositoryCache<T, ID> {
  final Duration cacheDuration;
  final Map<ID, _CacheEntry<T>> _cache = {};

  RepositoryCache({this.cacheDuration = const Duration(minutes: 5)});

  T? get(ID id) {
    final entry = _cache[id];
    if (entry == null) return null;

    if (DateTime.now().difference(entry.timestamp) > cacheDuration) {
      _cache.remove(id);
      return null;
    }

    return entry.value;
  }

  void set(ID id, T value) {
    _cache[id] = _CacheEntry(value, DateTime.now());
  }

  void clear() {
    _cache.clear();
  }

  void remove(ID id) {
    _cache.remove(id);
  }
}

class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry(this.value, this.timestamp);
}

// In repository:
class CampaignRepository extends BaseRepository<Campaign, String> {
  final _cache = RepositoryCache<Campaign, String>();

  @override
  Future<Campaign?> getById(String id) async {
    // Check cache first
    final cached = _cache.get(id);
    if (cached != null) return cached;

    // Fetch from database
    final campaign = await handleError(
      () => _dao.getCampaignById(id),
      context: 'getById',
    );

    // Cache result
    if (campaign != null) {
      _cache.set(id, campaign);
    }

    return campaign;
  }

  @override
  Future<Campaign> update(Campaign campaign) async {
    final result = await super.update(campaign);
    _cache.set(campaign.id, result); // Update cache
    return result;
  }

  @override
  Future<void> delete(String id) async {
    await super.delete(id);
    _cache.remove(id); // Invalidate cache
  }
}
```

### 8. Improve Error Types

Define specific repository error types:

**lib/data/repo/repository_errors.dart:**

```dart
/// Base class for repository errors
abstract class RepositoryError implements Exception {
  final String message;
  final Object? cause;

  RepositoryError(this.message, [this.cause]);

  @override
  String toString() => 'RepositoryError: $message${cause != null ? " (cause: $cause)" : ""}';
}

/// Entity not found error
class EntityNotFoundError extends RepositoryError {
  final String id;

  EntityNotFoundError(this.id)
      : super('Entity with ID $id not found');
}

/// Duplicate entity error
class DuplicateEntityError extends RepositoryError {
  DuplicateEntityError(String message) : super(message);
}

/// Validation error
class RepositoryValidationError extends RepositoryError {
  final Map<String, String> fieldErrors;

  RepositoryValidationError(this.fieldErrors)
      : super('Validation failed: ${fieldErrors.entries.map((e) => "${e.key}: ${e.value}").join(", ")}');
}

/// Conflict error (e.g., concurrent modification)
class ConflictError extends RepositoryError {
  ConflictError(String message) : super(message);
}
```

**Usage:**

```dart
@override
Future<Campaign?> getById(String id) async {
  return handleError(
    () async {
      final campaign = await _dao.getCampaignById(id);
      if (campaign == null) {
        throw EntityNotFoundError(id);
      }
      return campaign;
    },
    context: 'getById',
  );
}
```

### 9. Add Repository Tests

Create comprehensive tests for repositories:

**test/data/repo/campaign_repository_test.dart:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';

void main() {
  late CampaignRepository repository;
  late MockCampaignDao mockDao;

  setUp(() {
    mockDao = MockCampaignDao();
    repository = CampaignRepository(mockDao, MockFirebaseFirestore());
  });

  group('CampaignRepository', () {
    test('getById returns campaign when found', () async {
      final campaign = Campaign(id: '1', name: 'Test');
      when(mockDao.getCampaignById('1')).thenAnswer((_) async => campaign);

      final result = await repository.getById('1');

      expect(result, equals(campaign));
      verify(mockDao.getCampaignById('1')).called(1);
    });

    test('getById throws EntityNotFoundError when not found', () async {
      when(mockDao.getCampaignById('1')).thenAnswer((_) async => null);

      expect(
        () => repository.getById('1'),
        throwsA(isA<EntityNotFoundError>()),
      );
    });

    test('create inserts campaign', () async {
      final campaign = Campaign(id: '1', name: 'Test');
      when(mockDao.insertCampaign(campaign)).thenAnswer((_) async => {});

      final result = await repository.create(campaign);

      expect(result, equals(campaign));
      verify(mockDao.insertCampaign(campaign)).called(1);
    });
  });
}
```

### 10. Update All Repositories

Systematically update each repository:

1. Campaign Repository ✓
2. Encounter Repository
3. Entity Repository
4. Scene Repository
5. Session Repository
6. Chapter Repository
7. Adventure Repository
8. Party Repository
9. Player Repository
10. Media Asset Repository
11. Combatant Repository

## Safety & Verification

### Potential Pitfalls

1. **Breaking existing code**: Services and providers depend on repositories
2. **Stream handling**: Ensure streams are properly disposed
3. **Cache invalidation**: Cache must be cleared on updates/deletes
4. **Error propagation**: Don't swallow errors

### Verification Checklist

- [ ] All repositories extend BaseRepository
- [ ] Method names follow conventions
- [ ] Error handling is consistent
- [ ] Tests are updated
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] No behavior changes observed

### Testing Strategy

1. **Unit tests**: Test each repository method
2. **Integration tests**: Test repository with real database
3. **Mock tests**: Test with mocked DAOs

## Git Workflow Tip

**Commit strategy**:

```bash
git commit -m "refactor: create base repository classes"
git commit -m "refactor: add repository error types"
git commit -m "refactor: update campaign repository"
git commit -m "refactor: update encounter repository"
git commit -m "refactor: add repository factory"
```

## Impact Assessment

**Risk level**: Medium  
**Files affected**: 10-15 repositories, 30+ services/providers  
**Breaking changes**: None (internal refactor)  
**Migration needed**: Update service layer to use new repository methods

## Next Step

Once this step is complete and merged, proceed to [Step 7: Service Layer Consolidation](step-7.md).
