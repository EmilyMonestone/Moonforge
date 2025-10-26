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

  /// Label for Chapter feature
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

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
