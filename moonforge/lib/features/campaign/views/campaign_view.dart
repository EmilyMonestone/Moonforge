import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart' show BuildContextM3EX;
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/campaign/widgets/campaign_header.dart';
import 'package:moonforge/features/campaign/widgets/campaign_stats_dashboard.dart';
import 'package:moonforge/features/campaign/widgets/chapters_section.dart';
import 'package:moonforge/features/campaign/widgets/recent_adventures_section.dart';
import 'package:moonforge/features/campaign/widgets/recent_chapters_section.dart';
import 'package:moonforge/features/campaign/widgets/recent_scenes_section.dart';
import 'package:moonforge/features/campaign/widgets/recent_sessions_section.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CampaignView extends StatefulWidget {
  const CampaignView({super.key});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> {
  QuillController _controller = QuillController.basic();

  // Keep dedicated controllers/nodes to dispose properly.
  final ScrollController _quillScrollController = ScrollController();
  final FocusNode _quillFocusNode = FocusNode();

  Campaign? _lastCampaign;

  @override
  void initState() {
    super.initState();
    _controller.readOnly = true; // ensure viewer only
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final camp = context.read<CampaignProvider>().currentCampaign;
    if ((_lastCampaign?.id) != (camp?.id)) {
      Document doc;
      try {
        if (camp?.content != null) {
          final ops = camp!.content!['ops'] as List<dynamic>?;
          if (ops != null) {
            doc = Document.fromJson(ops);
          } else {
            doc = Document();
          }
        } else {
          doc = Document();
        }
      } catch (e) {
        doc = Document();
      }
      // Replace controller so listeners rebuild properly
      _controller.dispose();
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      )..readOnly = true;
      _lastCampaign = camp;
      // Trigger rebuild for new controller
      setState(() {});
    }
  }

  @override
  void dispose() {
    _quillScrollController.dispose();
    _quillFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    if (campaign == null) {
      // TODO: show select of available campaigns
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final service = getIt<CampaignService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampaignHeader(campaign: campaign),
        CampaignStatsDashboard(campaign: campaign, service: service),
        SurfaceContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shortDescription,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Show description when non-empty; otherwise the fallback.
                    campaign.description.trim().isNotEmpty
                        ? campaign.description
                        : l10n.noDescriptionProvided,
                  ),
                ],
              ),
              CustomQuillViewer(
                controller: _controller,
                onMentionTap: (entityId, mentionType) async {
                  EntityRouteData(entityId: entityId).push(context);
                },
              ),
            ],
          ),
        ),
        WrapLayout(
          children: [
            ChaptersSection(campaign: campaign),
            CampaignEntitiesWidget(campaignId: campaign.id),
            RecentChaptersSection(campaign: campaign),
            RecentAdventuresSection(campaign: campaign),
            RecentScenesSection(campaign: campaign),
            RecentSessionsSection(campaign: campaign),
          ],
        ),
      ],
    );
  }
}
