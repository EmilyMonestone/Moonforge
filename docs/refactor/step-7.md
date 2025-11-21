# Step 7: Service Layer Consolidation

**Priority**: Medium  
**Effort**: M (3-5 days)  
**Branch**: `refactor/07-service-consolidation`

## Goal

Consolidate and standardize the service layer to eliminate duplication, clarify responsibilities, and ensure consistent business logic patterns across features. Services should focus purely on business logic without direct UI concerns.

By the end of this step:
- Clear separation between services and controllers/providers
- Reduced service duplication
- Standardized service interfaces
- Better testability of business logic

## Scope

**What's included:**
- All service classes in `lib/features/*/services/` and `lib/core/services/`
- Business logic consolidation
- Service interfaces and contracts

**What's excluded:**
- UI controllers/providers (use services, don't duplicate logic)
- Repositories (covered in Step 6)
- Utilities (pure functions without state)

## Instructions

### 1. Audit Service Duplication

```bash
# Find similar service patterns
cd moonforge/lib/features
for dir in */services/; do
  echo "=== $dir ==="
  ls "$dir"
done
```

Look for:
- Similar validation logic across features
- Duplicated calculation methods
- Repeated API call patterns

### 2. Create Service Base Classes

**lib/core/services/base_service.dart:**
```dart
import 'package:moonforge/core/utils/logger.dart';

/// Base class for all service classes.
///
/// Provides common functionality like logging and error handling.
abstract class BaseService {
  /// Service name for logging
  String get serviceName;

  /// Log info message
  @protected
  void logInfo(String message) {
    logger.i('[$serviceName] $message');
  }

  /// Log error
  @protected
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.e('[$serviceName] $message', error: error, stackTrace: stackTrace);
  }

  /// Execute operation with error handling
  @protected
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      logInfo('${operationName ?? "Operation"} started');
      final result = await operation();
      logInfo('${operationName ?? "Operation"} completed');
      return result;
    } catch (error, stackTrace) {
      logError('${operationName ?? "Operation"} failed', error, stackTrace);
      rethrow;
    }
  }
}
```

### 3. Extract Common Validation Services

**lib/core/services/validation_service.dart:**
```dart
/// Common validation rules used across features
class ValidationService {
  /// Validate non-empty string
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validate number range
  static String? validateNumberRange(
    num? value,
    num min,
    num max,
    String fieldName,
  ) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }
}
```

### 4. Consolidate Feature Services

Identify and merge duplicate services:

**Before** (duplicated validation):
```dart
// In campaign_service.dart
class CampaignService {
  String? validateCampaignName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (name.length < 3) return 'Name must be at least 3 characters';
    return null;
  }
}

// In encounter_service.dart
class EncounterService {
  String? validateEncounterName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (name.length < 3) return 'Name must be at least 3 characters';
    return null;
  }
}
```

**After** (consolidated):
```dart
// Both use ValidationService
ValidationService.validateRequired(name, 'Name');
ValidationService.validateMinLength(name, 3, 'Name');
```

### 5. Standardize Service Methods

Apply consistent patterns:

```dart
class CampaignService extends BaseService {
  final CampaignRepository _repository;

  @override
  String get serviceName => 'CampaignService';

  CampaignService(this._repository);

  // Query methods: get*, find*, search*
  Future<Campaign?> getCampaignById(String id) async {
    return execute(
      () => _repository.getById(id),
      operationName: 'getCampaignById',
    );
  }

  Future<List<Campaign>> searchCampaigns(String query) async {
    return execute(
      () => _repository.search(query),
      operationName: 'searchCampaigns',
    );
  }

  // Command methods: create*, update*, delete*, archive*
  Future<Campaign> createCampaign(Campaign campaign) async {
    return execute(
      () async {
        // Validation
        _validateCampaign(campaign);
        
        // Business logic
        final now = DateTime.now();
        final enriched = campaign.copyWith(
          createdAt: now,
          updatedAt: now,
        );

        // Persist
        return _repository.create(enriched);
      },
      operationName: 'createCampaign',
    );
  }

  Future<Campaign> updateCampaign(Campaign campaign) async {
    return execute(
      () async {
        _validateCampaign(campaign);
        final updated = campaign.copyWith(updatedAt: DateTime.now());
        return _repository.update(updated);
      },
      operationName: 'updateCampaign',
    );
  }

  Future<void> deleteCampaign(String id) async {
    return execute(
      () => _repository.delete(id),
      operationName: 'deleteCampaign',
    );
  }

  // Business logic methods
  Future<bool> canUserEditCampaign(String campaignId, String userId) async {
    final campaign = await getCampaignById(campaignId);
    return campaign?.ownerId == userId;
  }

  // Private validation
  void _validateCampaign(Campaign campaign) {
    final nameError = ValidationService.validateRequired(campaign.name, 'Name');
    if (nameError != null) {
      throw ValidationError(nameError);
    }

    final lengthError = ValidationService.validateMinLength(campaign.name, 3, 'Name');
    if (lengthError != null) {
      throw ValidationError(lengthError);
    }
  }
}
```

### 6. Extract Calculation Services

For complex calculations used across features:

**lib/core/services/calculation_service.dart:**
```dart
/// Common calculation utilities
class CalculationService {
  /// Calculate percentage
  static double percentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate average
  static double average(List<num> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Round to decimals
  static double roundTo(double value, int decimals) {
    final mod = pow(10.0, decimals);
    return ((value * mod).round().toDouble() / mod);
  }
}
```

### 7. Remove Service-Controller Duplication

**Before** (logic in controller):
```dart
class CampaignProvider extends ChangeNotifier {
  Future<void> createCampaign(String name, String description) async {
    // Validation logic in provider ❌
    if (name.isEmpty) {
      _error = 'Name is required';
      return;
    }

    // Business logic in provider ❌
    final campaign = Campaign(
      id: uuid.v4(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
    );

    await _repository.create(campaign);
  }
}
```

**After** (logic in service):
```dart
// Service handles all business logic
class CampaignService extends BaseService {
  Future<Campaign> createCampaign({
    required String name,
    String? description,
  }) async {
    return execute(() async {
      // Validation
      final nameError = ValidationService.validateRequired(name, 'Name');
      if (nameError != null) throw ValidationError(nameError);

      // Business logic
      final campaign = Campaign(
        id: uuid.v4(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return _repository.create(campaign);
    });
  }
}

// Provider only manages state
class CampaignProvider extends BaseAsyncProvider<List<Campaign>> {
  final CampaignService _service;

  Future<void> createCampaign(String name, String description) async {
    try {
      await _service.createCampaign(name: name, description: description);
      await loadCampaigns(); // Refresh list
    } catch (error) {
      // Handle error
      rethrow;
    }
  }
}
```

### 8. Document Service Responsibilities

Add clear documentation:

```dart
/// Manages campaign business logic.
///
/// Responsibilities:
/// - Campaign CRUD operations with validation
/// - Campaign archiving and restoration
/// - Campaign sharing and permissions
/// - Campaign statistics and calculations
///
/// Does NOT handle:
/// - UI state (use CampaignProvider)
/// - Data persistence (use CampaignRepository)
/// - Navigation (handled by UI layer)
class CampaignService extends BaseService {
  // ...
}
```

## Safety & Verification

### Verification Checklist

- [ ] All services extend BaseService or have clear structure
- [ ] Business logic moved from controllers to services
- [ ] Validation logic consolidated
- [ ] Services are well-documented
- [ ] Tests updated
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes

## Git Workflow Tip

**Branch naming**: `refactor/07-service-consolidation`

## Impact Assessment

**Risk level**: Medium  
**Files affected**: 20-30 services, 10-20 controllers  
**Breaking changes**: None  
**Migration needed**: Update controllers to use services

## Next Step

Proceed to [Step 8: Widget Tree Simplification](step-8.md).
