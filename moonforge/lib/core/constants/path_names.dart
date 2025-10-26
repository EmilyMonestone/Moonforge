// Path display name localization helper.

import 'package:flutter/material.dart';
import 'package:moonforge/l10n/app_localizations.dart';

import '../utils/logger.dart';

/// Returns a localized widget for a given route or path segment name.
Widget getPathName(BuildContext context, String routeName) {
  final l10n = AppLocalizations.of(context)!;

  if (routeName.isEmpty) {
    return Text(l10n.ellipsis);
  }

  switch (routeName) {
    // GoRouter path segments
    case 'campaign':
      return Text(l10n.campaign);
    case 'edit':
      return Text(l10n.edit);
    case 'chapter':
      return Text(l10n.chapter);
    case 'adventure':
      return Text(l10n.adventure);
    case 'scene':
      return Text(l10n.scene);
    case 'encounter':
      return Text(l10n.encounter);
    case 'entity':
      return Text(l10n.entity);
    case 'party':
      return Text(l10n.party);
    case 'member':
      return Text(l10n.member);
    case 'session':
      return Text(l10n.session);
    case 'settings':
      return Text(l10n.settings);
    case 'login':
      return Text(l10n.login);
    case 'register':
      return Text(l10n.register);

    // Legacy auto_route names (kept for compatibility if referenced elsewhere)
    case 'HomeRoute':
      return const Icon(Icons.home_outlined);
    case 'CampaignRoute':
      return Text(l10n.campaign);
    case 'CampaignEditRoute':
      return Text('${l10n.edit} ${l10n.campaign}');
    case 'ChapterRoute':
      return Text(l10n.chapter);
    case 'ChapterEditRoute':
      return Text('${l10n.edit} ${l10n.chapter}');
    case 'AdventureRoute':
      return Text(l10n.adventure);
    case 'AdventureEditRoute':
      return Text('${l10n.edit} ${l10n.adventure}');
    case 'SceneRoute':
      return Text(l10n.scene);
    case 'SceneEditRoute':
      return Text('${l10n.edit} ${l10n.scene}');
    case 'EncounterRoute':
      return Text(l10n.encounter);
    case 'EncounterEditRoute':
      return Text('${l10n.edit} ${l10n.encounter}');
    case 'EntityRoute':
      return Text(l10n.entity);
    case 'EntityEditRoute':
      return Text('${l10n.edit} ${l10n.entity}');
    case 'PartyRoute':
      return Text(l10n.party);
    case 'SettingsRoute':
      return Text(l10n.settings);
    case 'LoginRoute':
      return Text(l10n.login);
    case 'RegisterRoute':
      return Text(l10n.register);
    case 'ForgotPasswordRoute':
      return Text(l10n.forgotPassword);
    case 'ProfileRoute':
      return Text(l10n.profile);
    case 'NotFoundRoute':
      return Text(l10n.notFound);

    default:
      logger.w('No path name found for route: $routeName');
      return Text(routeName);
  }
}
