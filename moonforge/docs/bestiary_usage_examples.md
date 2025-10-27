# Bestiary Service - Usage Examples

This document provides practical examples of using the BestiaryService and BestiaryProvider in your Flutter widgets.

## Using BestiaryProvider in Widgets

The `BestiaryProvider` is available throughout the app via the `Provider` package. Here's how to use it:

### Basic Usage - Display List of Monsters

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';

class MonsterListScreen extends StatefulWidget {
  const MonsterListScreen({super.key});

  @override
  State<MonsterListScreen> createState() => _MonsterListScreenState();
}

class _MonsterListScreenState extends State<MonsterListScreen> {
  @override
  void initState() {
    super.initState();
    // Load monsters when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BestiaryProvider>().loadMonsters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D&D 5e Monsters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BestiaryProvider>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<BestiaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => provider.loadMonsters(forceSync: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.monsters.isEmpty) {
            return const Center(
              child: Text('No monsters available'),
            );
          }

          return ListView.builder(
            itemCount: provider.monsters.length,
            itemBuilder: (context, index) {
              final monster = provider.monsters[index] as Map<String, dynamic>;
              return ListTile(
                title: Text(monster['name'] ?? 'Unknown'),
                subtitle: Text(monster['type'] ?? ''),
                onTap: () {
                  // Navigate to monster detail screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

### Search for a Specific Monster

```dart
class MonsterSearchWidget extends StatefulWidget {
  const MonsterSearchWidget({super.key});

  @override
  State<MonsterSearchWidget> createState() => _MonsterSearchWidgetState();
}

class _MonsterSearchWidgetState extends State<MonsterSearchWidget> {
  final _searchController = TextEditingController();
  Map<String, dynamic>? _foundMonster;
  bool _searching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMonster() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _searching = true;
      _foundMonster = null;
    });

    final provider = context.read<BestiaryProvider>();
    final monster = await provider.getMonsterByName(name);

    setState(() {
      _foundMonster = monster;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search monster by name',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchMonster,
            ),
          ),
          onSubmitted: (_) => _searchMonster(),
        ),
        if (_searching)
          const CircularProgressIndicator()
        else if (_foundMonster != null)
          Card(
            child: ListTile(
              title: Text(_foundMonster!['name'] ?? 'Unknown'),
              subtitle: Text(_foundMonster!['type'] ?? ''),
            ),
          )
        else if (_searchController.text.isNotEmpty)
          const Text('Monster not found'),
      ],
    );
  }
}
```

### Display Sync Status

```dart
class BestiarySyncStatus extends StatelessWidget {
  const BestiarySyncStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BestiaryProvider>(
      builder: (context, provider, child) {
        final lastSync = provider.lastSync;
        final isCached = provider.isCached;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bestiary Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isCached ? Icons.check_circle : Icons.warning,
                      color: isCached ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(isCached ? 'Data cached' : 'No cached data'),
                  ],
                ),
                if (lastSync != null) ...[
                  const SizedBox(height: 8),
                  Text('Last synced: ${_formatDateTime(lastSync)}'),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.refresh(),
                      child: const Text('Sync Now'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        await provider.clearCache();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cache cleared'),
                          ),
                        );
                      },
                      child: const Text('Clear Cache'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
```

## Using BestiaryService Directly

If you prefer not to use the provider, you can use the `BestiaryService` directly:

```dart
import 'package:moonforge/core/services/bestiary_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';

class MyWidget extends StatefulWidget {
  // ...
}

class _MyWidgetState extends State<MyWidget> {
  late BestiaryService _bestiaryService;
  List<dynamic> _monsters = [];

  @override
  void initState() {
    super.initState();
    _bestiaryService = BestiaryService(PersistenceService());
    _loadMonsters();
  }

  Future<void> _loadMonsters() async {
    final monsters = await _bestiaryService.getAll();
    setState(() {
      _monsters = monsters;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... build UI with _monsters
  }
}
```

## Integration with Entity System

You can use the bestiary data to populate entities in your campaign:

```dart
Future<void> importMonsterAsEntity({
  required String monsterName,
  required String campaignId,
}) async {
  final provider = context.read<BestiaryProvider>();
  final monster = await provider.getMonsterByName(monsterName);
  
  if (monster == null) {
    // Show error
    return;
  }

  // Create entity from monster data
  final entity = Entity(
    id: uuid.v4(),
    kind: 'monster',
    name: monster['name'] as String,
    summary: monster['type'] as String?,
    statblock: monster, // Store full monster data in statblock
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // Save entity to Firestore
  // ... save logic ...
}
```

## Best Practices

1. **Load Early**: Load bestiary data early in your app's lifecycle if you know you'll need it.
2. **Handle Loading States**: Always show loading indicators while data is being fetched.
3. **Cache Awareness**: Check `isCached` before showing sync-dependent UI.
4. **Background Sync**: The service automatically syncs in the background when data is stale.
5. **Error Handling**: Always handle network errors gracefully and provide retry options.
6. **Memory Usage**: The provider keeps monsters in memory. For large datasets, consider pagination or lazy loading.

## Performance Tips

- Use `Consumer` widget to rebuild only parts of the UI that need bestiary data
- Load monsters once and cache them in the provider for the session
- Use `ensureFresh: false` when you don't need the latest data immediately
- Consider using `FutureBuilder` for one-time loads without state management
