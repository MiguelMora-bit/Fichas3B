import 'package:flutter/material.dart';

class FortalezasDebilidadesProvider extends ChangeNotifier {
  GlobalKey<FormState> formFortalezasDebilidadesKey = GlobalKey<FormState>();

  String fortalezas = "";
  String debilidades = "";

  bool isValidForm() {
    return formFortalezasDebilidadesKey.currentState?.validate() ?? false;
  }
}
