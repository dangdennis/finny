# Finny App

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## First-Time Setup

1. Get instated as team member on Apple App Store Connect (get dev certificates).
2. `flutter run` to run the app. This should also install any ios/android dependencies.

## Development
- `flutter run` to run the app.
- `flutter clean` to clean all build artifacts in case some weird dependency issue arises.
- `make f` to fix format and lint
- `make a` to typecheck

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## Release for iOS

To build this Flutter project for iOS:

1. Ensure you have Xcode, Flutter SDK, and CocoaPods installed.
2. Execute `flutter build ios --release` to compile the project for iOS.
3. In Xcode, Archive and distribute the app.
