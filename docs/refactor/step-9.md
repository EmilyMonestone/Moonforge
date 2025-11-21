# Step 9: Testing Infrastructure Enhancement

**Priority**: Medium  
**Effort**: L (6-10 days)  
**Branch**: `refactor/09-testing-infrastructure`

## Goal

Strengthen the testing infrastructure by adding missing tests, improving test coverage, and establishing testing patterns that make the codebase more maintainable and reliable.

By the end of this step:
- Core business logic has unit test coverage
- Complex widgets have widget tests
- Testing patterns are documented and consistent
- CI/CD can run tests automatically

## Scope

**What's included:**
- Unit tests for services, repositories, and utilities
- Widget tests for complex UI components
- Test utilities and helpers
- Mock and fixture setup

**What's excluded:**
- Integration tests (can be added later)
- End-to-end tests
- Performance tests

## Instructions

### 1. Set Up Test Infrastructure

**test/test_helpers.dart:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';

// Generate mocks
@GenerateMocks([
  CampaignRepository,
  CampaignService,
  // Add other classes to mock
])
void main() {}

/// Pump a widget with MaterialApp wrapper
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget widget,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: widget),
    ),
  );
}

/// Create a test campaign
Campaign createTestCampaign({
  String id = '1',
  String name = 'Test Campaign',
  String? description,
}) {
  return Campaign(
    id: id,
    name: name,
    description: description,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );
}
```

Generate mocks:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Add Unit Tests for Services

**test/features/campaign/services/campaign_service_test.dart:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import '../../../test_helpers.mocks.dart';

void main() {
  late CampaignService service;
  late MockCampaignRepository mockRepository;

  setUp(() {
    mockRepository = MockCampaignRepository();
    service = CampaignService(mockRepository);
  });

  group('CampaignService', () {
    group('getCampaignById', () {
      test('returns campaign when found', () async {
        final campaign = createTestCampaign();
        when(mockRepository.getById('1'))
            .thenAnswer((_) async => campaign);

        final result = await service.getCampaignById('1');

        expect(result, equals(campaign));
        verify(mockRepository.getById('1')).called(1);
      });

      test('returns null when not found', () async {
        when(mockRepository.getById('999'))
            .thenAnswer((_) async => null);

        final result = await service.getCampaignById('999');

        expect(result, isNull);
      });
    });

    group('createCampaign', () {
      test('creates campaign with valid data', () async {
        final campaign = createTestCampaign();
        when(mockRepository.create(any))
            .thenAnswer((_) async => campaign);

        final result = await service.createCampaign(
          name: 'New Campaign',
          description: 'Description',
        );

        expect(result.name, equals('New Campaign'));
        verify(mockRepository.create(any)).called(1);
      });

      test('throws ValidationError with empty name', () async {
        expect(
          () => service.createCampaign(name: '', description: 'Desc'),
          throwsA(isA<ValidationError>()),
        );

        verifyNever(mockRepository.create(any));
      });

      test('throws ValidationError with short name', () async {
        expect(
          () => service.createCampaign(name: 'ab', description: 'Desc'),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('updateCampaign', () {
      test('updates campaign successfully', () async {
        final campaign = createTestCampaign();
        final updated = campaign.copyWith(name: 'Updated');
        
        when(mockRepository.update(any))
            .thenAnswer((_) async => updated);

        final result = await service.updateCampaign(updated);

        expect(result.name, equals('Updated'));
        verify(mockRepository.update(any)).called(1);
      });
    });

    group('deleteCampaign', () {
      test('deletes campaign by id', () async {
        when(mockRepository.delete('1'))
            .thenAnswer((_) async => null);

        await service.deleteCampaign('1');

        verify(mockRepository.delete('1')).called(1);
      });
    });
  });
}
```

### 3. Add Unit Tests for Providers

**test/features/campaign/controllers/campaign_provider_test.dart:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import '../../../test_helpers.mocks.dart';

