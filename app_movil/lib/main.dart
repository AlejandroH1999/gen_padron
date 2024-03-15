import 'package:flutter/material.dart';
import 'package:patron/models/camera_controller.dart';
import 'package:patron/screens/camera_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CameraControllerProvider.initializeCameras();
  runApp(const CameraApp());
}


// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';

// List<CameraDescription> cameras = [];

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(const CameraApp());
// }

// class CameraApp extends StatefulWidget {
//   const CameraApp({Key? key}) : super(key: key);

//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;

//   final TextEditingController nombreController = TextEditingController();
//   final TextEditingController apellidoPaternoController =
//       TextEditingController();
//   final TextEditingController apellidoMaternoController =
//       TextEditingController();
//   final TextEditingController domicilioController = TextEditingController();
//   final TextEditingController coloniaController = TextEditingController();
//   final TextEditingController seccionController = TextEditingController();
//   final TextEditingController curpController = TextEditingController();

//   bool isDetecting = false;

//   @override
//   void initState() {
//     super.initState();
//     if (cameras.isEmpty) {
//       print('No se encontraron cámaras disponibles');
//     } else {
//       controller = CameraController(cameras[0], ResolutionPreset.high);
//       controller.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       });
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller.value.isInitialized) {
//       return MaterialApp(
//         home: Scaffold(
//           appBar: AppBar(title: const Text('captura de datos')),
//           body: Column(
//             children: [
//               Stack(
//                 children: [
//                   AspectRatio(
//                     aspectRatio:
//                         3 / 2, // Relación de aspecto 2:3 común en las cámaras
//                     child: CameraPreview(controller),
//                   ),
//                   Positioned.fill(
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 16),
//                         child: isDetecting
//                             ? Text(
//                                 'Detectando credencial...',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )
//                             : SizedBox.shrink(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       _buildTextField(
//                           "Apellido Paterno", apellidoPaternoController),
//                       _buildTextField(
//                           "Apellido Materno", apellidoMaternoController),
//                       _buildTextField("Nombre", nombreController),
//                       _buildTextField("Domicilio", domicilioController),
//                       _buildTextField("Colonia", coloniaController),
//                       _buildTextField("Sección", seccionController),
//                       _buildTextField("CURP", curpController),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             child: const Icon(Icons.camera),
//             onPressed: () async {
//               try {
//                 setState(() {
//                   isDetecting = true;
//                 });

//                 final image = await controller.takePicture();
//                 final inputImage = InputImage.fromFilePath(image.path);
//                 final textRecognizer = GoogleMlKit.vision.textRecognizer();
//                 final recognisedText =
//                     await textRecognizer.processImage(inputImage);
//                 String extractedText = recognisedText.text;
//                 print(extractedText);

//                 RegExp nombreRegex = RegExp(r'NOMBRE\n(.+?)\n(.+?)\n(.+?)\n');
//                 RegExp domicilioRegex =
//                     RegExp(r'DOMICILIO\n(.+?)\n(.+?)\n(.+?)\n');
//                 RegExp curpRegex = RegExp(r'CURP (.+)');
//                 RegExp seccionRegex = RegExp(r'SECCIÓN (.+)');

//                 String? nombre =
//                     nombreRegex.firstMatch(extractedText)?.group(3);
//                 String? apellidoPaterno =
//                     nombreRegex.firstMatch(extractedText)?.group(1);
//                 String? apellidoMaterno =
//                     nombreRegex.firstMatch(extractedText)?.group(2);
//                 String? domicilio =
//                     domicilioRegex.firstMatch(extractedText)?.group(1);
//                 String? colonia =
//                     domicilioRegex.firstMatch(extractedText)?.group(2);
//                 String? seccion =
//                     seccionRegex.firstMatch(extractedText)?.group(1);
//                 String? curp = curpRegex.firstMatch(extractedText)?.group(1);

//                 // Validar si el apellido materno está vacío y asignar apellido materno al apellido paterno
//                 if (apellidoMaterno == null || apellidoMaterno.isEmpty) {
//                   apellidoMaterno = apellidoPaterno;
//                   apellidoPaterno = '';
//                 }

//                 if (curp == null || curp.isEmpty) {
//                   print('entrando');
//                   // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
//                   RegExp curpRegex = RegExp(r'CURP\n(.+)', dotAll: true);
//                   curp = curpRegex.firstMatch(extractedText)?.group(1);
//                 }

//                 if (seccion == null || seccion.isEmpty) {
//                   print('entrando');
//                   // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
//                   RegExp seccionRegex = RegExp(r'SECCIÓN (.+)', dotAll: true);
//                   seccion = seccionRegex.firstMatch(extractedText)?.group(1);
//                 }

//                 print('entrando' + extractedText);

//                 setState(() {
//                   nombreController.text = nombre ?? '';
//                   apellidoPaternoController.text = apellidoPaterno ?? '';
//                   apellidoMaternoController.text = apellidoMaterno ?? '';
//                   domicilioController.text = domicilio ?? '';
//                   coloniaController.text = colonia ?? '';
//                   seccionController.text = seccion ?? '';
//                   curpController.text = curp ?? '';
//                   isDetecting = false;
//                 });

//                 textRecognizer.close();
//               } catch (e) {
//                 print(e);
//                 setState(() {
//                   isDetecting = false;
//                 });
//               }
//             },
//           ),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }

//   Widget _buildTextField(String labelText, TextEditingController controller) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
