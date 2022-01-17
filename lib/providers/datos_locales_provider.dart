import 'package:flutter/material.dart';

class DatosLocalProvider extends ChangeNotifier {
  GlobalKey<FormState> formDatosLocalKey = GlobalKey<FormState>();

  String propietario = "";
  String telefono = "";
  String ventaRenta = "";
  String frente = "";
  String fondo = "";

  bool isValidForm() {
    return formDatosLocalKey.currentState?.validate() ?? false;
  }
}
