import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/responsive_sections.dart';
import 'package:moonforge/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Placeholder/mock data — replace with real repositories/providers
    // TODO: Wire up actual recent items from storage/providers
    final recentCampaigns = const [
      'The Shattered Isles',
      'Echoes of Eldoria',
      'Crown of Cinders',
    ];
    final recentSessions = const [
      'Session 21 — Into the Vault',
      'Session 20 — River Ambush',
      'Session 19 — The Heist',
    ];
    final recentParties = const [
      'The Ember Wardens',
      'Silver Company',
      'Gilded Owls',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          ResponsiveSectionsGrid(
            minColumnWidth: 420,
            spacing: 16,
            runSpacing: 16,
            sections: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: l10n.recentCampaigns,
                    icon: Icons.book_outlined,
                  ),
                  const SizedBox(height: 8),
                  _CardList(
                    items: recentCampaigns,
                    onTap: (title) {
                      // TODO: Navigate to the specific campaign by ID
                      // Placeholder: Go to campaign root
                      const CampaignRoute().go(context);
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: l10n.recentSessions,
                    icon: Icons.schedule_outlined,
                  ),
                  const SizedBox(height: 8),
                  _CardList(
                    items: recentSessions,
                    onTap: (title) {
                      // TODO: Navigate to specific session: SessionRoute(partyId: ..., sessionId: ...)
                      // Placeholder: do nothing
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: l10n.recentParties,
                    icon: Icons.group_outlined,
                  ),
                  const SizedBox(height: 8),
                  _CardList(
                    items: recentParties,
                    onTap: (title) {
                      // TODO: Navigate to specific party by ID
                      // Placeholder: go to party root without ID
                      const PartyRootRoute().go(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.items, this.onTap});

  final List<String> items;
  final void Function(String title)? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final title = items[index];
        return Card(
          child: ListTile(
            title: Text(title, style: textTheme.titleMedium),
            subtitle: const Text(
              '— TODO: metadata',
            ), // TODO: Add subtitle details like last edited time
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap != null ? () => onTap!(title) : null,
          ),
        );
      },
    );
  }
}
