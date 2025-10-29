# Localization (i18n)

Moonforge supports multiple languages using Flutter's localization system.

## Supported Languages

- English (en)
- German (de)

## Adding New Strings

1. Add to `lib/l10n/app_en.arb`:

```json
{
  "myNewString": "Hello World",
  "@myNewString": {
    "description": "Greeting message"
  }
}
```

2. Add translation to `lib/l10n/app_de.arb`:

```json
{
  "myNewString": "Hallo Welt"
}
```

3. Run code generation:

```bash
flutter pub get
```

4. Use in code:

```dart
final localizations = AppLocalizations.of(context)!;
Text(localizations.myNewString)
```

## Plural Forms

```json
{
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

## Configuration

See `l10n.yaml` in project root.

## Related Documentation

- [Code Generation](code-generation.md)
- [Getting Started](../getting-started.md)
