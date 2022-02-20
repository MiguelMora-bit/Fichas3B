import 'dart:convert';

import 'package:fichas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FichasService extends ChangeNotifier {
  final String _baseUrl = 'fichasguardadas-default-rtdb.firebaseio.com';
  final List<FichaExistente> fichas = [];

  bool isLoading = true;

  Future<List<FichaExistente>> loadFichasEmpleado(List fichasEmpleado) async {
    isLoading = true;
    notifyListeners();
    for (String element in fichasEmpleado) {
      var fichaCargada = (await loadFicha(element));
      final tempFicha = FichaExistente(
          folio: element,
          delegacion: fichaCargada!["delegacion"],
          fotoUrl: fichaCargada["fotoUrl"],
          status: fichaCargada["status"]);
      fichas.add(tempFicha);
    }
    isLoading = false;
    notifyListeners();
    return fichas;
  }

  Future<Map<String, dynamic>?> loadFicha(String folio) async {
    final url = Uri.https(_baseUrl, "Fichas/$folio.json");
    final resp = await http.get(url);
    var _ficha = jsonDecode(resp.body);
    return _ficha;
  }

  Future<String> createFicha(Ficha ficha) async {
    final url = Uri.https(_baseUrl, 'Fichas.json');
    final resp = await http.post(url, body: ficha.toJson());
    final decodedData = json.decode(resp.body);
    return decodedData["name"].toString();
  }

  Future<String?> uploadImage(picture) async {
    if (picture == null) return null;

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/fichas3b/image/upload?upload_preset=ml_default');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', picture.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
