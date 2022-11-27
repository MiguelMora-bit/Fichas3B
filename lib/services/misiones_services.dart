import 'dart:convert';

import 'package:fichas/models/mision_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MisionesServices extends ChangeNotifier {
  final String _baseUrl = "fichas-3b-pruebas-default-rtdb.firebaseio.com";
  final List<Mision> misiones = [];

  bool isLoading = true;

  MisionesServices() {
    loadMisiones();
  }

  Future loadMisiones() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "misiones.json");
    final resp = await http.get(url);

    final Map<String, dynamic> fichasMap = json.decode(resp.body);

    fichasMap.forEach((key, value) {
      final tempMision = Mision.fromMap(value);
      misiones.add(tempMision);
    });

    isLoading = false;
    notifyListeners();
  }

  void displayDialogInternet(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Sin conexión a internet')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 20),
                Icon(
                  Icons.wifi_off_rounded,
                  size: 60.0,
                ),
                SizedBox(height: 30),
                Text(
                  'Upsss, no tienes internet, intenta más tarde',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'))
            ],
          );
        });
  }
}