void main() {
  late CampaignProvider provider;
  late MockCampaignService mockService;

  setUp(() {
    mockService = MockCampaignService();
    provider = CampaignProvider(mockService);
  });

  group('CampaignProvider', () {
    test('initial state is idle', () {
      expect(provider.state.isIdle, true);
    });

    test('loadCampaigns sets loading then data state', () async {
      final campaigns = [
        createTestCampaign(id: '1'),
        createTestCampaign(id: '2'),
      ];

      when(mockService.getAllCampaigns())
          .thenAnswer((_) async => campaigns);

      // Start loading
      final loadFuture = provider.loadCampaigns();
      expect(provider.state.isLoading, true);

      // Wait for completion
      await loadFuture;
      expect(provider.state.hasData, true);
      expect(provider.campaigns, hasLength(2));
    });

    test('loadCampaigns sets error state on failure', () async {
      final error = Exception('Network error');
      when(mockService.getAllCampaigns())
          .thenThrow(error);

      await provider.loadCampaigns();

      expect(provider.state.hasError, true);
      expect(provider.state.errorOrNull, equals(error));
    });

    test('createCampaign adds campaign and reloads', () async {
      final newCampaign = createTestCampaign();
      
      when(mockService.createCampaign(
        name: 'Test',
        description: 'Desc',
      )).thenAnswer((_) async => newCampaign);

      when(mockService.getAllCampaigns())
          .thenAnswer((_) async => [newCampaign]);

      await provider.createCampaign('Test', 'Desc');

      expect(provider.campaigns, hasLength(1));
      verify(mockService.createCampaign(
        name: 'Test',
        description: 'Desc',
      )).called(1);
    });
  });
}
```

### 4. Add Widget Tests

**test/features/campaign/widgets/campaign_card_test.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';
import '../../../test_helpers.dart';

void main() {
  group('CampaignCard', () {
    testWidgets('displays campaign name and description', (tester) async {
      final campaign = createTestCampaign(
        name: 'Test Campaign',
        description: 'Test Description',
      );

      await pumpTestWidget(
        tester,
        CampaignCard(campaign: campaign),
      );

      expect(find.text('Test Campaign'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('displays campaign stats', (tester) async {
      final campaign = createTestCampaign(
        chapterCount: 5,
        sessionCount: 10,
      );

      await pumpTestWidget(
        tester,
        CampaignCard(campaign: campaign),
      );

      expect(find.text('5'), findsOneWidget); // Chapters
      expect(find.text('10'), findsOneWidget); // Sessions
    });

    testWidgets('calls onTap when tapped', (tester) async {
      final campaign = createTestCampaign();
      var tapped = false;

      await pumpTestWidget(
        tester,
        CampaignCard(
          campaign: campaign,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(CampaignCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('handles empty description', (tester) async {
      final campaign = createTestCampaign(description: null);

      await pumpTestWidget(
        tester,
        CampaignCard(campaign: campaign),
      );

      expect(find.text('Test Campaign'), findsOneWidget);
      expect(find.text('No description'), findsNothing);
    });
  });
}
```

### 5. Add Tests for Utilities

**test/core/utils/validation_service_test.dart:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/validation_service.dart';

