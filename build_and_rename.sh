#!/bin/bash

# Flutter Build and Rename Script
# This script builds the Flutter app and renames the output files with custom naming

set -e  # Exit on any error

echo "🏗️  Flutter Build and Rename Script"
echo "===================================="

# Function to get version info
get_version_info() {
    VERSION_NAME=$(grep "version:" pubspec.yaml | cut -d ' ' -f2 | cut -d '+' -f1)
    VERSION_CODE=$(grep "version:" pubspec.yaml | cut -d '+' -f2)
    echo "Version: $VERSION_NAME ($VERSION_CODE)"
}

# Function to build and rename APK
build_apk() {
    local flavor=$1
    local target=$2
    local build_type=$3
    
    echo ""
    echo "📱 Building APK: $flavor + $build_type"
    echo "Target: $target"
    
    # Build the APK
    flutter build apk --flavor "$flavor" --target "$target" --"$build_type"
    
    # Get version info
    get_version_info
    
    # Define paths
    local original_path="build/app/outputs/flutter-apk/app-$flavor-$build_type.apk"
    local new_name="ZN_${flavor}_${build_type}_v${VERSION_NAME}_${VERSION_CODE}.apk"
    local new_path="build/app/outputs/flutter-apk/$new_name"
    
    # Rename the file
    if [ -f "$original_path" ]; then
        mv "$original_path" "$new_path"
        echo "✅ APK renamed to: $new_name"
        echo "📍 Location: $new_path"
        
        # Show file size
        local size=$(du -h "$new_path" | cut -f1)
        echo "📦 Size: $size"
    else
        echo "❌ Original APK not found: $original_path"
        return 1
    fi
}

# Function to build and rename AAB
build_aab() {
    local flavor=$1
    local target=$2
    local build_type=$3
    
    echo ""
    echo "📱 Building AAB: $flavor + $build_type"
    echo "Target: $target"
    
    # Build the AAB
    flutter build appbundle --flavor "$flavor" --target "$target" --"$build_type"
    
    # Get version info
    get_version_info
    
    # Define paths
    local original_path="build/app/outputs/bundle/${flavor}Release/app-$flavor-$build_type.aab"
    local new_name="ZN_${flavor}_${build_type}_v${VERSION_NAME}_${VERSION_CODE}.aab"
    local new_path="build/app/outputs/bundle/${flavor}Release/$new_name"
    
    # Rename the file
    if [ -f "$original_path" ]; then
        mv "$original_path" "$new_path"
        echo "✅ AAB renamed to: $new_name"
        echo "📍 Location: $new_path"
        
        # Show file size
        local size=$(du -h "$new_path" | cut -f1)
        echo "📦 Size: $size"
    else
        echo "❌ Original AAB not found: $original_path"
        return 1
    fi
}

# Main script logic
case "$1" in
    "dev-apk")
        build_apk "development" "lib/main_development.dart" "release"
        ;;
    "dev-debug-apk")
        build_apk "development" "lib/main_development.dart" "debug"
        ;;
    "dev-aab")
        build_aab "development" "lib/main_development.dart" "release"
        ;;
    "staging-apk")
        build_apk "staging" "lib/main_staging.dart" "release"
        ;;
    "staging-aab")
        build_aab "staging" "lib/main_staging.dart" "release"
        ;;
    "prod-apk")
        build_apk "production" "lib/main_production.dart" "release"
        ;;
    "prod-aab")
        build_aab "production" "lib/main_production.dart" "release"
        ;;
    *)
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Available commands:"
        echo "  dev-apk       - Build development APK (release)"
        echo "  dev-debug-apk - Build development APK (debug)"
        echo "  dev-aab       - Build development AAB (release)"
        echo "  staging-apk   - Build staging APK (release)"
        echo "  staging-aab   - Build staging AAB (release)"
        echo "  prod-apk      - Build production APK (release)"
        echo "  prod-aab      - Build production AAB (release)"
        echo ""
        echo "Example:"
        echo "  $0 dev-apk    # Builds development flavor APK with release build type"
        ;;
esac
