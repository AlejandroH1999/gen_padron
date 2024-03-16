import 'package:flutter/material.dart';
import 'package:patron/screens/camera_app.dart';
import 'package:patron/screens/image_picker_screen.dart';
import 'package:patron/screens/list_Promotees.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Inicio'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 10),
            Image.asset(
              'assets/ejemplo.png', // Ruta de la imagen de bienvenida
              height: 200,
            ),
            // const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Capturar con cámara'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar la función para subir un archivo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CameraPickerApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Subir archivo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar la función para subir un archivo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListPromotees()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Lista de promovidos'),
            ),
          ],
        ),
      ),
    );
  }
}
