import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  List<CameraDescription> _cameras = [];
  List<CameraDescription> get cameras => _cameras;

  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
      _cameras = [];
    }
  }

  bool get hasCameras => _cameras.isNotEmpty;
}
