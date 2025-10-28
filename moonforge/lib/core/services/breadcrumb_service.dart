import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Represents a single breadcrumb item with its display text and navigation path
class BreadcrumbItem {
  final String text;
  final String path;
  final bool isLoading;

  BreadcrumbItem({
    required this.text,
    required this.path,
    this.isLoading = false,
  });
}

/// Service for building breadcrumbs from route information.
///
/// This service resolves route segments and path parameters into human-readable
/// breadcrumb items by fetching entity names from Firestore.
///
/// Example:
/// - URL: `/campaign/chapter/ch123/adventure/adv456`
/// - Output: `[CampaignName, ChapterName, AdventureName]`
///
/// Features:
/// - Fetches actual entity names from database
/// - Skips redundant label segments (e.g., "campaign", "chapter")
/// - Provides fallbacks for loading/missing data
/// - Handles all entity types: campaign, chapter, adventure, scene, entity, etc.
/// - Special handling for entities without name fields (e.g., Session uses datetime)
class BreadcrumbService {
  /// Build breadcrumbs from the current route.
  ///
  /// This method:
  /// 1. Parses the route segments and path parameters
  /// 2. Fetches entity data from Firestore ODM for each ID
  /// 3. Returns a list of breadcrumb items with display text and navigation paths
  ///
  /// The breadcrumbs show the actual entity names (e.g., "My Campaign" instead
  /// of just "campaign" or the ID). If data is not yet loaded or an error occurs,
  /// it falls back to showing "..." (ellipsis) or the localized entity type name.
  static Future<List<BreadcrumbItem>> buildBreadcrumbs(
    BuildContext context,
    GoRouterState state,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final segments = state.uri.pathSegments;
    final params = state.pathParameters;
    final breadcrumbs = <BreadcrumbItem>[];

    if (segments.isEmpty) {
      breadcrumbs.add(BreadcrumbItem(
        text: l10n.home,
        path: '/',
      ));
      return breadcrumbs;
    }

    // Get current campaign from provider
    final campaign = context.read<CampaignProvider>().currentCampaign;
    final odm = Odm.instance;

    int i = 0;
    while (i < segments.length) {
      final segment = segments[i];

      switch (segment) {
        case 'campaign':
          // Show campaign name if available
          if (campaign != null) {
            breadcrumbs.add(BreadcrumbItem(
              text: campaign.name,
              path: '/campaign',
            ));
          } else {
            breadcrumbs.add(BreadcrumbItem(
              text: l10n.campaign,
              path: '/campaign',
            ));
          }
          i++;
          break;

        case 'chapter':
          // Next segment should be the chapter ID
          if (i + 1 < segments.length && params.containsKey('chapterId')) {
            final chapterId = params['chapterId']!;
            try {
              if (campaign != null) {
                final chapter = await odm.campaigns
                    .doc(campaign.id)
                    .chapters
                    .doc(chapterId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: chapter?.name ?? l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/campaign/chapter/$chapterId',
              ));
            }
            i += 2; // Skip 'chapter' and chapterId
          } else {
            i++;
          }
          break;

        case 'adventure':
          // Next segment should be the adventure ID
          if (i + 1 < segments.length && params.containsKey('adventureId')) {
            final chapterId = params['chapterId'];
            final adventureId = params['adventureId']!;
            try {
              if (campaign != null && chapterId != null) {
                final adventure = await odm.campaigns
                    .doc(campaign.id)
                    .chapters
                    .doc(chapterId)
                    .adventures
                    .doc(adventureId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: adventure?.name ?? l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId/adventure/$adventureId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/chapter/${chapterId ?? ''}/adventure/$adventureId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/campaign/chapter/${chapterId ?? ''}/adventure/$adventureId',
              ));
            }
            i += 2; // Skip 'adventure' and adventureId
          } else {
            i++;
          }
          break;

        case 'scene':
          // Next segment should be the scene ID
          if (i + 1 < segments.length && params.containsKey('sceneId')) {
            final chapterId = params['chapterId'];
            final adventureId = params['adventureId'];
            final sceneId = params['sceneId']!;
            try {
              if (campaign != null && chapterId != null && adventureId != null) {
                final scene = await odm.campaigns
                    .doc(campaign.id)
                    .chapters
                    .doc(chapterId)
                    .adventures
                    .doc(adventureId)
                    .scenes
                    .doc(sceneId)
                    .get();
                // Note: Scene entities use the 'title' field for display names
                // instead of the standard 'name' field used by other entities.
                breadcrumbs.add(BreadcrumbItem(
                  text: scene?.title ?? l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId/adventure/$adventureId/scene/$sceneId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/chapter/${chapterId ?? ''}/adventure/${adventureId ?? ''}/scene/$sceneId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/campaign/chapter/${chapterId ?? ''}/adventure/${adventureId ?? ''}/scene/$sceneId',
              ));
            }
            i += 2; // Skip 'scene' and sceneId
          } else {
            i++;
          }
          break;

        case 'entity':
          // Next segment should be the entity ID
          if (i + 1 < segments.length && params.containsKey('entityId')) {
            final entityId = params['entityId']!;
            try {
              if (campaign != null) {
                final entity = await odm.campaigns
                    .doc(campaign.id)
                    .entities
                    .doc(entityId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: entity?.name ?? l10n.ellipsis,
                  path: '/campaign/entity/$entityId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/entity/$entityId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/campaign/entity/$entityId',
              ));
            }
            i += 2; // Skip 'entity' and entityId
          } else {
            i++;
          }
          break;

        case 'encounter':
          // Next segment should be the encounter ID
          if (i + 1 < segments.length && params.containsKey('encounterId')) {
            final encounterId = params['encounterId']!;
            try {
              if (campaign != null) {
                final encounter = await odm.campaigns
                    .doc(campaign.id)
                    .encounters
                    .doc(encounterId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: encounter?.name ?? l10n.ellipsis,
                  path: '/campaign/encounter/$encounterId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/encounter/$encounterId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/campaign/encounter/$encounterId',
              ));
            }
            i += 2; // Skip 'encounter' and encounterId
          } else {
            i++;
          }
          break;

        case 'party':
          // Next segment might be the party ID or it could be the party root
          if (i + 1 < segments.length && params.containsKey('partyId')) {
            final partyId = params['partyId']!;
            try {
              if (campaign != null) {
                final party = await odm.campaigns
                    .doc(campaign.id)
                    .parties
                    .doc(partyId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: party?.name ?? l10n.ellipsis,
                  path: '/party/$partyId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/party/$partyId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/party/$partyId',
              ));
            }
            i += 2; // Skip 'party' and partyId
          } else {
            breadcrumbs.add(BreadcrumbItem(
              text: l10n.party,
              path: '/party',
            ));
            i++;
          }
          break;

        case 'member':
          // Next segment should be the member ID
          if (i + 1 < segments.length && params.containsKey('memberId')) {
            final partyId = params['partyId'];
            final memberId = params['memberId']!;
            try {
              if (campaign != null && partyId != null) {
                final member = await odm.campaigns
                    .doc(campaign.id)
                    .players
                    .doc(memberId)
                    .get();
                breadcrumbs.add(BreadcrumbItem(
                  text: member?.name ?? l10n.ellipsis,
                  path: '/party/$partyId/member/$memberId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/party/${partyId ?? ''}/member/$memberId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.ellipsis,
                path: '/party/${partyId ?? ''}/member/$memberId',
              ));
            }
            i += 2; // Skip 'member' and memberId
          } else {
            i++;
          }
          break;

        case 'session':
          // Next segment should be the session ID
          if (i + 1 < segments.length && params.containsKey('sessionId')) {
            final partyId = params['partyId'];
            final sessionId = params['sessionId']!;
            try {
              if (campaign != null && partyId != null) {
                final session = await odm.campaigns
                    .doc(campaign.id)
                    .sessions
                    .doc(sessionId)
                    .get();
                // Session doesn't have a name field, use datetime or fallback to "Session"
                String displayText = l10n.session;
                if (session?.datetime != null) {
                  // Format date using proper date formatting for internationalization
                  // DateFormat automatically uses the current locale from Localizations
                  displayText = DateFormat.yMMMd().format(session!.datetime!);
                }
                breadcrumbs.add(BreadcrumbItem(
                  text: displayText,
                  path: '/party/$partyId/session/$sessionId',
                ));
              } else {
                breadcrumbs.add(BreadcrumbItem(
                  text: l10n.session,
                  path: '/party/${partyId ?? ''}/session/$sessionId',
                ));
              }
            } catch (e) {
              breadcrumbs.add(BreadcrumbItem(
                text: l10n.session,
                path: '/party/${partyId ?? ''}/session/$sessionId',
              ));
            }
            i += 2; // Skip 'session' and sessionId
          } else {
            i++;
          }
          break;

        case 'edit':
          // Skip 'edit' suffix in breadcrumbs - we're already on that entity
          i++;
          break;

        case 'settings':
          breadcrumbs.add(BreadcrumbItem(
            text: l10n.settings,
            path: '/settings',
          ));
          i++;
          break;

        case 'login':
          breadcrumbs.add(BreadcrumbItem(
            text: l10n.login,
            path: '/login',
          ));
          i++;
          break;

        case 'register':
          breadcrumbs.add(BreadcrumbItem(
            text: l10n.register,
            path: '/login/register',
          ));
          i++;
          break;

        case 'forgot':
          breadcrumbs.add(BreadcrumbItem(
            text: l10n.forgotPassword,
            path: '/login/forgot',
          ));
          i++;
          break;

        default:
          // Skip unknown segments or IDs that are not preceded by known keys
          i++;
          break;
      }
    }

    return breadcrumbs;
  }
}
