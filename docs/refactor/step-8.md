# Step 8: Widget Tree Simplification

**Priority**: Medium  
**Effort**: L (6-10 days)  
**Branch**: `refactor/08-widget-simplification`

## Goal

Break down large, complex widgets into smaller, focused components. This improves readability, testability, and reusability while making the codebase easier to maintain and extend.

By the end of this step:
- No widget build method exceeds 100 lines
- Complex widget trees are decomposed into logical sub-widgets
- Widget responsibilities are clear and focused
- Code is more testable with isolated widget tests

## Scope

**What's included:**
- Large view widgets (screens/pages)
- Complex custom widgets
- Deeply nested widget trees

**What's excluded:**
- Simple widgets that are already focused
- Generated widget code
- Third-party widgets

## Instructions

### 1. Identify Complex Widgets

Find widgets with large build methods:

```bash
cd moonforge/lib
# Find files with large build methods (rough estimate)
find . -name "*.dart" -not -path "*/gen/*" -not -name "*.g.dart" \
  -exec awk '/Widget build\(BuildContext/ {p=1} p{c++} /^  \}/ {if(p && c>100) print FILENAME": "c" lines"; p=0; c=0}' {} \;
```

Target widgets with:
- Build methods > 100 lines
- Nesting depth > 5 levels
- Multiple responsibilities

### 2. Extract Builder Methods

**Before** (complex inline build):
```dart
class CampaignDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Campaign')),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Header section - 30 lines
            Card(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(campaign.name, style: context.titleLarge.bold),
                    SizedBox(height: AppSpacing.sm),
                    Text(campaign.description ?? ''),
                    // ... more header content
                  ],
                ),
              ),
            ),
            
            // Stats section - 40 lines
            Card(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  children: [
                    // Complex stats UI...
                  ],
                ),
              ),
            ),
            
            // Chapters section - 50 lines
            Card(
              child: Column(
                children: [
                  // Complex chapters list...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**After** (extracted sub-widgets):
```dart
class CampaignDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Campaign')),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            _CampaignHeader(campaign: campaign),
            SizedBox(height: AppSpacing.lg),
            _CampaignStats(campaign: campaign),
            SizedBox(height: AppSpacing.lg),
            _CampaignChaptersList(campaignId: campaign.id),
          ],
        ),
      ),
    );
  }
}

// Private widget for header section
class _CampaignHeader extends StatelessWidget {
  final Campaign campaign;

  const _CampaignHeader({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campaign.name, style: context.titleLarge.bold),
          SizedBox(height: AppSpacing.sm),
          if (campaign.description != null)
            Text(campaign.description!),
          SizedBox(height: AppSpacing.md),
          _buildMetadata(context),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: context.outline),
        SizedBox(width: AppSpacing.xs),
        Text(
          'Created ${_formatDate(campaign.createdAt)}',
          style: context.bodySmall.colored(context.outline),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Private widget for stats section
class _CampaignStats extends StatelessWidget {
  final Campaign campaign;

  const _CampaignStats({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistics', style: context.titleMedium.bold),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                icon: Icons.book,
                label: 'Chapters',
                value: '${campaign.chapterCount}',
              ),
              _buildStatItem(
                context,
                icon: Icons.people,
                label: 'Players',
                value: '${campaign.playerCount}',
              ),
              _buildStatItem(
                context,
                icon: Icons.event,
                label: 'Sessions',
                value: '${campaign.sessionCount}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: context.primary),
        SizedBox(height: AppSpacing.xs),
        Text(value, style: context.titleLarge.bold),
        Text(label, style: context.bodySmall),
      ],
    );
  }
}

// Private widget for chapters list
class _CampaignChaptersList extends StatelessWidget {
  final String campaignId;

