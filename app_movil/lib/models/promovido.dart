import 'dart:convert';

class Promovido {
  final int id;
  final String nombre;
  final String calle;
  final String colonia;
  final String numero;
  final int seccion;

  Promovido({
    required this.id,
    required this.nombre,
    required this.calle,
    required this.colonia,
    required this.numero,
    required this.seccion,
  });

  // Constructor para crear un Promovido a partir de un mapa (JSON)
  factory Promovido.fromJson(Map<String, dynamic> json) {
    return Promovido(
      id: json['id'],
      nombre: json['nombre'],
      calle: json['calle'],
      colonia: json['colonia'],
      numero: json['numero'],
      seccion: json['seccion'],
    );
  }
}
