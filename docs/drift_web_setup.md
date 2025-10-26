# Web Assets Setup for Drift WASM

## Required Files

For web support with WASM backend, you need two files in the `/web` directory:

1. **sqlite3.wasm** - SQLite compiled to WebAssembly
2. **drift_worker.dart.js** - Drift worker script

## How to Obtain These Files

### Option 1: From drift package (Recommended)

After running `flutter pub get`, the files will be available in your pub cache:

```bash
# Find your Flutter pub cache location
flutter pub cache list

# The files are typically at:
# ~/.pub-cache/hosted/pub.dev/drift-X.X.X/web/

# Copy them to your web directory:
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/sqlite3.wasm ./web/
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/drift_worker.dart.js ./web/
```

### Option 2: Build from source

```bash
cd moonforge
flutter pub get
dart run drift_dev web
```

This will generate the files in the `web` directory.

### Option 3: Manual download

Download from the drift repository releases:
- https://github.com/simolus3/drift/tree/develop/drift/web

## MIME Type Configuration

Ensure `sqlite3.wasm` is served with `Content-Type: application/wasm`.

### For Firebase Hosting (firebase.json):

```json
{
  "hosting": {
    "public": "build/web",
    "headers": [
      {
        "source": "**/*.wasm",
        "headers": [
          {
            "key": "Content-Type",
            "value": "application/wasm"
          }
        ]
      }
    ]
  }
}
```

## Optional: COOP/COEP Headers for OPFS Performance

For better performance using OPFS (Origin Private File System), add these headers:

```json
{
  "hosting": {
    "headers": [
      {
        "source": "**",
        "headers": [
          {
            "key": "Cross-Origin-Opener-Policy",
            "value": "same-origin"
          },
          {
            "key": "Cross-Origin-Embedder-Policy",
            "value": "require-corp"
          }
        ]
      }
    ]
  }
}
```

**Note:** These headers may affect Firebase Auth. Test thoroughly before deploying to production.

## Verification

After placing the files, you should see this in the web inspector console when running the app:
```
✓ Drift web WASM backend: WasmDatabase
```

If you see warnings about missing features, consider enabling COOP/COEP headers.
