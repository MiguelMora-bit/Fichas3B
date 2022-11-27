import 'package:flutter/material.dart';

class CompetenciasProvider extends ChangeNotifier {
  GlobalKey<FormState> formCompetenciasKey = GlobalKey<FormState>();

  String competidor = "";
  String distancia = "";

  List<Map<String, dynamic>> competencias = [
    {
      "identificador": 0,
      "color": Colors.black,
      "imagePath": "assets/aurrera.jpg",
      "competidor": 'Aurrera',
      "distancia": "0",
      "activo": false
    },
    {
      "identificador": 1,
      "color": Colors.black,
      "imagePath": "assets/chedraui.jpg",
      "competidor": 'Chedraui',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 2,
      "color": Colors.black,
      "imagePath": "assets/neto.jpg",
      "competidor": 'Neto',
      "distancia": "0",
      "activo": false,
    },
    {
      "identificador": 3,
      "color": Colors.black,
      "imagePath": "assets/tienda.jpg",
      "competidor": 'Abarrotes',
      "distancia": "0",
      "activo": false,
    }
  ];

  cambiarElemento(identificador, distancia, activo) {
    competencias[identificador]["distancia"] = distancia;
    competencias[identificador]["activo"] = activo;
    notifyListeners();
  }

  bool validacionAvanzar() {
    final elementosActivos =
        competencias.where((element) => element["activo"] == true).toList();

    return elementosActivos.length >= 2;
  }

  List<Map<String, dynamic>> devolverCompetencias() {
    final List<Map<String, dynamic>> devolver = [];

    final elementosActivos =
        competencias.where((element) => element["activo"] == true).toList();

    for (var elemento in elementosActivos) {
      devolver.add({
        "id": elemento["identificador"],
        "competidor": elemento["competidor"],
        "distancia": elemento["distancia"]
      });
    }

    return devolver;
  }

  bool isValidForm() {
    return formCompetenciasKey.currentState?.validate() ?? false;
  }
}
