import 'package:flutter/material.dart';

class CompetenciasProvider extends ChangeNotifier {
  GlobalKey<FormState> formCompetenciasKey = GlobalKey<FormState>();

  String competidor = "";
  String distancia = "";

  List<Map<String, dynamic>> competencias = [];

  bool isValidForm() {
    return formCompetenciasKey.currentState?.validate() ?? false;
  }
}
