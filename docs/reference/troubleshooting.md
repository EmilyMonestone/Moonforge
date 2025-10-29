# Troubleshooting

Common issues and solutions.

## Build Issues

### Code Generation Fails

```bash
dart run build_runner clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Import Errors

- Restart IDE/analyzer
- Run `flutter pub get`
- Check `part` directives

### Platform Build Fails

See [Platform-Specific Guide](../development/platform-specific.md) for platform requirements.

## Runtime Issues

### Firebase Connection Issues

- Check `.env` file has correct API key
- Verify Firebase project configuration
- Check internet connection

### Deep Links Not Working

See [Testing Deep Links](../development/testing-deep-links.md) for platform-specific troubleshooting.

### Sync Issues

- Check network connection
- Verify Firebase rules allow access
- Check console for sync errors
- Clear local database: `await database.delete()`

## Development Issues

### Hot Reload Not Working

- Full restart: `R` in terminal
- Clean and rebuild: `flutter clean && flutter pub get`

### Slow Performance

- Use `--profile` mode for profiling
- Check for excessive rebuilds
- Use `const` constructors where possible

## Database Issues

### Migration Fails

- Check schema version is incremented
- Verify migration logic
- Test with in-memory database first

### Data Not Syncing

- Check `LocalMetas` for dirty flags
- Verify `OutboxOps` table for pending operations
- Check Firebase console for errors

## Related Documentation

- [Getting Started](../getting-started.md)
- [Code Generation](../development/code-generation.md)
- [Testing](../development/testing.md)
