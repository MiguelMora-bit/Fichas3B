import 'dart:async';

import 'package:fichas/services/places_services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../models/place_search.dart';

class MapsProvider with ChangeNotifier {
  final placesService = PlacesServices();

  //Variables
  LatLng currentLocation = const LatLng(23.0000000, -102.0000000);
  late List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation =
      StreamController<Place>.broadcast();
  StreamController<Marker> selectedMarker =
      StreamController<Marker>.broadcast();
  late Place selectedLocationStatic;

  Marker? marker;

  Future searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    currentLocation = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = [];
    notifyListeners();
  }

  actualizarMarcador(Marker markerNuevo) {
    selectedMarker.add(markerNuevo);
    notifyListeners();
  }

  clearSelectedLocation() {
    searchResults = [];
    notifyListeners();
  }
}