  const _CampaignChaptersList({required this.campaignId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChapterProvider>(context);

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chapters', style: context.titleMedium.bold),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showCreateChapterDialog(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          AsyncStateBuilder<List<Chapter>>(
            state: provider.state,
            builder: (context, chapters) {
              if (chapters.isEmpty) {
                return EmptyState(
                  icon: Icons.book_outlined,
                  title: 'No chapters yet',
                  message: 'Add your first chapter to get started',
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chapters.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) => ChapterListItem(
                  chapter: chapters[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateChapterDialog(BuildContext context) {
    // Show dialog...
  }
}
```

### 3. Apply Single Responsibility Principle

Each widget should have one clear purpose:

**Bad** (multiple responsibilities):
```dart
class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/campaigns/${campaign.id}'),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            children: [
              // Display campaign info
              // Show player avatars
              // Display action buttons
              // Show statistics
              // Handle favorite toggle
            ],
          ),
        ),
      ),
    );
  }
}
```

**Good** (focused widgets):
```dart
class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback? onTap;

  const CampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CampaignCardHeader(campaign: campaign),
          SizedBox(height: AppSpacing.sm),
          _CampaignCardStats(campaign: campaign),
          SizedBox(height: AppSpacing.sm),
          _CampaignCardPlayers(campaign: campaign),
        ],
      ),
    );
  }
}

class _CampaignCardHeader extends StatelessWidget {
  final Campaign campaign;

  const _CampaignCardHeader({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            campaign.name,
            style: context.titleMedium.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _CampaignFavoriteButton(campaign: campaign),
      ],
    );
  }
}

class _CampaignCardStats extends StatelessWidget {
  final Campaign campaign;

  const _CampaignCardStats({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(icon: Icons.book, value: '${campaign.chapterCount}'),
        SizedBox(width: AppSpacing.sm),
        _StatChip(icon: Icons.event, value: '${campaign.sessionCount}'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(value, style: context.bodySmall),
      visualDensity: VisualDensity.compact,
    );
  }
}
```

### 4. Extract Reusable Patterns

Identify widget patterns used multiple times:

```dart
// Common pattern: Icon + Text row
class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle? textStyle;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.outline),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: textStyle ?? context.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Usage
IconTextRow(
  icon: Icons.calendar_today,
  text: 'Created ${formatDate(campaign.createdAt)}',
);
```

### 5. Use Builder Functions for Simple Extraction

For small sections that don't warrant a full widget:

```dart
class CampaignDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildBody(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: AppSpacing.paddingLg,
      child: Text('Header'),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: ListView(
        children: [
          // Body content
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: AppSpacing.paddingMd,
      child: Row(
        children: [
          // Footer content
        ],
      ),
    );
  }
}
```

### 6. Simplify Conditional Rendering

**Before** (complex nested conditions):
```dart
Widget build(BuildContext context) {
  if (isLoading) {
    return LoadingIndicator();
  } else {
    if (hasError) {
      return ErrorDisplay(error: error);
    } else {
      if (data.isEmpty) {
        return EmptyState();
      } else {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            if (item.isSpecial) {
              return SpecialItemCard(item);
            } else {
              return RegularItemCard(item);
            }
          },
        );
      }
    }
  }
}
```

**After** (early returns):
```dart
Widget build(BuildContext context) {
  if (isLoading) return LoadingIndicator();
  if (hasError) return ErrorDisplay(error: error);
  if (data.isEmpty) return EmptyState();

  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) => _buildItem(data[index]),
  );
}

Widget _buildItem(Item item) {
  return item.isSpecial
      ? SpecialItemCard(item)
      : RegularItemCard(item);
}
```

### 7. Widget Testing Strategy

Add tests for complex widgets:

```dart
testWidgets('CampaignCard displays campaign info', (tester) async {
  final campaign = Campaign(
    id: '1',
    name: 'Test Campaign',
    chapterCount: 5,
    sessionCount: 10,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CampaignCard(campaign: campaign),
      ),
    ),
  );

  expect(find.text('Test Campaign'), findsOneWidget);
  expect(find.text('5'), findsOneWidget); // Chapter count
  expect(find.text('10'), findsOneWidget); // Session count
});
```

## Safety & Verification

### Verification Checklist

- [ ] No build method exceeds 100 lines
- [ ] Complex widgets broken into sub-widgets
- [ ] Widget responsibilities are clear
- [ ] Tests updated for new widgets
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Visual appearance unchanged

## Git Workflow Tip

**Branch naming**: `refactor/08-widget-simplification`

## Impact Assessment

**Risk level**: Low-Medium  
**Files affected**: 30-50 view and widget files  
**Breaking changes**: None  
**Migration needed**: None

## Next Step

Proceed to [Step 9: Testing Infrastructure Enhancement](step-9.md).
