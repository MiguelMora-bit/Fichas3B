import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmpleadosServices extends ChangeNotifier {
  final String _baseUrl = "acquired-jet-303917-default-rtdb.firebaseio.com";
  Map<String, dynamic> _empleadosMap = {};

  bool isLoading = true;

  EmpleadosServices() {
    loadEmpleados();
  }

  Future loadEmpleados() async {
    final url = Uri.https(_baseUrl, "empleados.json");
    final resp = await http.get(url);

    _empleadosMap = jsonDecode(resp.body);
  }

  devolverEmpleado(numEmpleado) {
    return (_empleadosMap[numEmpleado]);
  }
}
