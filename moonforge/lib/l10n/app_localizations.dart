import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// The localized application title
  ///
  /// In en, this message translates to:
  /// **'Moonforge'**
  String get appTitle;

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Label for Home tab and breadcrumb root
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for Campaign feature
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign;

  /// Label for Campaigns list
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaigns;

  /// Label for Chapter feature
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// Label for Party feature
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// Label for Settings feature
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Generic edit label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Generic delete label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation dialog title for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// Confirmation dialog message for delete action
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get deleteConfirmationMessage;

  /// Generic save label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for Adventure feature
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// Label for Scene feature
  ///
  /// In en, this message translates to:
  /// **'Scene'**
  String get scene;

  /// Label for Encounter feature
  ///
  /// In en, this message translates to:
  /// **'Encounter'**
  String get encounter;

  /// Label for Entity feature
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entity;

  /// Label for Member feature
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// Label for Session feature
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// Label for Login screen
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for Register screen
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// Label for Profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Label for Not Found screen
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// Fallback label when name unknown
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get ellipsis;

  /// Version label with prefix and value
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionWithNumber(String version);

  /// Tab label for Appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Tab label for Hotkeys settings
  ///
  /// In en, this message translates to:
  /// **'Hotkeys'**
  String get hotkeys;

  /// Tab label for additional settings
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for theme mode selection
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System default option label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Language name: English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Language name: German
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// Button label to continue where the user left off
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off'**
  String get continueWhereLeft;

  /// Section title for recent campaigns list
  ///
  /// In en, this message translates to:
  /// **'Recent Campaigns'**
  String get recentCampaigns;

  /// Section title for recent sessions list
  ///
  /// In en, this message translates to:
  /// **'Recent Sessions'**
  String get recentSessions;

  /// Section title for recent parties list
  ///
  /// In en, this message translates to:
  /// **'Recent Parties'**
  String get recentParties;

  /// Button label to create a new campaign
  ///
  /// In en, this message translates to:
  /// **'Create New Campaign'**
  String get createNewCampaign;

  /// Button label to create a new party
  ///
  /// In en, this message translates to:
  /// **'Create Party'**
  String get createParty;

  /// Button label to create a custom monster
  ///
  /// In en, this message translates to:
  /// **'Create Custom Monster'**
  String get createCustomMonster;

  /// Short label for continue action in menu
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get menuContinue;

  /// Short label for create new campaign action in menu
  ///
  /// In en, this message translates to:
  /// **'New campaign'**
  String get menuNewCampaign;

  /// Short label for create new party action in menu
  ///
  /// In en, this message translates to:
  /// **'New party'**
  String get menuNewParty;

  /// No description provided for @menuNewMonster.
  ///
  /// In en, this message translates to:
  /// **'New Monster'**
  String get menuNewMonster;

  /// Section title for chapters list
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// Section title for adventures list
  ///
  /// In en, this message translates to:
  /// **'Adventures'**
  String get adventures;

  /// Section title for recent chapters list
  ///
  /// In en, this message translates to:
  /// **'Recent Chapters'**
  String get recentChapters;

  /// Section title for recent adventures list
  ///
  /// In en, this message translates to:
  /// **'Recent Adventures'**
  String get recentAdventures;

  /// Section title for recent scenes list
  ///
  /// In en, this message translates to:
  /// **'Recent Scenes'**
  String get recentScenes;

  /// Button label to create a chapter
  ///
  /// In en, this message translates to:
  /// **'Create Chapter'**
  String get createChapter;

  /// Button label to create an adventure
  ///
  /// In en, this message translates to:
  /// **'Create Adventure'**
  String get createAdventure;

  /// Button label to create a scene
  ///
  /// In en, this message translates to:
  /// **'Create Scene'**
  String get createScene;

  /// Button label to create an entity
  ///
  /// In en, this message translates to:
  /// **'Create Entity'**
  String get createEntity;

  /// Label for name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Validation message when name is not provided
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Label for kind selection
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get kind;

  /// Label for selecting a chapter
  ///
  /// In en, this message translates to:
  /// **'Select Chapter'**
  String get selectChapter;

  /// Label for selecting an adventure
  ///
  /// In en, this message translates to:
  /// **'Select Adventure'**
  String get selectAdventure;

  /// Generic cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic create action
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Shown when no current campaign is set
  ///
  /// In en, this message translates to:
  /// **'No campaign selected'**
  String get noCampaignSelected;

  /// Header title for campaign screen
  ///
  /// In en, this message translates to:
  /// **'Campaign Overview'**
  String get campaignOverview;

  /// Info shown when a campaign has no chapters
  ///
  /// In en, this message translates to:
  /// **'No chapters yet'**
  String get noChaptersYet;

  /// Info shown when a chapter has no adventures
  ///
  /// In en, this message translates to:
  /// **'No adventures yet'**
  String get noAdventuresYet;

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for description input field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for short description input field
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// Shown when no description is provided
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescriptionProvided;

  /// Label for content input field
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Shown when no content is provided
  ///
  /// In en, this message translates to:
  /// **'No content provided'**
  String get noContentProvided;

  /// Label for creating a new encounter
  ///
  /// In en, this message translates to:
  /// **'Create Encounter'**
  String get createEncounter;

  /// Title for encounter builder screen
  ///
  /// In en, this message translates to:
  /// **'Encounter Builder'**
  String get encounterBuilder;

  /// Title for initiative tracker
  ///
  /// In en, this message translates to:
  /// **'Initiative Tracker'**
  String get initiativeTracker;

  /// Label for adding a combatant to an encounter
  ///
  /// In en, this message translates to:
  /// **'Add Combatant'**
  String get addCombatant;

  /// Label for selecting a party
  ///
  /// In en, this message translates to:
  /// **'Party Selection'**
  String get partySelection;

  /// Label for custom player group option
  ///
  /// In en, this message translates to:
  /// **'Custom Player Group'**
  String get customPlayerGroup;

  /// Label for encounter difficulty
  ///
  /// In en, this message translates to:
  /// **'Encounter Difficulty'**
  String get encounterDifficulty;

  /// Label for XP budget
  ///
  /// In en, this message translates to:
  /// **'XP Budget'**
  String get xpBudget;

  /// Label for adjusted XP value
  ///
  /// In en, this message translates to:
  /// **'Adjusted XP'**
  String get adjustedXp;

  /// Easy difficulty label
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty label
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty label
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Deadly difficulty label
  ///
  /// In en, this message translates to:
  /// **'Deadly'**
  String get deadly;

  /// Trivial difficulty label
  ///
  /// In en, this message translates to:
  /// **'Trivial'**
  String get trivial;

  /// Label for challenge rating (CR)
  ///
  /// In en, this message translates to:
  /// **'Challenge Rating'**
  String get challengeRating;

  /// Label for initiative
  ///
  /// In en, this message translates to:
  /// **'Initiative'**
  String get initiative;

  /// Label for hit points (HP)
  ///
  /// In en, this message translates to:
  /// **'Hit Points'**
  String get hitPoints;

  /// Label for armor class (AC)
  ///
  /// In en, this message translates to:
  /// **'Armor Class'**
  String get armorClass;

  /// Label for conditions/status effects
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get conditions;

  /// Label for adding a condition
  ///
  /// In en, this message translates to:
  /// **'Add Condition'**
  String get addCondition;

  /// Label for next turn button
  ///
  /// In en, this message translates to:
  /// **'Next Turn'**
  String get nextTurn;

  /// Label for previous turn button
  ///
  /// In en, this message translates to:
  /// **'Previous Turn'**
  String get previousTurn;

  /// Label for combat round
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// Label for starting an encounter
  ///
  /// In en, this message translates to:
  /// **'Start Encounter'**
  String get startEncounter;

  /// Label for ending an encounter
  ///
  /// In en, this message translates to:
  /// **'End Encounter'**
  String get endEncounter;

  /// Label for ally combatant
  ///
  /// In en, this message translates to:
  /// **'Ally'**
  String get ally;

  /// Label for enemy combatant
  ///
  /// In en, this message translates to:
  /// **'Enemy'**
  String get enemy;

  /// Label for player character
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// Label for monster
  ///
  /// In en, this message translates to:
  /// **'Monster'**
  String get monster;

  /// Label for non-player character
  ///
  /// In en, this message translates to:
  /// **'NPC'**
  String get npc;

  /// Label for rolling initiative
  ///
  /// In en, this message translates to:
  /// **'Roll Initiative'**
  String get rollInitiative;

  /// Label for sorting combatants by initiative
  ///
  /// In en, this message translates to:
  /// **'Sort by Initiative'**
  String get sortByInitiative;

  /// Label for selecting from bestiary
  ///
  /// In en, this message translates to:
  /// **'From Bestiary'**
  String get fromBestiary;

  /// Label for selecting from campaign entities
  ///
  /// In en, this message translates to:
  /// **'From Campaign'**
  String get fromCampaign;

  /// Label for selecting a monster
  ///
  /// In en, this message translates to:
  /// **'Select Monster'**
  String get selectMonster;

  /// Label for selecting a party
  ///
  /// In en, this message translates to:
  /// **'Select Party'**
  String get selectParty;

  /// Message shown when no party is selected
  ///
  /// In en, this message translates to:
  /// **'No party selected'**
  String get noPartySelected;

  /// Label for party size
  ///
  /// In en, this message translates to:
  /// **'Party Size'**
  String get partySize;

  /// Label for adding a player
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// Label for player level
  ///
  /// In en, this message translates to:
  /// **'Player Level'**
  String get playerLevel;

  /// Title for share settings dialog
  ///
  /// In en, this message translates to:
  /// **'Share Settings'**
  String get shareSettings;

  /// Generic close action
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Label for Entities feature
  ///
  /// In en, this message translates to:
  /// **'Entities'**
  String get entities;

  /// Shown when no entities are found
  ///
  /// In en, this message translates to:
  /// **'No entities yet'**
  String get noEntitiesYet;

  /// Context menu option to open a link in a new window
  ///
  /// In en, this message translates to:
  /// **'Open in new window'**
  String get openInNewWindow;

  /// Label for the place type field of an Entity (kind=place)
  ///
  /// In en, this message translates to:
  /// **'Place Type'**
  String get placeType;

  /// Label for the parent place id/name of an Entity (kind=place)
  ///
  /// In en, this message translates to:
  /// **'Parent Place'**
  String get parentPlace;

  /// Label for geographic coordinates (lat/lng)
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// Label for members list (kind=group)
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// Label for an NPC/Monster stat block section
  ///
  /// In en, this message translates to:
  /// **'Stat Block'**
  String get statblock;

  /// Label for tags list/section
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Label for images section
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// Label for search field
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Label for kind filter dropdown
  ///
  /// In en, this message translates to:
  /// **'Filter by Kind'**
  String get filterByKind;

  /// Option to show all entity kinds
  ///
  /// In en, this message translates to:
  /// **'All Kinds'**
  String get allKinds;

  /// Button to clear all filters
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Message shown when no entities match the current filters
  ///
  /// In en, this message translates to:
  /// **'No entities matching filters'**
  String get noEntitiesMatchingFilters;

  /// Label for browse entities menu action
  ///
  /// In en, this message translates to:
  /// **'Browse Entities'**
  String get browseEntities;

  /// Help text for browse entities action
  ///
  /// In en, this message translates to:
  /// **'Browse all entities in the campaign'**
  String get browseAllEntities;

  /// Label for chapter filter dropdown
  ///
  /// In en, this message translates to:
  /// **'Filter by Chapter'**
  String get filterByChapter;

  /// Option to show all chapters in filter
  ///
  /// In en, this message translates to:
  /// **'All Chapters'**
  String get allChapters;

  /// Title for dashboard statistics widget
  ///
  /// In en, this message translates to:
  /// **'Dashboard Stats'**
  String get dashboardStats;

  /// Title for quick actions widget
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Title for upcoming sessions widget
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessions;

  /// Label for total campaigns count
  ///
  /// In en, this message translates to:
  /// **'Total Campaigns'**
  String get totalCampaigns;

  /// Label for total sessions count
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// Label for total parties count
  ///
  /// In en, this message translates to:
  /// **'Total Parties'**
  String get totalParties;

  /// Label for total entities count
  ///
  /// In en, this message translates to:
  /// **'Total Entities'**
  String get totalEntities;

  /// Label for upcoming sessions count
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessionsCount;

  /// Label for last activity timestamp
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// Message when there are no upcoming sessions
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions'**
  String get noUpcomingSessions;

  /// Button label to create a new campaign
  ///
  /// In en, this message translates to:
  /// **'New Campaign'**
  String get newCampaign;

  /// Button label to create a new session
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// Button label to create a new party
  ///
  /// In en, this message translates to:
  /// **'New Party'**
  String get newParty;

  /// Label for notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Description for notification settings
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get notificationsDescription;

  /// Label for privacy settings section
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacy;

  /// Description for privacy settings
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy and data'**
  String get privacyDescription;

  /// Label for analytics settings section
  ///
  /// In en, this message translates to:
  /// **'Analytics & Data'**
  String get analytics;

  /// Description for analytics settings
  ///
  /// In en, this message translates to:
  /// **'Control usage data and tracking'**
  String get analyticsDescription;

  /// Label for about section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Description for about section
  ///
  /// In en, this message translates to:
  /// **'App version, credits, and legal info'**
  String get aboutDescription;

  /// Label for app version
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// Label for reset settings action
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// Description for reset settings
  ///
  /// In en, this message translates to:
  /// **'Restore all settings to defaults'**
  String get resetSettingsDescription;

  /// Confirmation message for reset settings
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to defaults?'**
  String get resetSettingsConfirmation;

  /// Label for account section
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Description for account settings
  ///
  /// In en, this message translates to:
  /// **'Manage your account and profile'**
  String get accountDescription;

  /// Label for dangerous settings section
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// Label for share button
  ///
  /// In en, this message translates to:
  /// **'share'**
  String get share;

  /// Generic duplicate action label
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// Generic archive action label
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// Generic export action label
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Section header for selecting the entity origin (campaign/chapter/adventure/scene)
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// Label for selecting a scene
  ///
  /// In en, this message translates to:
  /// **'Select Scene'**
  String get selectScene;

  /// Label for entity ID metadata
  ///
  /// In en, this message translates to:
  /// **'Entity ID'**
  String get entityId;

  /// Label for entity revision number
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get revision;

  /// Label for created timestamp
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Label for updated timestamp
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
