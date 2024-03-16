// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:patron/models/camera_controller.dart';
// import 'package:patron/models/text_detection.dart';
// import 'package:patron/widgets/text_input_widgets.dart';

// class CameraApp extends StatefulWidget {
//   const CameraApp({super.key});

//   @override
//   CameraAppState createState() => CameraAppState();
// }

// class CameraAppState extends State<CameraApp> {
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
//     initializeCameraController();
//   }

//   Future<void> initializeCameraController() async {
//     try {
//       if (CameraControllerProvider.cameras.isEmpty) {
//         print('No se encontraron cámaras disponibles');
//       } else {
//         controller = CameraController(
//             CameraControllerProvider.cameras[0], ResolutionPreset.high);
//         await controller.initialize();
//         if (mounted) {
//           setState(() {});
//         }
//       }
//     } catch (e) {
//       print('Error al inicializar el controlador de la cámara: $e');
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
//                         margin: const EdgeInsets.only(bottom: 16),
//                         child: isDetecting
//                             ? const Text(
//                                 'Detectando credencial...',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )
//                             : const SizedBox.shrink(),
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
//                       TextInputWidgets.buildTextField(
//                           "Apellido Paterno", apellidoPaternoController),
//                       TextInputWidgets.buildTextField(
//                           "Apellido Materno", apellidoMaternoController),
//                       TextInputWidgets.buildTextField(
//                           "Nombre", nombreController),
//                       TextInputWidgets.buildTextField(
//                           "Domicilio", domicilioController),
//                       TextInputWidgets.buildTextField(
//                           "Colonia", coloniaController),
//                       TextInputWidgets.buildTextField(
//                           "Sección", seccionController),
//                       TextInputWidgets.buildTextField("CURP", curpController),
//                       const SizedBox(height: 20),
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
//                 String extractedText =
//                     await TextDetection.extractTextFromImage(inputImage);

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
//                   // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
//                   RegExp curpRegex = RegExp(r'CURP\n(.+)', dotAll: true);
//                   curp = curpRegex.firstMatch(extractedText)?.group(1);
//                 }

//                 if (seccion == null || seccion.isEmpty) {
//                   // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
//                   RegExp seccionRegex = RegExp(r'SECCIÓN (.+)', dotAll: true);
//                   seccion = seccionRegex.firstMatch(extractedText)?.group(1);
//                 }

// ignore_for_file: avoid_print

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
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:patron/models/camera_controller.dart';
import 'package:patron/models/text_detection.dart';
import 'package:patron/widgets/text_input_widgets.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController seccionController = TextEditingController();
  final TextEditingController curpController = TextEditingController();

  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    initializeCameraController();
  }

  Future<void> initializeCameraController() async {
    try {
      if (CameraControllerProvider.cameras.isEmpty) {
        print('No se encontraron cámaras disponibles');
      } else {
        controller = CameraController(
            CameraControllerProvider.cameras[0], ResolutionPreset.high);
        await controller.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error al inicializar el controlador de la cámara: $e');
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
      return Scaffold(
        body: Scaffold(
          appBar: AppBar(title: const Text('Captura de datos')),
          body: ListView(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio:
                        3 / 2, // Relación de aspecto 2:3 común en las cámaras
                    child: CameraPreview(controller),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: isDetecting
                            ? const Text(
                                'Detectando credencial...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextInputWidgets.buildTextField(
                      "Apellido Paterno", apellidoPaternoController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "Apellido Materno", apellidoMaternoController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "Nombre", nombreController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "Domicilio", domicilioController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "Colonia", coloniaController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda),
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "Sección", seccionController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 10),
                    TextInputWidgets.buildTextField(
                      "CURP", curpController,
                      borderRadius: 20.0, // Añade bordes redondeados
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0), // Añade un borde
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.blue), // Icono de búsqueda
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Aquí puedes agregar la lógica para guardar los datos
                        // Por ejemplo, puedes guardar los datos en una base de datos o enviarlos a una API
                        // También puedes mostrar un diálogo de confirmación o cualquier otro feedback al usuario
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: isDetecting
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Icon(Icons.camera),
            onPressed: () async {
              try {
                setState(() {
                  isDetecting = true;
                });

                final image = await controller.takePicture();
                final inputImage = InputImage.fromFilePath(image.path);
                String extractedText =
                    await TextDetection.extractTextFromImage(inputImage);

                // Expresiones regulares y extracción de datos...
                RegExp nombreRegex = RegExp(r'NOMBRE\n(.+?)\n(.+?)\n(.+?)\n');
                RegExp domicilioRegex =
                    RegExp(r'DOMICILIO\n(.+?)\n(.+?)\n(.+?)\n');
                RegExp curpRegex = RegExp(r'CURP (.+)');
                RegExp seccionRegex = RegExp(r'SECCIÓN (.+)');

                String? nombre =
                    nombreRegex.firstMatch(extractedText)?.group(3);
                String? apellidoPaterno =
                    nombreRegex.firstMatch(extractedText)?.group(1);
                String? apellidoMaterno =
                    nombreRegex.firstMatch(extractedText)?.group(2);
                String? domicilio =
                    domicilioRegex.firstMatch(extractedText)?.group(1);
                String? colonia =
                    domicilioRegex.firstMatch(extractedText)?.group(2);
                String? seccion =
                    seccionRegex.firstMatch(extractedText)?.group(1);
                String? curp = curpRegex.firstMatch(extractedText)?.group(1);

                // Validar si el apellido materno está vacío y asignar apellido materno al apellido paterno
                if (apellidoMaterno == null || apellidoMaterno.isEmpty) {
                  apellidoMaterno = apellidoPaterno;
                  apellidoPaterno = '';
                }

                if (curp == null || curp.isEmpty) {
                  // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
                  RegExp curpRegex = RegExp(r'CURP\n(.+)', dotAll: true);
                  curp = curpRegex.firstMatch(extractedText)?.group(1);
                }

                if (seccion == null || seccion.isEmpty) {
                  // RegExp curpRegex = RegExp(r'CURP\n(.+?)\n');
                  RegExp seccionRegex = RegExp(r'SECCIÓN (.+)', dotAll: true);
                  seccion = seccionRegex.firstMatch(extractedText)?.group(1);
                }

                setState(() {
                  nombreController.text = nombre ?? '';
                  apellidoPaternoController.text = apellidoPaterno ?? '';
                  apellidoMaternoController.text = apellidoMaterno ?? '';
                  domicilioController.text = domicilio ?? '';
                  coloniaController.text = colonia ?? '';
                  seccionController.text = seccion ?? '';
                  curpController.text = curp ?? '';
                  isDetecting = false;
                });
              } catch (e) {
                print(e);
                setState(() {
                  isDetecting = false;
                });
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
