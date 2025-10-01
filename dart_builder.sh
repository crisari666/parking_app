#!/bin/bash

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
# flutter pub get

# flutter pub run build_runner clean
# flutter pub get