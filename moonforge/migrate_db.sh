#!/bin/bash
# Database Migration Helper Script
# This script helps with the database migration process

set -e

echo "🔄 Moonforge Database Migration Helper"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the moonforge directory."
    exit 1
fi

echo "📦 Step 1: Installing dependencies..."
flutter pub get

echo ""
echo "🏗️  Step 2: Running code generation..."
echo "This will generate Drift database code and DAOs..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Code generation completed successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Check the generated files in lib/data/db/ for any issues"
    echo "2. Update your main.dart to use the new database (see MIGRATION_PLAN.md)"
    echo "3. Remove old implementation files:"
    echo "   - lib/data/drift/"
    echo "   - lib/data/firebase/"
    echo "   - lib/data/repo/"
    echo "   - lib/data/sync/"
    echo "   - lib/data/drift_providers.dart"
    echo "4. Rename lib/data/repo_new/ to lib/data/repo/"
    echo "5. Update UI code to use new repositories"
    echo "6. Test thoroughly!"
    echo ""
    echo "For detailed instructions, see MIGRATION_PLAN.md"
else
    echo ""
    echo "❌ Code generation failed!"
    echo "Check the error messages above and fix any issues."
    echo "Common issues:"
    echo "- Missing imports in table definitions"
    echo "- Type mismatches in converters"
    echo "- Conflicting generated files (use --delete-conflicting-outputs)"
    exit 1
fi
