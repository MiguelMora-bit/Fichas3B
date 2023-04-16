import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CodigoPostalServices extends ChangeNotifier {
  List<String> listaBarrios = [];
  List<String> listaMunicipios = [];
  String estado = "";
  bool isLoading = false;

  final String _baseUrl = "fichas-3b-pruebas-default-rtdb.firebaseio.com";

  Future<bool> loadPostal(codigoPostal, context) async {
    isLoading = true;

    limpiarListas();
    notifyListeners();
    try {
      cargando(context, 'Buscando informacion del codigo postal');
      final url = Uri.https(_baseUrl, "/postales/$codigoPostal.json");
      final resp = await http.get(url);
      var data = jsonDecode(resp.body);
      data ??= [];
      for (var codigo in data) {
        if (!listaBarrios.contains(codigo["barrio"])) {
          listaBarrios.add(codigo["barrio"]);
        }

        if (!listaMunicipios.contains(codigo["municipio"])) {
          listaMunicipios.add(codigo["municipio"]);
        }
        estado = codigo["estado"];
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  List<String> devolverBarrios() {
    return listaBarrios;
  }

  List<String> devolverDelegacion() {
    return listaMunicipios;
  }

  limpiarListas() {
    listaBarrios = [];
    listaMunicipios = [];
    estado = "";
    notifyListeners();
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
