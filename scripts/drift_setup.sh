#!/bin/bash
# Script to generate Drift code and download web assets

set -e

echo "=========================================="
echo "Drift Code Generation & Web Assets Setup"
echo "=========================================="
echo ""

# Step 1: Check Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Step 2: Navigate to moonforge directory
cd moonforge

# Step 3: Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Step 4: Run build_runner
echo ""
echo "🔨 Generating Drift code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Step 5: Check if web assets exist
echo ""
echo "🌐 Checking web assets..."

WEB_ASSETS_NEEDED=false

if [ ! -f "web/sqlite3.wasm" ]; then
    echo "⚠️  sqlite3.wasm not found in web/"
    WEB_ASSETS_NEEDED=true
fi

if [ ! -f "web/drift_worker.dart.js" ]; then
    echo "⚠️  drift_worker.dart.js not found in web/"
    WEB_ASSETS_NEEDED=true
fi

if [ "$WEB_ASSETS_NEEDED" = true ]; then
    echo ""
    echo "📥 Attempting to download web assets..."
    
    # Try using drift_dev web command
    if dart run drift_dev web 2>&1 | grep -q "success\|copied\|generated"; then
        echo "✓ Web assets generated successfully"
    else
        echo ""
        echo "⚠️  Automated web asset download failed."
        echo ""
        echo "Please manually copy the files:"
        echo "1. Find your pub cache:"
        echo "   flutter pub cache list"
        echo ""
        echo "2. Copy files from drift package:"
        echo "   cp ~/.pub-cache/hosted/pub.dev/drift-*/web/sqlite3.wasm ./web/"
        echo "   cp ~/.pub-cache/hosted/pub.dev/drift-*/web/drift_worker.dart.js ./web/"
        echo ""
        echo "Or download from:"
        echo "   https://github.com/simolus3/drift/tree/develop/drift/web"
    fi
else
    echo "✓ Web assets already present"
fi

echo ""
echo "=========================================="
echo "✅ Code generation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review generated files:"
echo "   - lib/data/drift/app_database.g.dart"
echo "   - lib/data/drift/dao/campaigns_dao.g.dart"
echo "   - lib/data/drift/dao/outbox_dao.g.dart"
echo ""
echo "2. Run tests:"
echo "   flutter test test/data/drift/"
echo "   flutter test test/data/repo/"
echo ""
echo "3. For web deployment, ensure firebase.json has:"
echo '   "headers": [{"source": "**/*.wasm", "headers": [{"key": "Content-Type", "value": "application/wasm"}]}]'
echo ""
echo "See DRIFT_USAGE.md for full documentation."
