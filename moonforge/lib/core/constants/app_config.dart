/// This file centralizes configuration information for the Sandi app.
/// It contains both version information and app description.
/// Update this file, then run config_app.ps1 to update all references.
library;

/// Major version number
const int versionMajor = 0;

/// Minor version number
const int versionMinor = 6;

/// Patch version number
const int versionPatch = 0;

/// Build number
const int versionBuild = 1;

/// App description
const String appDescription =
    'Moonforge is an campaign manager for Dungeons & Dragons 5th Edition.';

/// Returns the version string in format "major.minor.patch+build"
/// Used for pubspec.yaml version
String get pubspecVersion =>
    '$versionMajor.$versionMinor.$versionPatch+$versionBuild';

/// Returns the version string in format "major.minor.patch.build"
/// Used for MSIX version
String get msixVersion =>
    '$versionMajor.$versionMinor.$versionPatch.$versionBuild';

/// Returns the version string in format "major.minor.patch"
/// Used for PKGBUILD version
String get pkgbuildVersion => '$versionMajor.$versionMinor.$versionPatch';

/// Returns the version string in format "vMajor.Minor.Patch (Build)"
/// Used for display in the app
String get displayVersion =>
    'v$versionMajor.$versionMinor.$versionPatch (Build $versionBuild)';

/// Returns the app description
String get appDescriptionText => appDescription;
