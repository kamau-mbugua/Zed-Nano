#!/bin/bash

# Add Flutter and Dart to PATH
export PATH="$HOME/.pub-cache/bin:$PATH"

# Find the location of dart executable from fvm
DART_PATH=$(which dart || echo "")

if [ -z "$DART_PATH" ]; then
  # Try to find dart in common FVM locations
  if [ -f "$HOME/fvm/default/bin/dart" ]; then
    DART_PATH="$HOME/fvm/default/bin/dart"
  elif [ -f "$HOME/.fvm/default/bin/dart" ]; then
    DART_PATH="$HOME/.fvm/default/bin/dart"
  else
    echo "Error: Could not find dart executable. Please make sure Flutter/Dart is installed."
    exit 1
  fi
fi

echo "Using Dart at: $DART_PATH"

# Run FlutterFire configuration
$DART_PATH pub global run flutterfire_cli:flutterfire configure --project=zed-app-444bf

# Check if the configuration was successful
if [ $? -eq 0 ]; then
  echo "Firebase configuration completed successfully!"
else
  echo "Firebase configuration failed. Please check the error messages above."
fi
