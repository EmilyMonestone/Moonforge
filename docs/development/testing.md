# Testing Guidelines

General testing guidelines for Moonforge.

## Test Types

### Unit Tests

Test individual functions and classes:

```dart
test('calculates XP correctly', () {
  final xp = encounterService.calculateXP([goblin, wolf]);
  expect(xp, equals(150));
});
```

### Widget Tests

Test UI components:

```dart
testWidgets('shows campaign list', (tester) async {
  await tester.pumpWidget(
    ProviderScope(child: CampaignListView()),
  );
  
  expect(find.text('My Campaign'), findsOneWidget);
});
```

### Integration Tests

Test end-to-end flows (see `integration_test/` directory).

## Running Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/services/encounter_service_test.dart

# With coverage
flutter test --coverage
```

## Best Practices

1. **Test behavior, not implementation**
2. **Mock external dependencies**
3. **Use descriptive test names**
4. **One assertion per test when possible**
5. **Clean up after tests**

## Mocking

Use Riverpod overrides:

```dart
testWidgets('test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(mockRepo),
      ],
      child: MyApp(),
    ),
  );
});
```

## Related Documentation

- [Testing Deep Links](testing-deep-links.md)
- [Code Generation](code-generation.md)
