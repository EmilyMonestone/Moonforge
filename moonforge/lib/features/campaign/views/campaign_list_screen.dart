import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_list_controller.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/campaign/utils/create_campaign.dart';
import 'package:moonforge/features/campaign/widgets/campaign_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for browsing all campaigns
class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  late CampaignService _service;
  late CampaignListController _controller;

  @override
  void initState() {
    super.initState();
    final db = context.read<AppDb>();
    _service = CampaignService(CampaignRepository(db));
    _controller = CampaignListController(_service);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaigns = context.watch<List<Campaign>>();

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Column(
        children: [
          // Header with title and actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  l10n.campaigns,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Spacer(),
                // View mode toggle
                Consumer<CampaignListController>(
                  builder: (context, controller, _) {
                    return SegmentedButton<ViewMode>(
                      segments: const [
                        ButtonSegment(
                          value: ViewMode.grid,
                          icon: Icon(Icons.grid_view),
                        ),
                        ButtonSegment(
                          value: ViewMode.list,
                          icon: Icon(Icons.view_list),
                        ),
                      ],
                      selected: {controller.viewMode},
                      onSelectionChanged: (Set<ViewMode> selected) {
                        controller.setViewMode(selected.first);
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),
                ButtonM3E(
                  style: ButtonM3EStyle.filled,
                  shape: ButtonM3EShape.square,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.menuNewCampaign),
                  onPressed: () {
                    createCampaignAndOpenEditor(context);
                  },
                ),
              ],
            ),
          ),

          // Search and filter bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search campaigns...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: Consumer<CampaignListController>(
                        builder: (context, controller, _) {
                          if (controller.searchQuery.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => controller.setSearchQuery(''),
                          );
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _controller.setSearchQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<CampaignListController>(
                  builder: (context, controller, _) {
                    return PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      tooltip: 'Sort',
                      onSelected: (value) {
                        if (value == 'direction') {
                          controller.toggleSortDirection();
                        } else {
                          controller.setSortBy(value);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'name',
                          child: Row(
                            children: [
                              if (controller.sortBy == 'name')
                                const Icon(Icons.check, size: 16)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              const Text('Name'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'updated',
                          child: Row(
                            children: [
                              if (controller.sortBy == 'updated')
                                const Icon(Icons.check, size: 16)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              const Text('Last Updated'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'created',
                          child: Row(
                            children: [
                              if (controller.sortBy == 'created')
                                const Icon(Icons.check, size: 16)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              const Text('Created'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'direction',
                          child: Row(
                            children: [
                              Icon(
                                controller.descending
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.descending
                                    ? 'Descending'
                                    : 'Ascending',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Campaign list
          Expanded(
            child: Consumer<CampaignListController>(
              builder: (context, controller, _) {
                return FutureBuilder<List<Campaign>>(
                  future: controller.getFilteredCampaigns(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final filteredCampaigns = snapshot.data ?? campaigns;

                    return CampaignList(
                      campaigns: filteredCampaigns,
                      viewMode: controller.viewMode,
                      onCampaignTap: (campaign) {
                        // Set as current campaign and navigate
                        context.read<CampaignProvider>().setCurrentCampaign(
                          campaign,
                        );
                        const CampaignRouteData().go(context);
                      },
                      onCampaignEdit: (campaign) {
                        context.read<CampaignProvider>().setCurrentCampaign(
                          campaign,
                        );
                        const CampaignEditRouteData().go(context);
                      },
                      onCampaignDelete: (campaign) async {
                        // Show confirmation dialog
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Campaign'),
                            content: Text(
                              'Are you sure you want to delete "${campaign.name}"? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          await CampaignRepository(
                            context.read<AppDb>(),
                          ).delete(campaign.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
