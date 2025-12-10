import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/providers/toc_provider.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Demo page showing how to use the Table of Contents feature.
///
/// This page demonstrates:
/// - How to create TOC entries
/// - How to wrap content with TocScope
/// - How to use keys to link sections to TOC entries
/// - How the TOC auto-highlights as you scroll
class TocDemoView extends StatefulWidget {
  const TocDemoView({super.key});

  @override
  State<TocDemoView> createState() => _TocDemoViewState();
}

class _TocDemoViewState extends State<TocDemoView> {
  final _scrollController = ScrollController();
  late final List<TocEntry> _tocEntries;
  
  // Create keys for each section
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  final _section3Key = GlobalKey();
  final _section4Key = GlobalKey();
  final _section5Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    
    // Define TOC entries
    _tocEntries = [
      TocEntry(
        key: _section1Key,
        title: 'Introduction',
        icon: Icons.info_outline,
        level: 0,
      ),
      TocEntry(
        key: _section2Key,
        title: 'Getting Started',
        icon: Icons.start_outlined,
        level: 0,
      ),
      TocEntry(
        key: _section3Key,
        title: 'Features',
        icon: Icons.star_outline,
        level: 0,
      ),
      TocEntry(
        key: _section4Key,
        title: 'Usage Examples',
        icon: Icons.code,
        level: 0,
      ),
      TocEntry(
        key: _section5Key,
        title: 'Conclusion',
        icon: Icons.check_circle_outline,
        level: 0,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TocScope(
      scrollController: _scrollController,
      entries: _tocEntries,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Introduction
          Container(
            key: _section1Key,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Introduction',
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to the Table of Contents Demo!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This page demonstrates the responsive Table of Contents feature. '
                    'On wide layouts (tablet/desktop), you\'ll see the TOC in a sidebar '
                    'on the right side. On compact layouts (mobile), you can access the '
                    'TOC by tapping the list icon in the top bar.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'As you scroll through this page, the TOC automatically highlights '
                    'the section you\'re currently viewing. Try clicking on TOC entries '
                    'to jump to different sections!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 2: Getting Started
          Container(
            key: _section2Key,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Getting Started',
                    icon: Icons.start_outlined,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How to Use TOC in Your Pages',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildCodeExample(
                    '''
1. Create GlobalKeys for each section
2. Create TocEntry objects with keys and titles
3. Wrap your content with TocScope
4. Attach keys to section containers
''',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The TOC system will automatically track scroll position and '
                    'highlight the active section. The layout scaffolds handle '
                    'displaying the TOC appropriately based on screen size.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 3: Features
          Container(
            key: _section3Key,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Features',
                    icon: Icons.star_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 4: Usage Examples
          Container(
            key: _section4Key,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Usage Examples',
                    icon: Icons.code,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Simple Example',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildCodeExample(
                    '''
final entries = [
  TocEntry(
    key: GlobalKey(),
    title: 'Overview',
    icon: Icons.info,
  ),
  TocEntry(
    key: GlobalKey(),
    title: 'Details',
    icon: Icons.description,
  ),
];

return TocScope(
  scrollController: _scrollController,
  entries: entries,
  child: yourContent,
);
''',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The TOC will appear automatically in the layout. On wide screens, '
                    'it shows in a sidebar. On compact screens, it\'s accessible via '
                    'a button in the app bar.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 5: Conclusion
          Container(
            key: _section5Key,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Conclusion',
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'That\'s it! You now know how to use the TOC feature in Moonforge.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The TOC feature is designed to work seamlessly across all platforms '
                    'and form factors, providing a consistent and intuitive navigation '
                    'experience for users browsing long-form content.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      ('Auto-scroll tracking', 'Automatically highlights the section you\'re viewing'),
      ('Click to navigate', 'Click any TOC entry to jump to that section'),
      ('Responsive design', 'Adapts to different screen sizes and platforms'),
      ('Nested sections', 'Supports hierarchical TOC structures'),
      ('Icon support', 'Add icons to TOC entries for visual clarity'),
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.$1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCodeExample(String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: SelectableText(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
