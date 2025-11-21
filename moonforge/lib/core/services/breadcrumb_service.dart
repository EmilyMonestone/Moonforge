import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
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
/// breadcrumb items by fetching entity names from the Drift database via repositories.
///
/// Example:
/// - URL: `/campaign/chapter/ch123/adventure/adv456`
/// - Output: `[CampaignName, ChapterName, AdventureName]`
///
/// Features:
/// - Fetches actual entity names from local Drift database
/// - Skips redundant label segments (e.g., "campaign", "chapter")
/// - Provides fallbacks for loading/missing data
/// - Handles all entity types: campaign, chapter, adventure, scene, entity, etc.
/// - Special handling for entities without name fields (e.g., Session uses datetime)
class BreadcrumbService {
  /// Build breadcrumbs from the current route.
  ///
  /// This method:
  /// 1. Parses the route segments and path parameters
  /// 2. Fetches entity data from Drift repositories for each ID
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
      breadcrumbs.add(BreadcrumbItem(text: l10n.home, path: '/'));
      return breadcrumbs;
    }

    // Get current campaign from provider
    final campaign = context.read<CampaignProvider>().currentCampaign;

    // Get repositories
    final chapterRepo = context.read<ChapterRepository>();
    final adventureRepo = context.read<AdventureRepository>();
    final sceneRepo = context.read<SceneRepository>();
    final entityRepo = context.read<EntityRepository>();
    final encounterRepo = context.read<EncounterRepository>();
    final partyRepo = context.read<PartyRepository>();
    final sessionRepo = context.read<SessionRepository>();

    int i = 0;
    while (i < segments.length) {
      final segment = segments[i];

      switch (segment) {
        case 'campaign':
          // Show campaign name if available
          if (campaign != null) {
            breadcrumbs.add(
              BreadcrumbItem(text: campaign.name, path: '/campaign'),
            );
          } else {
            breadcrumbs.add(
              BreadcrumbItem(text: l10n.campaign, path: '/campaign'),
            );
          }
          i++;
          break;

        case 'chapter':
          // Next segment should be the chapter ID
          if (i + 1 < segments.length && params.containsKey('chapterId')) {
            final chapterId = params['chapterId']!;
            try {
              final chapter = await chapterRepo.getById(chapterId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: chapter?.name ?? l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId',
                ),
              );
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
              final adventure = await adventureRepo.getById(adventureId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: adventure?.name ?? l10n.ellipsis,
                  path: '/campaign/chapter/$chapterId/adventure/$adventureId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path:
                      '/campaign/chapter/${chapterId ?? ''}/adventure/$adventureId',
                ),
              );
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
              final scene = await sceneRepo.getById(sceneId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: scene?.name ?? l10n.ellipsis,
                  path:
                      '/campaign/chapter/$chapterId/adventure/$adventureId/scene/$sceneId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path:
                      '/campaign/chapter/${chapterId ?? ''}/adventure/${adventureId ?? ''}/scene/$sceneId',
                ),
              );
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
              final entity = await entityRepo.getById(entityId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: entity?.name ?? l10n.ellipsis,
                  path: '/campaign/entity/$entityId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/entity/$entityId',
                ),
              );
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
              final encounter = await encounterRepo.getById(encounterId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: encounter?.name ?? l10n.ellipsis,
                  path: '/campaign/encounter/$encounterId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/campaign/encounter/$encounterId',
                ),
              );
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
              final party = await partyRepo.getById(partyId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: party?.name ?? l10n.ellipsis,
                  path: '/party/$partyId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(text: l10n.ellipsis, path: '/party/$partyId'),
              );
            }
            i += 2; // Skip 'party' and partyId
          } else {
            breadcrumbs.add(BreadcrumbItem(text: l10n.party, path: '/party'));
            i++;
          }
          break;

        case 'member':
          // Next segment should be the member ID (which is an entity)
          if (i + 1 < segments.length && params.containsKey('memberId')) {
            final partyId = params['partyId'];
            final memberId = params['memberId']!;
            try {
              final member = await entityRepo.getById(memberId);
              breadcrumbs.add(
                BreadcrumbItem(
                  text: member?.name ?? l10n.ellipsis,
                  path: '/party/$partyId/member/$memberId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.ellipsis,
                  path: '/party/${partyId ?? ''}/member/$memberId',
                ),
              );
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
              final session = await sessionRepo.getById(sessionId);
              // Session doesn't have a name field, use datetime or fallback to "Session"
              String displayText = l10n.session;
              if (session?.datetime != null) {
                // Format date using proper date formatting for internationalization
                // DateFormat automatically uses the current locale from Localizations
                displayText = DateFormat.yMMMd().format(session!.datetime!);
              }
              breadcrumbs.add(
                BreadcrumbItem(
                  text: displayText,
                  path: '/party/$partyId/session/$sessionId',
                ),
              );
            } catch (e) {
              breadcrumbs.add(
                BreadcrumbItem(
                  text: l10n.session,
                  path: '/party/${partyId ?? ''}/session/$sessionId',
                ),
              );
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
          breadcrumbs.add(
            BreadcrumbItem(text: l10n.settings, path: '/settings'),
          );
          i++;
          break;

        case 'login':
          breadcrumbs.add(BreadcrumbItem(text: l10n.login, path: '/login'));
          i++;
          break;

        case 'register':
          breadcrumbs.add(
            BreadcrumbItem(text: l10n.register, path: '/login/register'),
          );
          i++;
          break;

        case 'forgot':
          breadcrumbs.add(
            BreadcrumbItem(text: l10n.forgotPassword, path: '/login/forgot'),
          );
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
