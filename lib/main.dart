import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/services/camera_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bildirim Çubuğu Gizleme
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Dikey Sabitleme
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const SlipScannerApp());
}

