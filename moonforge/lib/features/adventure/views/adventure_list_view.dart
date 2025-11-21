import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/features/adventure/widgets/adventure_list.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AdventureListView extends StatefulWidget {
  const AdventureListView({super.key});

  @override
  State<AdventureListView> createState() => _AdventureListViewState();
}

class _AdventureListViewState extends State<AdventureListView> {
  String? _selectedChapterId;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final adventureRepo = context.read<AdventureRepository>();
    final chapterRepo = context.read<ChapterRepository>();

    return Column(
      children: [
        SurfaceContainer(
          title: Text(
            l10n.adventures,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          child: Column(
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: l10n.search,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              // Chapter filter
              FutureBuilder<List<Chapter>>(
                future: chapterRepo.getByCampaign(campaign.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator(minHeight: 2);
                  }

                  final chapters = snapshot.data ?? [];
                  if (chapters.isEmpty) {
                    return Text(l10n.noChaptersYet);
                  }

                  return DropdownButtonFormField<String?>(
                    initialValue: _selectedChapterId,
                    decoration: InputDecoration(
                      labelText: l10n.filterByChapter,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.allChapters),
                      ),
                      for (final chapter in chapters)
                        DropdownMenuItem<String>(
                          value: chapter.id,
                          child: Text(chapter.name),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedChapterId = value;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),

        // Adventures list
        FutureBuilder<List<Adventure>>(
          future: _loadAdventures(adventureRepo, chapterRepo, campaign.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var adventures = snapshot.data ?? [];

            // Apply filters
            if (_selectedChapterId != null) {
              adventures = adventures
                  .where((a) => a.chapterId == _selectedChapterId)
                  .toList();
            }

            if (_searchQuery.isNotEmpty) {
              adventures = adventures.where((a) {
                return a.name.toLowerCase().contains(_searchQuery) ||
                    (a.summary?.toLowerCase().contains(_searchQuery) ?? false);
              }).toList();
            }

            return SurfaceContainer(
              child: AdventureList(
                adventures: adventures,
                enableContextMenu: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<List<Adventure>> _loadAdventures(
    AdventureRepository adventureRepo,
    ChapterRepository chapterRepo,
    String campaignId,
  ) async {
    // Get all chapters for the campaign
    final chapters = await chapterRepo.getByCampaign(campaignId);

    // Get adventures for all chapters
    final allAdventures = <Adventure>[];
    for (final chapter in chapters) {
      final adventures = await adventureRepo.getByChapter(chapter.id);
      allAdventures.addAll(adventures);
    }

    // Sort by updated date (newest first)
    allAdventures.sort((a, b) {
      final dateA = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    return allAdventures;
  }
}
