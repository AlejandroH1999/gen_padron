// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patron/models/text_detection.dart';
import 'package:patron/widgets/text_input_widgets.dart';

class CameraPickerApp extends StatefulWidget {
  const CameraPickerApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraPickerAppState createState() => _CameraPickerAppState();
}

class _CameraPickerAppState extends State<CameraPickerApp> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de Datos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageShow != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: FileImage(File(imageShow!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/ejemploCredencial.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextInputWidgets.buildTextField(
              "Apellido Paterno",
              apellidoPaternoController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "Apellido Materno",
              apellidoMaternoController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "Nombre",
              nombreController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "Domicilio",
              domicilioController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "Colonia",
              coloniaController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "Sección",
              seccionController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 10),
            TextInputWidgets.buildTextField(
              "CURP",
              curpController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final imagePicker = ImagePicker();
                final XFile? image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  final inputImage = InputImage.fromFilePath(image.path);
                  String extractedText =
                      await TextDetection.extractTextFromImage(inputImage);

                  print(extractedText);
                  print('procesando datos');

                  // Realizar el procesamiento de texto y la asignación de valores a los controladores aquí

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
                      _extractData(extractedText, domicilioRegex);
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
                    // Actualizar la imagen mostrada
                    imageShow = image;
                  });
                }
              },
              child: const Text('Seleccionar Imagen'),
            ),
          ],
        ),
      ),
    );
  }

  String? _extractData(String text, RegExp regex) {
    final match = regex.firstMatch(text);
    if (match != null) {
      // Concatenar los grupos capturados para formar el dato completo
      return match.groups([1, 2, 3]).join(' ');
    }
    return null;
  }
}
