#!/bin/bash

echo "Starting manual Firebase setup..."

# Check if Google services JSON exists
if [ ! -f "android/app/google-services.json" ]; then
  echo "⚠️ Warning: google-services.json not found!"
  echo "Please download it from Firebase console and place it in android/app/ directory"
else
  echo "✅ Found google-services.json"
fi

# Check if GoogleService-Info.plist exists
if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
  echo "⚠️ Warning: GoogleService-Info.plist not found!"
  echo "Please download it from Firebase console and place it in ios/Runner/ directory"
else
  echo "✅ Found GoogleService-Info.plist"
fi

# Run flutter pub get to update dependencies
echo "Updating Flutter dependencies..."
flutter pub get

# Install pods for iOS
if [ -d "ios" ]; then
  echo "Installing iOS pods..."
  cd ios && pod install && cd ..
  echo "iOS pods installed"
fi

echo "Firebase setup completed!"
echo "Note: Make sure you have added the actual configuration files from Firebase console"
echo "For Android: google-services.json in android/app/"
echo "For iOS: GoogleService-Info.plist in ios/Runner/"
