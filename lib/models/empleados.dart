import 'dart:convert';

class Empleados {
  Empleados({
    required this.nombre,
    required this.tienda,
  });

  String nombre;
  String tienda;

  factory Empleados.fromJson(String str) => Empleados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Empleados.fromMap(Map<String, dynamic> json) => Empleados(
        nombre: json["nombre"],
        tienda: json["tienda"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "tienda": tienda,
      };
}
