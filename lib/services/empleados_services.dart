import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmpleadosServices extends ChangeNotifier {
  List<String> fichasVacias = [];
  final String _baseUrl = "acquired-jet-303917-default-rtdb.firebaseio.com";

  Future<Map<String, dynamic>?> loadEmpleado(numEmpleado) async {
    final url = Uri.https(_baseUrl, "empleados/$numEmpleado.json");
    final resp = await http.get(url);
    var _empleado = jsonDecode(resp.body);
    return _empleado;
  }

  Future obtenerFichasEmpleado(numEmpleado) async {
    final url = Uri.https(_baseUrl, 'empleados/$numEmpleado/Fichas.json');
    final resp = await http.get(url);

    List<dynamic>? _fichasEmpleados = jsonDecode(resp.body);
    if (_fichasEmpleados == null) {
      return fichasVacias;
    } else {
      return _fichasEmpleados;
    }
  }

  Future updateFichasEmpleado(numEmpleado, List<dynamic> fichas) async {
    final url = Uri.https(_baseUrl, 'empleados/$numEmpleado.json');

    await http.patch(url, body: jsonEncode({"Fichas": fichas}));
  }
}
