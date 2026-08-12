# Modern Multi-Platform UI with Camera and Image Picker

This plan transforms the current Flutter application into a professional, multi-platform app with a modern interface. It includes a main screen that integrates both camera functionality and an image picker, navigable via a sleek bottom navigation bar.

## User Review Required

> [!IMPORTANT]
> The camera functionality requires physical hardware. For testing on emulators, ensure camera support is enabled.
> The initial screen will request camera permissions immediately upon startup to provide the "camera-first" experience requested.

## Proposed Changes

### [Core Dependencies]

#### [MODIFY] [pubspec.yaml](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/pubspec.yaml)
- Add `camera`, `image_picker`, `google_fonts`, `permission_handler`, and `lucide_icons`.

---

### [Platform Configuration]

#### [MODIFY] [AndroidManifest.xml](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/android/app/src/main/AndroidManifest.xml)
- Add `CAMERA` and `STORAGE` permissions.

#### [MODIFY] [Info.plist](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/ios/Runner/Info.plist)
- Add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`.

---

### [Application UI & Logic]

#### [MODIFY] [main.dart](file:///C:/Users/abdlh/AndroidStudioProjects/slipscanner/lib/main.dart)
- Implement `MyApp` with Material 3 and `GoogleFonts`.
- Create `MainScreen` as the primary container.
- Implement `CameraView` for the default tab.
- Implement `GalleryView` for the image picker tab.
- Design a custom, modern `BottomNavigationBar`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting errors.
- (Optional) Implement a simple widget test for the navigation bar.

### Manual Verification
- Deploy to an Android device/emulator.
- Verify that the camera opens automatically on launch.
- Verify that switching to the "Gallery" tab works and allows image selection.
- Check the UI responsiveness and theme consistency.
