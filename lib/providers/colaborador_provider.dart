import 'package:flutter/material.dart';

class ColaboradorProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String numeroEmpleado = "";
  String nombreEmpleado = "";
  String puesto = "";
  String tienda = "";
  List<String> fichasPropuestas = [];

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
