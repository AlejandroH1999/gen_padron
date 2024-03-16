import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patron/models/promovido.dart';
import 'package:patron/widgets/text_input_widgets.dart';
import 'package:http/http.dart' as http;

class ListPromotees extends StatefulWidget {
  const ListPromotees({Key? key}) : super(key: key);

  @override
  _ListPromoteesState createState() => _ListPromoteesState();
}

class _ListPromoteesState extends State<ListPromotees> {
  List<Promovido> listPromotees = [];

  List<Promovido> filteredList = [];
  late TextEditingController filterController;

  @override
  void initState() {
    super.initState();
    fetchData();
    filteredList.addAll(listPromotees);
    filterController = TextEditingController();
    filterController.addListener(() {
      _filterList(filterController.text);
    });
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse(
          'http://192.168.0.18:12070/api/v1/padrones/mispromovidos/${1}'));

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['data'];
        List<Promovido> promotees =
            responseData.map((data) => Promovido.fromJson(data)).toList();
        setState(() {
          listPromotees = promotees;
          filteredList =
              listPromotees; // Añade esto para inicializar filteredList
        });
      } else {
        print('Error al cargar datos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al cargar datos: $error');
    }
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  void _filterList(String query) {
    setState(() {
      filteredList = listPromotees.where((promovido) {
        final nombre = promovido.nombre.toLowerCase();
        final calle = promovido.calle.toLowerCase();
        final colonia = promovido.colonia.toLowerCase();
        final numero = promovido.numero.toLowerCase();
        final seccion = promovido.seccion.toString().toLowerCase();
        final filtro = query.toLowerCase();
        return nombre.contains(filtro) ||
            calle.contains(filtro) ||
            colonia.contains(filtro) ||
            numero.contains(filtro) ||
            seccion.contains(filtro);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Promovidos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextInputWidgets.buildTextField(
              "Buscar",
              filterController,
              borderRadius: 20.0, // Añade bordes redondeados
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0), // Añade un borde
              prefixIcon: const Icon(Icons.search,
                  color: Colors.blue), // Icono de búsqueda
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      filteredList[index].nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filteredList[index].calle,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          filteredList[index].colonia,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          "Número: ${filteredList[index].numero}, Sección: ${filteredList[index].seccion}",
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmación'),
                            content: Text(
                              '¿Asistio?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Aquí puedes implementar la lógica cuando el usuario selecciona "Sí"
                                  // Por ejemplo, imprimir el nombre del promovido
                                  print(
                                      'Promovido seleccionado: ${filteredList[index].nombre}');
                                  Navigator.of(context).pop();
                                },
                                child: Text('Sí'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
