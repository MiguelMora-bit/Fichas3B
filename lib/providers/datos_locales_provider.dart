import 'package:flutter/material.dart';

class DatosLocalProvider extends ChangeNotifier {
  GlobalKey<FormState> formDatosLocalKey = GlobalKey<FormState>();

  String propietario = "";
  String telefono = "";
  String ventaRenta = "Renta";
  String frente = "";
  String fondo = "";
  String costo = "";
  String tipoInmueble = "";

  bool isValidForm() {
    return formDatosLocalKey.currentState?.validate() ?? false;
  }
}
