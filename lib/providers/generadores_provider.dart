import 'package:flutter/material.dart';

class GeneradoresProvider extends ChangeNotifier {
  GlobalKey<FormState> formGeneradoresKey = GlobalKey<FormState>();

  String generador = "";
  String distancia = "";

  List<Map<String, dynamic>> generadores = [
    {
      "identificador": 0,
      "color": Colors.black,
      "imagePath": "assets/cajero.jpg",
      "generador": 'Cajero',
      "distancia": "0",
      "activo": false
    },
    {
      "identificador": 1,
      "color": Colors.black,
      "imagePath": "assets/bus.jpg",
      "generador": 'Bus',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 2,
      "color": Colors.black,
      "imagePath": "assets/iglesia.jpg",
      "generador": 'Iglesia',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 3,
      "color": Colors.black,
      "imagePath": "assets/escuela.jpg",
      "generador": 'Escuela',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 4,
      "color": Colors.black,
      "imagePath": "assets/metro.jpg",
      "generador": 'Metro',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 5,
      "color": Colors.black,
      "imagePath": "assets/oficina.jpg",
      "generador": 'Oficina de gobierno',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 6,
      "color": Colors.black,
      "imagePath": "assets/tienda2.jpg",
      "generador": 'Mercado',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 7,
      "color": Colors.black,
      "imagePath": "assets/banco.jpg",
      "generador": 'Banco',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 8,
      "color": Colors.black,
      "imagePath": "assets/hospital.jpg",
      "generador": 'Hospital',
      "distancia": "0",
      "activo": false,
    },
  ];

  cambiarElemento(identificador, distancia, activo) {
    generadores[identificador]["distancia"] = distancia;
    generadores[identificador]["activo"] = activo;
    notifyListeners();
  }

  bool validacionAvanzar() {
    final elementosActivos =
        generadores.where((element) => element["activo"] == true).toList();

    return elementosActivos.length >= 2;
  }

  List<Map<String, dynamic>> devolverGeneradores() {
    final List<Map<String, dynamic>> devolver = [];

    final elementosActivos =
        generadores.where((element) => element["activo"] == true).toList();

    for (var elemento in elementosActivos) {
      devolver.add({
        "id": elemento["identificador"],
        "generador": elemento["generador"],
        "distancia": elemento["distancia"]
      });
    }

    return devolver;
  }

  bool isValidForm() {
    return formGeneradoresKey.currentState?.validate() ?? false;
  }
}
