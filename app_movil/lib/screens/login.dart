import 'dart:convert';
import 'package:patron/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validación básica: comprueba si el nombre de usuario y la contraseña son correctos.
    // if (username == 'usuario' && password == 'contraseña') {
    var url = 'http://192.168.0.18:12070/api/v1/padrones/login';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );
    var data = json.decode(response.body);

    if (data['error']) {
      setState(() {
        _message = 'Nombre de usuario o contraseña incorrectos.';
      });
      return;
    }
    setState(() {
      _message = 'Inicio de sesion exitoso';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nombre = data['data'][0]['nombre'];
    var id = data['data'][0]['id'];
    await prefs.setString('name', nombre);
    await prefs.setString('id', id.toString());
    await prefs.setBool('isLoggedIn', true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });

    if (isLoggedIn) {
      // Si el usuario está autenticado, navega a otra pantalla
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
              child: Card(
            // color: Color.fromARGB(255, 255, 255, 255),
            elevation: 4, // Altura de la sombra
            margin: const EdgeInsets.all(30), // Margen alrededor del card
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                Image.asset(
                  'assets/ejemplo.png',
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
                ),
                // const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('exitoso')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