void main() {
  group('ValidationService', () {
    group('validateRequired', () {
      test('returns null for valid value', () {
        final result = ValidationService.validateRequired('test', 'Field');
        expect(result, isNull);
      });

      test('returns error for null value', () {
        final result = ValidationService.validateRequired(null, 'Field');
        expect(result, equals('Field is required'));
      });

      test('returns error for empty string', () {
        final result = ValidationService.validateRequired('', 'Field');
        expect(result, equals('Field is required'));
      });

      test('returns error for whitespace only', () {
        final result = ValidationService.validateRequired('   ', 'Field');
        expect(result, equals('Field is required'));
      });
    });

    group('validateMinLength', () {
      test('returns null when length is sufficient', () {
        final result = ValidationService.validateMinLength('hello', 3, 'Field');
        expect(result, isNull);
      });

      test('returns error when length is insufficient', () {
        final result = ValidationService.validateMinLength('hi', 3, 'Field');
        expect(result, equals('Field must be at least 3 characters'));
      });
    });

    group('validateEmail', () {
      test('returns null for valid email', () {
        final result = ValidationService.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('returns error for invalid email', () {
        final result = ValidationService.validateEmail('invalid-email');
        expect(result, equals('Invalid email format'));
      });

      test('returns error for empty email', () {
        final result = ValidationService.validateEmail('');
        expect(result, equals('Email is required'));
      });
    });

    group('validateNumberRange', () {
      test('returns null for valid number', () {
        final result = ValidationService.validateNumberRange(5, 1, 10, 'Field');
        expect(result, isNull);
      });

      test('returns error for number below min', () {
        final result = ValidationService.validateNumberRange(0, 1, 10, 'Field');
        expect(result, equals('Field must be between 1 and 10'));
      });

      test('returns error for number above max', () {
        final result = ValidationService.validateNumberRange(11, 1, 10, 'Field');
        expect(result, equals('Field must be between 1 and 10'));
      });
    });
  });
}
```

### 6. Add Integration Helpers (Optional)

**test/integration_helpers.dart:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Create an in-memory test database
Future<AppDatabase> createTestDatabase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Create in-memory database
  final db = AppDatabase.inMemory();
  return db;
}

/// Clean up test database
Future<void> cleanupTestDatabase(AppDatabase db) async {
  await db.close();
}
```

### 7. Document Testing Patterns

**test/README.md:**
```markdown
# Testing Guide

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/campaign/services/campaign_service_test.dart

# Run with coverage
flutter test --coverage
```

## Test Structure

```
test/
├── test_helpers.dart           # Shared test utilities
├── integration_helpers.dart    # Integration test helpers
├── features/
│   └── campaign/
│       ├── services/
│       │   └── campaign_service_test.dart
│       ├── controllers/
│       │   └── campaign_provider_test.dart
│       └── widgets/
│           └── campaign_card_test.dart
└── core/
    ├── utils/
    └── services/
```

## Testing Patterns

### Unit Tests (Services)

Test business logic in isolation using mocks:

```dart
test('creates campaign with valid data', () async {
  when(mockRepository.create(any))
      .thenAnswer((_) async => campaign);

  final result = await service.createCampaign(name: 'Test');

  expect(result.name, equals('Test'));
});
```

### Widget Tests

Test UI components:

```dart
testWidgets('displays campaign name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: CampaignCard(campaign: campaign)),
  );

  expect(find.text('Campaign Name'), findsOneWidget);
});
```

### Provider Tests

Test state management:

```dart
test('loadCampaigns sets data state', () async {
  when(mockService.getAll()).thenAnswer((_) async => [campaign]);

  await provider.load();

  expect(provider.state.hasData, true);
});
```
```

### 8. Set Up Coverage Reporting

**coverage.sh:**
```bash
#!/bin/bash
# Generate test coverage report

flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

Make executable:
```bash
chmod +x coverage.sh
```

### 9. Add CI Test Configuration

**.github/workflows/test.yml:**
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Install dependencies
        run: flutter pub get
        working-directory: moonforge
      
      - name: Run tests
        run: flutter test
        working-directory: moonforge
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: moonforge/coverage/lcov.info
```

## Safety & Verification

### Verification Checklist

- [ ] All services have unit tests
- [ ] Complex widgets have widget tests
- [ ] Test coverage > 70% for core logic
- [ ] All tests pass
- [ ] CI runs tests automatically
- [ ] Coverage report generated

## Git Workflow Tip

**Branch naming**: `refactor/09-testing-infrastructure`

## Impact Assessment

**Risk level**: Low  
**Files affected**: 50+ new test files  
**Breaking changes**: None  
**Migration needed**: None

## Next Step

Proceed to [Step 10: Documentation and Code Comments](step-10.md).
