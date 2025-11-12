import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';

/// Example widget demonstrating how to use the centralized domain visuals system.
///
/// This widget shows various ways to access and use domain type icons and colors.
class DomainVisualsExample extends StatelessWidget {
  const DomainVisualsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain Visuals Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Using extension methods
            Text(
              'Extension Method Examples',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildExampleCard(
              context,
              'Campaign Icon',
              DomainType.campaign.toIcon(),
            ),
            _buildExampleCard(
              context,
              'Chapter with Custom Size',
              DomainType.chapter.toIcon(size: 32),
            ),
            _buildExampleCard(
              context,
              'Adventure with Custom Color',
              DomainType.adventure.toIcon(
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            // Example 2: Using static methods
            Text(
              'Static Method Examples',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildExampleCard(
              context,
              'Scene Icon (Static)',
              Icon(DomainVisuals.getIcon(DomainType.scene)),
            ),
            _buildExampleCard(
              context,
              'Party Icon (Static)',
              Icon(DomainVisuals.getIcon(DomainType.party)),
            ),

            const SizedBox(height: 24),

            // Example 3: List of all domain types
            Text(
              'All Campaign Structure Types',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDomainTypeGrid([
              DomainType.campaign,
              DomainType.chapter,
              DomainType.adventure,
              DomainType.scene,
            ]),

            const SizedBox(height: 24),

            Text(
              'All Entity Types',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDomainTypeGrid([
              DomainType.entityNpc,
              DomainType.entityMonster,
              DomainType.entityGroup,
              DomainType.entityPlace,
              DomainType.entityItem,
              DomainType.entityHandout,
              DomainType.entityJournal,
            ]),

            const SizedBox(height: 24),

            // Example 4: Entity kind conversion
            Text(
              'Entity Kind String Conversion',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildEntityKindExample(context, 'npc'),
            _buildEntityKindExample(context, 'monster'),
            _buildEntityKindExample(context, 'place'),
            _buildEntityKindExample(context, 'item'),

            const SizedBox(height: 24),

            // Example 5: Usage in common UI patterns
            Text(
              'Common UI Patterns',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildListTileExample(context),
            const SizedBox(height: 8),
            _buildCardHeaderExample(context),
            const SizedBox(height: 8),
            _buildChipExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, String title, Widget icon) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
      ),
    );
  }

  Widget _buildDomainTypeGrid(List<DomainType> types) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                type.toIcon(size: 32),
                const SizedBox(height: 4),
                Text(
                  type.semanticLabel ?? type.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEntityKindExample(BuildContext context, String kind) {
    final icon = DomainVisuals.getEntityKindIcon(kind);
    final domainType = DomainVisuals.entityKindToDomainType(kind);

    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text('Entity Kind: "$kind"'),
        subtitle: Text('Converts to: ${domainType.name}'),
      ),
    );
  }

  Widget _buildListTileExample(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'ListTile Pattern',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: DomainType.campaign.toIcon(),
            title: const Text('The Lost Mines of Phandelver'),
            subtitle: const Text('A classic D&D campaign'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeaderExample(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Header Pattern',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  DomainType.chapter.icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chapter 1: The Beginning',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chip Pattern',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  avatar: Icon(DomainType.scene.icon, size: 16),
                  label: const Text('5 scenes'),
                ),
                Chip(
                  avatar: Icon(DomainType.entityNpc.icon, size: 16),
                  label: const Text('12 NPCs'),
                ),
                Chip(
                  avatar: Icon(DomainType.encounter.icon, size: 16),
                  label: const Text('3 encounters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
