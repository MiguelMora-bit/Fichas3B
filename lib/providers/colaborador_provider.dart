import 'package:flutter/material.dart';

class ColaboradorProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String numeroEmpleado = "";

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
