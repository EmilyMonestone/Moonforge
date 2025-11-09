import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape, BuildContextM3EX;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/chapter/utils/create_chapter.dart';
import 'package:moonforge/features/chapter/widgets/chapter_list.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for browsing all chapters in a campaign
class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    // Get chapters for the current campaign
    final allChapters = context.watch<List<db.Chapter>>();
    final chapters = allChapters
        .where((c) => c.campaignId == campaign.id)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              SectionHeader(
                title: l10n.chapters,
                icon: Icons.menu_book_outlined,
              ),
              const Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.filled,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.add),
                label: Text(l10n.addChapter),
                onPressed: () async {
                  await createChapter(context, campaign.id);
                },
              ),
            ],
          ),
          child: chapters.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No chapters yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first chapter to organize your campaign story',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                )
              : ChapterList(
                  chapters: chapters,
                  showOrder: true,
                  onChapterTap: (chapter) {
                    ChapterRoute(chapterId: chapter.id).go(context);
                  },
                ),
        ),
      ],
    );
  }
}
