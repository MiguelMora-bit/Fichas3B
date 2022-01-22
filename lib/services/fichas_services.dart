import 'dart:convert';

import 'package:fichas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FichasService extends ChangeNotifier {
  final String _baseUrl = 'fichasguardadas-default-rtdb.firebaseio.com';

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
      // print('algo salio mal');
      // print(resp.body);
      return null;
    }
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
