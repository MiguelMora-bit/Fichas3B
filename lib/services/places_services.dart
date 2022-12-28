import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../models/place_search.dart';

class PlacesServices extends ChangeNotifier {
  final key = 'AIzaSyChqpiBpLI59w7JBWoDyB3SbRJCr4N7ens';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
