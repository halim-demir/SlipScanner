import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription> cameras = [];

  bool get hasCameras => cameras.isNotEmpty;

  Future<bool> ensurePermissions() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    return true;
  }

  // Initialize available cameras and controller (first camera)
  Future<void> initialize({ResolutionPreset preset = ResolutionPreset.high}) async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras.first, preset, enableAudio: false);
      await controller!.initialize();
    }
  }

  bool get isInitialized => controller != null && controller!.value.isInitialized;

  // Take picture and return XFile (stored in temporary directory by default)
  Future<XFile> takePicture() async {
    final c = controller;
    if (c == null || !c.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    return await c.takePicture();
  }

  // Take picture and save into app documents/photos directory. Returns saved path.
  Future<String> takePictureAndSave() async {
    final c = controller;
    if (c == null || !c.value.isInitialized) {
      throw Exception('Camera not initialized');
    }


    final XFile xfile = await c.takePicture();

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDocDir.path, 'photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    //Dosya adı tarih saat şeklinde oluşturulur
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(xfile.path)}';
    final savedPath = p.join(photosDir.path, fileName);

    await xfile.saveTo(savedPath);

    return savedPath;
  }

  void dispose() {
    controller?.dispose();
    controller = null;
  }
}