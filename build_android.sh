#!/bin/bash

# Step 1: Increment the build number in pubspec.yaml
echo "Incrementing build number..."

# Find the current build number from pubspec.yaml
CURRENT_BUILD_NUMBER=$(grep -E 'version: [0-9.]+\+[0-9]+' pubspec.yaml | sed 's/.*+\([0-9]*\)/\1/')
NEW_BUILD_NUMBER=$((CURRENT_BUILD_NUMBER + 1))

# Update pubspec.yaml with the new build number
sed -i "" "s/\(version: [0-9.]*+\)[0-9]*/\1$NEW_BUILD_NUMBER/" pubspec.yaml

echo "Updated build number to $NEW_BUILD_NUMBER"

# Step 2: Build release bundles
echo "Building release bundles..."

# Build Android app bundle
flutter build appbundle --release
if [ $? -ne 0 ]; then
  echo "Failed to build Android app bundle"
  exit 1
fi

# Build iOS release
# flutter build ipa
# if [ $? -ne 0 ]; then
#   echo "Failed to build iOS release"
#   exit 1
# fi

echo "Builds completed successfully."

# Optional: Commit changes (uncomment if needed)
# git add pubspec.yaml
# git commit -m "Increment build number to $NEW_BUILD_NUMBER"
# git push origin <your-branch>

echo "Script finished successfully."
