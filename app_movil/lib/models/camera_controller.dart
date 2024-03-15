import 'package:camera/camera.dart';

class CameraControllerProvider {
  static List<CameraDescription> cameras = [];

  static Future<void> initializeCameras() async {
    cameras = await availableCameras();
  }
}
