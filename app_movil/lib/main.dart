import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    if (cameras.isEmpty) {
      print('No se encontraron cámaras disponibles');
    } else {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Ejemplo de Cámara')),
          body: AspectRatio(
            aspectRatio: .7,
            child: CameraPreview(controller),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.camera),
            onPressed: () async {
             try {
              final image = await controller.takePicture();
  // final pickedImage =
  //     await ImagePicker().getImage(source: ImageSource.gallery);
  // if (pickedImage != null) {
    final inputImage =
        InputImage.fromFilePath(image.path);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognisedText =
        await textRecognizer.processImage(inputImage);
    String extractedText = recognisedText.text;

    print('Texto reconocido: $extractedText');

    RegExp nombreRegex = RegExp(r'NOMBRE\n(.+?)\n(.+?)\n(.+?)\n');
    RegExp domicilioRegex = RegExp(r'DOMICILIO\n(.+?)\n(.+?)\n(.+?)\n');
    RegExp curpRegex = RegExp(r'CURP (.+)');

    String? nombre = nombreRegex.firstMatch(extractedText)?.group(1);
    String? apellidoPaterno = nombreRegex.firstMatch(extractedText)?.group(2);
    String? apellidoMaterno = nombreRegex.firstMatch(extractedText)?.group(3);
    String? domicilio = domicilioRegex.firstMatch(extractedText)?.group(1);
    String? colonia = domicilioRegex.firstMatch(extractedText)?.group(2);
    String? codigoPostal = domicilioRegex.firstMatch(extractedText)?.group(3);
    String? curp = curpRegex.firstMatch(extractedText)?.group(1);

    print('Nombre: $nombre $apellidoPaterno $apellidoMaterno');
    print('Domicilio: $domicilio $colonia $codigoPostal');
    print('CURP: $curp');

    textRecognizer.close();
  // }
} catch (e) {
  print(e);
}




            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}










