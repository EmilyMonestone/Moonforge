#!/bin/bash

# Script to generate Dart code for Moonforge
# This runs build_runner to generate freezed and json_serializable code

set -e

echo "======================================"
echo "Moonforge Code Generation Script"
echo "======================================"
echo ""

# Check if we're in the moonforge directory
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found. Please run this script from the moonforge directory."
    exit 1
fi

echo "Step 1: Getting dependencies..."
flutter pub get

echo ""
echo "Step 2: Running build_runner..."
echo "This will generate .freezed.dart and .g.dart files"
dart run build_runner build --delete-conflicting-outputs

echo ""
echo "======================================"
echo "Code generation completed successfully!"
echo "======================================"
echo ""
echo "Generated files include:"
echo "  - entity_with_origin.freezed.dart"
echo "  - entity_with_origin.g.dart"
echo "  - Updated .freezed.dart and .g.dart files for models with new entityIds field"
echo ""
echo "You can now run the app with: flutter run"
