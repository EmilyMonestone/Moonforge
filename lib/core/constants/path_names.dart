// an json of path and thir display name. for example HomeRoute : 'Home'

import 'package:flutter/material.dart';

import '../utils/logger.dart';

Map<String, Widget> pathNames = {
  'HomeRoute': const Icon(Icons.home_outlined),
  'CampaignRoute': const Text('Campaign'),
  'CampaignEditRoute': const Text('Edit Campaign'),
  'ChapterRoute': const Text('Chapter'),
  'ChapterEditRoute': const Text('Edit Chapter'),
  'AdventureRoute': const Text('Adventure'),
  'AdventureEditRoute': const Text('Edit Adventure'),
  'SceneRoute': const Text('Scene'),
  'SceneEditRoute': const Text('Edit Scene'),
  'EncounterRoute': const Text('Encounter'),
  'EncounterEditRoute': const Text('Edit Encounter'),
  'EntityRoute': const Text('Entity'),
  'EntityEditRoute': const Text('Edit Entity'),
  'PartyRoute': const Text('Party'),
  'SettingsRoute': const Text('Settings'),
  'LoginRoute': const Text('Login'),
  'RegisterRoute': const Text('Register'),
  'ForgotPasswordRoute': const Text('Forgot Password'),
  'ProfileRoute': const Text('Profile'),
  'NotFoundRoute': const Text('Not Found'),
};

// a typesafe way to get the path name
Widget getPathName(String routeName) {
  if (routeName.isEmpty) {
    return const Text('...');
  } else if (pathNames.containsKey(routeName)) {
    return pathNames[routeName]!;
  } else {
    logger.w('No path name found for route: $routeName');
    return Text('...');
  }
}
