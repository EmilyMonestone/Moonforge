# Appcast Files for Auto-Updates

This directory contains the appcast feed files used by the auto_updater to check for new versions of Moonforge.

## Files

- **appcast.xml** - Feed for macOS (Sparkle framework)
- **appcast.json** - Feed for Windows (WinSparkle)

## How It Works

When Moonforge launches on a desktop platform (Windows or macOS), it:
1. Checks the appropriate appcast file for the latest version
2. Compares it to the current installed version
3. If a newer version is available, prompts the user to update
4. Downloads and installs the update

## Updating for a New Release

Every time you publish a new release, you must update these files:

### 1. Publish Your Release First

Complete the release process and upload your builds to GitHub Releases.

### 2. Update appcast.xml (macOS)

Add a new `<item>` entry at the top of the feed (inside `<channel>`):

```xml
<item>
  <title>Version 0.2.0</title>
  <link>https://github.com/EmilyMoonstone/Moonforge/releases/tag/v0.2.0</link>
  <description><![CDATA[
    <h2>What's New in Version 0.2.0</h2>
    <ul>
      <li>New feature 1</li>
      <li>Bug fix 2</li>
      <li>Improvement 3</li>
    </ul>
  ]]></description>
  <pubDate>Mon, 01 Jan 2024 12:00:00 +0000</pubDate>
  <sparkle:version>0.2.0</sparkle:version>
  <sparkle:shortVersionString>0.2.0</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>10.13</sparkle:minimumSystemVersion>
  <enclosure 
    url="https://github.com/EmilyMoonstone/Moonforge/releases/download/v0.2.0/Moonforge-0.2.0-macos.dmg" 
    length="52428800" 
    type="application/octet-stream" />
</item>
```

**Important**:
- Update the version number in all places
- Set the correct file size in `length` (in bytes)
- Update the download URL to match your release
- Use RFC 822 date format for `pubDate`

To get the file size:
```bash
ls -l dist/Moonforge-0.2.0-macos.dmg | awk '{print $5}'
```

### 3. Update appcast.json (Windows)

Add a new entry to the `items` array at the beginning:

```json
{
  "title": "Version 0.2.0",
  "version": "0.2.0",
  "description": "<h2>What's New in Version 0.2.0</h2><ul><li>New feature 1</li><li>Bug fix 2</li><li>Improvement 3</li></ul>",
  "pubDate": "2024-01-01T12:00:00Z",
  "link": "https://github.com/EmilyMoonstone/Moonforge/releases/tag/v0.2.0",
  "url": "https://github.com/EmilyMoonstone/Moonforge/releases/download/v0.2.0/Moonforge-0.2.0-windows.exe"
}
```

**Important**:
- Update the version number
- Update the download URL to match your release
- Use ISO 8601 date format for `pubDate`

### 4. Commit and Push

```bash
git add appcast/
git commit -m "Update appcast for v0.2.0"
git push origin main
```

## Testing

After updating the appcast files:

1. Install the previous version of Moonforge
2. Run the application
3. It should automatically detect the new version and offer to update
4. Verify the update downloads and installs correctly

## Code Signing (Production)

For production releases, especially on macOS, you should sign your releases:

### macOS Signing

1. Get a Developer ID certificate from Apple
2. Sign your DMG file
3. Generate a Sparkle signature and add it to the appcast:
   ```xml
   <enclosure 
     url="..." 
     length="..." 
     type="application/octet-stream"
     sparkle:edSignature="YOUR_SIGNATURE_HERE" />
   ```

See the [Fastforge Setup Guide](../docs/fastforge_setup.md#code-signing) for detailed instructions.

### Windows Signing

Windows code signing is optional but recommended to avoid "Unknown Publisher" warnings.

## Feed URLs

The appcast files must be publicly accessible. Current configuration uses:

- macOS: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.xml`
- Windows: `https://raw.githubusercontent.com/EmilyMoonstone/Moonforge/main/appcast/appcast.json`

These URLs are configured in `moonforge/lib/core/services/auto_updater_service.dart`.

## Troubleshooting

### Updates Not Detected

- Verify appcast files are accessible at the URLs above
- Check that the version in the appcast is higher than the installed version
- Review logs in the application console

### Download Fails

- Ensure the download URL is correct and the file is accessible
- Check file permissions on GitHub Releases
- Verify file size if specified

### macOS: "App is damaged"

- The app needs to be signed with a Developer ID certificate
- Consider notarizing the app for macOS 10.15+

## Additional Resources

- [Sparkle Documentation](https://sparkle-project.org/)
- [WinSparkle Documentation](https://winsparkle.org/)
- [auto_updater Package](https://pub.dev/packages/auto_updater)
- [Full Setup Guide](../docs/fastforge_setup.md)
