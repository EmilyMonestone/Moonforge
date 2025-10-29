# State Management with Riverpod

Moonforge uses Riverpod for reactive state management and dependency injection.

## Overview

- **Provider Pattern**: Declare dependencies as providers
- **Reactive**: UI automatically rebuilds when data changes
- **Type-Safe**: Compile-time safety
- **Testable**: Easy to mock and test

## Provider Types

### StreamProvider

For reactive data streams from Drift:

```dart
final campaignsProvider = StreamProvider<List<Campaign>>((ref) {
  final repo = ref.watch(campaignRepositoryProvider);
  return repo.watchAll();
});
```

### FutureProvider

For async operations:

```dart
final entityProvider = FutureProvider.family<Entity?, String>((ref, id) async {
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getById(id);
});
```

### StateProvider

For simple state:

```dart
final selectedTabProvider = StateProvider<int>((ref) => 0);
```

### StateNotifierProvider

For complex state logic:

```dart
class CampaignNotifier extends StateNotifier<AsyncValue<Campaign?>> {
  CampaignNotifier(this._repo) : super(const AsyncValue.loading());
  
  final CampaignRepository _repo;
  
  Future<void> load(String id) async {
    state = const AsyncValue.loading();
    try {
      final campaign = await _repo.getById(id);
      state = AsyncValue.data(campaign);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

## Usage in Widgets

### ConsumerWidget

```dart
class CampaignList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaigns = ref.watch(campaignsProvider);
    
    return campaigns.when(
      data: (list) => ListView(children: list.map(...).toList()),
      loading: () => CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
```

### Consumer

For part of a widget:

```dart
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(countProvider);
    return Text('Count: $count');
  },
)
```

## Common Patterns

### Repository Provider

```dart
final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  final dao = ref.watch(campaignsDao Provider);
  return CampaignRepository(dao);
});
```

### Current Selection

```dart
final currentCampaignIdProvider = StateProvider<String?>((ref) => null);

final currentCampaignProvider = StreamProvider<Campaign?>((ref) {
  final id = ref.watch(currentCampaignIdProvider);
  if (id == null) return Stream.value(null);
  
  final repo = ref.watch(campaignRepositoryProvider);
  return repo.watchById(id);
});
```

### Computed Values

```dart
final filteredEntitiesProvider = Provider<List<Entity>>((ref) {
  final entities = ref.watch(entitiesProvider).value ?? [];
  final filter = ref.watch(entityFilterProvider);
  return entities.where((e) => e.kind == filter).toList();
});
```

## Best Practices

1. **Keep providers pure** - No side effects in provider body
2. **Use families** - For parameterized providers
3. **Dispose properly** - Use autoDispose when appropriate
4. **Avoid rebuilds** - Use select() to watch specific properties
5. **Error handling** - Always handle AsyncValue errors

## Testing

Mock providers in tests:

```dart
testWidgets('shows campaigns', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        campaignsProvider.overrideWith((ref) => Stream.value([...])),
      ],
      child: MyApp(),
    ),
  );
});
```

## Related Documentation

- [Architecture Overview](overview.md)
- [Data Layer](data-layer.md)

## External Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Examples](https://github.com/rrousselGit/riverpod/tree/master/examples)
