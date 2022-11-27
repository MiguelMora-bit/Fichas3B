import 'package:flutter/material.dart';

class ColaboradorProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GlobalKey<FormState> formKeyCorreo = GlobalKey<FormState>();

  GlobalKey<FormState> formKeyCelular = GlobalKey<FormState>();

  String numeroEmpleado = "";
  String nombreEmpleado = "";
  String puesto = "";
  String tienda = "";
  String correoElectronico = "";
  String celular = "";
  List<String> fichasPropuestas = [];

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  bool isValidFormCelular() {
    return formKeyCelular.currentState?.validate() ?? false;
  }

  bool isValidFormCorreo() {
    return formKeyCorreo.currentState?.validate() ?? false;
  }

  bool validateEmail() {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(correoElectronico);
  }
}
