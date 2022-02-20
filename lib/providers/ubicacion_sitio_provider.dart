import 'package:flutter/material.dart';

class UbicacionSitioProvider extends ChangeNotifier {
  GlobalKey<FormState> formUbicacionKey = GlobalKey<FormState>();

  String direccion = "";
  String delegacion = "";
  String colonia = "";
  String calle1 = "";
  String calle2 = "";
  String nombreSitio = "";
  String estado = "";

  bool isValidForm() {
    return formUbicacionKey.currentState?.validate() ?? false;
  }
}
