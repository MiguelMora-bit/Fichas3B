import 'package:flutter/material.dart';

class GeneradoresProvider extends ChangeNotifier {
  GlobalKey<FormState> formGeneradoresKey = GlobalKey<FormState>();

  String generador = "";
  String distancia = "";

  List<Map<String, dynamic>> generadores = [];

  bool isValidForm() {
    return formGeneradoresKey.currentState?.validate() ?? false;
  }
}
