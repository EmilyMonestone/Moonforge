#!/bin/bash
# Helper script for Moonforge release tasks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Fastforge is installed
check_fastforge() {
    if ! command -v fastforge &> /dev/null; then
        print_error "Fastforge is not installed."
        print_info "Install it with: dart pub global activate fastforge"
        return 1
    fi
    print_info "Fastforge is installed: $(fastforge --version 2>&1 | head -1)"
}

# Get current version from pubspec.yaml
get_version() {
    cd "$REPO_ROOT/moonforge"
    VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
    echo "$VERSION"
}

# Build local packages
build_local() {
    print_info "Building packages locally..."
    cd "$REPO_ROOT"
    
    PLATFORM=${1:-"all"}
    
    case $PLATFORM in
        windows)
            print_info "Building Windows EXE..."
            fastforge package --platform windows --target exe
            ;;
        macos)
            print_info "Building macOS DMG..."
            fastforge package --platform macos --target dmg
            ;;
        linux)
            print_info "Building Linux AppImage and DEB..."
            fastforge package --platform linux --target appimage
            fastforge package --platform linux --target deb
            ;;
        all)
            print_info "Building for all platforms (as configured)..."
            fastforge release --name production
            ;;
        *)
            print_error "Unknown platform: $PLATFORM"
            print_info "Usage: $0 build [windows|macos|linux|all]"
            return 1
            ;;
    esac
    
    print_info "Build complete! Check the dist/ directory."
}

# Create a release tag
create_release_tag() {
    VERSION=$(get_version)
    print_info "Current version in pubspec.yaml: $VERSION"
    
    read -p "Create release tag v$VERSION? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warn "Aborted."
        return 1
    fi
    
    cd "$REPO_ROOT"
    
    # Check if tag already exists
    if git rev-parse "v$VERSION" >/dev/null 2>&1; then
        print_error "Tag v$VERSION already exists!"
        return 1
    fi
    
    # Create and push tag
    git tag -a "v$VERSION" -m "Release version $VERSION"
    print_info "Tag v$VERSION created."
    
    read -p "Push tag to GitHub? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin "v$VERSION"
        print_info "Tag pushed to GitHub. GitHub Actions will build and release."
        print_info "Monitor progress at: https://github.com/EmilyMoonstone/Moonforge/actions"
    else
        print_warn "Tag not pushed. Push manually with: git push origin v$VERSION"
    fi
}

# Update appcast files
update_appcast() {
    VERSION=$(get_version)
    print_info "Update appcast files for version $VERSION"
    print_warn "This requires manual editing!"
    
    print_info "Files to update:"
    echo "  - appcast/appcast.xml (macOS)"
    echo "  - appcast/appcast.json (Windows)"
    
    print_info "Instructions:"
    echo "  1. Add new release entry to both files"
    echo "  2. Update version, URLs, and file sizes"
    echo "  3. Commit and push the changes"
    
    print_info "See appcast/README.md for detailed instructions"
    
    read -p "Open appcast directory? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$REPO_ROOT/appcast"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open .
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open . 2>/dev/null || echo "Open manually: $REPO_ROOT/appcast"
        else
            echo "Open manually: $REPO_ROOT/appcast"
        fi
    fi
}

# Show help
show_help() {
    cat << EOF
Moonforge Release Helper Script

Usage: $0 <command> [options]

Commands:
  check           Check if Fastforge is installed
  version         Show current version from pubspec.yaml
  build [target]  Build packages locally
                  Targets: windows, macos, linux, all (default: all)
  tag             Create and optionally push a release tag
  appcast         Guide for updating appcast files
  help            Show this help message

Examples:
  $0 check                # Check Fastforge installation
  $0 version              # Show current version
  $0 build windows        # Build Windows package only
  $0 build                # Build all configured packages
  $0 tag                  # Create release tag from current version
  $0 appcast              # Update appcast files for new release

EOF
}

# Main script logic
case "${1:-help}" in
    check)
        check_fastforge
        ;;
    version)
        print_info "Current version: $(get_version)"
        ;;
    build)
        check_fastforge || exit 1
        build_local "${2:-all}"
        ;;
    tag)
        create_release_tag
        ;;
    appcast)
        update_appcast
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
