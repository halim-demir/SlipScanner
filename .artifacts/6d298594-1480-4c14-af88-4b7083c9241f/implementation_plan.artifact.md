# Professional Project Refactoring Plan

This plan aims to professionalize the "Slip Scanner" project by improving the architecture, cleaning up redundant code, and fixing potential bugs.

## User Review Required

> [!IMPORTANT]
> I will be refactoring the single-file structure into a more scalable directory structure. This will involve moving code from `lib/main.dart` into specialized folders like `lib/core` and `lib/features`.

> [!NOTE]
> I noticed Firebase dependencies in your Android build files and a `google-services.json` file, but `firebase_core` is missing from `pubspec.yaml` and it's not initialized in `main.dart`. I will add it to ensure your project is professionally integrated.

## Proposed Changes

### [Core & Infrastructure]
Clean up the project configuration and add missing vital dependencies.

#### [MODIFY] [pubspec.yaml](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/pubspec.yaml)
- Remove excessive boilerplate comments.
- Add `firebase_core` and `firebase_analytics` to match the Android configuration.
- Clean up unused assets/fonts sections.

#### [MODIFY] [main.dart](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/lib/main.dart)
- Initialize Firebase.
- Improve error handling for camera initialization.
- Move the UI into separate files.

### [Architecture & Directory Structure]
Create a professional folder structure.

#### [NEW] [app.dart](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/lib/app.dart)
- Move `SlipScannerApp` widget here.
- Centralize `ThemeData` configuration.

#### [NEW] [home_screen.dart](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/lib/features/home/presentation/screens/home_screen.dart)
- Move `MainScreen` and related logic here.
- Extract sub-widgets (Header, NavBar, etc.) into separate files or methods for readability.

#### [NEW] [camera_service.dart](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/lib/core/services/camera_service.dart)
- Encapsulate camera initialization and management to remove global variables.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting errors or warnings.
- Run `flutter build bundle` to verify Dart compilation.

### Manual Verification
- Verify the app launches correctly.
- Ensure camera preview works and gallery picker functions as expected.
- Check that the UI remains consistent with the previous version but with cleaner code.
