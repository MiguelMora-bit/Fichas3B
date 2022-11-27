import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmpleadosServices extends ChangeNotifier {
  List<String> fichasVacias = [];

  bool isLoading = true;
  final String _baseUrl = "fichas-3b-pruebas-default-rtdb.firebaseio.com";

  Future<Map<String, dynamic>?> loadEmpleado(numEmpleado, context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.https(_baseUrl, "empleados/$numEmpleado.json");
      cargando(context, 'Estamos buscando tu información');
      final resp = await http.get(url);
      var _empleado = jsonDecode(resp.body);
      return _empleado;
    } catch (e) {
      return {};
    } finally {
      isLoading = false;
      Navigator.of(context).pop();
      notifyListeners();
    }
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

  Future updateCelular(numEmpleado, celular, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, 'empleados/$numEmpleado.json');
      cargando(context, 'Estamos actualizando tu numero celular');
      await http.patch(url, body: jsonEncode({"celular": celular}));
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future updateCorreo(numEmpleado, correo, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, 'empleados/$numEmpleado.json');
      cargando(context, 'Estamos actualizando tu correo');
      await http.patch(url, body: jsonEncode({"correo": correo}));
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future generarFolio(numEmpleado) async {
    final url = Uri.https(_baseUrl, 'empleados/$numEmpleado/Fichas.json');
    final resp = await http.get(url);

    List<dynamic>? _fichasEmpleados = jsonDecode(resp.body);
    if (_fichasEmpleados != null) {
      return "$numEmpleado-${_fichasEmpleados.length}";
    } else {
      return "$numEmpleado-0";
    }
  }

  void cargando(BuildContext context, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Cargando...')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/loading.gif",
                  height: 50.0,
                  width: 50.0,
                ),
                const SizedBox(height: 40),
                Center(child: Text(mensaje))
              ],
            ),
          );
        });
  }
}
