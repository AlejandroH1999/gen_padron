import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patron/models/camera_controller.dart';
import 'package:patron/models/text_detection.dart';
import 'package:patron/widgets/text_input_widgets.dart';

class CameraPickerApp extends StatefulWidget {
  const CameraPickerApp({super.key});

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraPickerApp> {
  late CameraController controller;
  XFile? imageShow; // Variable para almacenar la imagen seleccionada

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
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('captura de datos')),
          body: Column(
            children: [
              Stack(
                children: [
                  if (imageShow != null) // Verificar si la imagen no es nula
                    Image.file(
                      File(imageShow!
                          .path), // Usar la ruta de la imagen capturada
                      height: 200,
                    )
                  else // Si la imagen es nula, mostrar la imagen estática
                    Image.asset(
                      'assets/ejemploCredencial.png',
                      height: 200,
                    ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextInputWidgets.buildTextField(
                          "Apellido Paterno", apellidoPaternoController),
                      TextInputWidgets.buildTextField(
                          "Apellido Materno", apellidoMaternoController),
                      TextInputWidgets.buildTextField(
                          "Nombre", nombreController),
                      TextInputWidgets.buildTextField(
                          "Domicilio", domicilioController),
                      TextInputWidgets.buildTextField(
                          "Colonia", coloniaController),
                      TextInputWidgets.buildTextField(
                          "Sección", seccionController),
                      TextInputWidgets.buildTextField("CURP", curpController),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.upload_file),
            onPressed: () async {
              try {
                setState(() {
                  isDetecting = true;
                });

                final imagePicker = ImagePicker();
                final XFile? image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  final inputImage = InputImage.fromFilePath(image.path);
                  String extractedText =
                      await TextDetection.extractTextFromImage(inputImage);

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
                    imageShow = image; // Actualizar la imagen mostrada
                  });
                } else {
                  setState(() {
                    isDetecting = false;
                  });
                }
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
