import 'dart:async';

import 'package:fichas/providers/maps_provder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../providers/croquis_foto_provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;
  late StreamSubscription markerSubscription;
  final _locationController = TextEditingController();

  Set<Marker> markers = <Marker>{};
  Position? currenPosition;
  Marker? marcador;
  final geoLocator = Geolocator();

  @override
  void initState() {
    final mapsProvider = Provider.of<MapsProvider>(context, listen: false);

    mapsProvider.searchResults.clear();

    if (mapsProvider.marker != null) {
      markers.clear();
      markers.add(mapsProvider.marker!);
    }

    //Listen for selected Location
    locationSubscription = mapsProvider.selectedLocation.stream.listen((place) {
      _locationController.text = place.name;
      _goToPlace(place);
    });

    markerSubscription = mapsProvider.selectedMarker.stream.listen((marker) {
      markers.clear();
      markers.add(marker);
    });

    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    locationSubscription.cancel();
    markerSubscription.cancel();
    super.dispose();
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 13.0),
      ),
    );
  }

  void locatePosition(controller) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currenPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    marcador = Marker(
        markerId: const MarkerId('ubicacionLocal'),
        position: LatLng(position.latitude, position.longitude));
    markers.add(marcador!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final croquisProvider = Provider.of<CroquisProvider>(context);
    final mapsProvider = Provider.of<MapsProvider>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: mapsProvider.currentLocation,
              zoom: mapsProvider.currentLocation ==
                      const LatLng(23.0000000, -102.0000000)
                  ? 5
                  : 13,
            ),
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // locatePosition(controller);
            },
            markers: markers,
            onTap: _handleTap,
          ),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: TextField(
                    controller: _locationController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: BorderRadius.circular(20.0)),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: BorderRadius.circular(20.0)),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: 'Busca una ubicación',
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) => mapsProvider.searchPlaces(value),
                    onTap: () => mapsProvider.clearSelectedLocation(),
                  )),
            ],
          ),
          if (mapsProvider.searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.6),
                      backgroundBlendMode: BlendMode.darken)),
            ),
          if (mapsProvider.searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
              child: SizedBox(
                height: 180.0,
                child: ListView.builder(
                    itemCount: mapsProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          mapsProvider.searchResults[index].description,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          mapsProvider.setSelectedLocation(
                              mapsProvider.searchResults[index].placeId);
                        },
                      );
                    }),
              ),
            ),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () => {
            markers.isNotEmpty
                ? _asigncionMarcador(mapsProvider, croquisProvider)
                : null,
            Navigator.pop(context),
          },
          label: const Text('Guardar marcador'),
          icon: const Icon(Icons.location_on_outlined),
        ),
      ),
    );
  }

  _asigncionMarcador(
      MapsProvider mapsProvider, CroquisProvider croquisProvider) {
    croquisProvider.coordenadas = markers.elementAt(0).position.toString();
    mapsProvider.marker = markers.elementAt(0);
  }

  _handleTap(LatLng tappedPoint) {
    final mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    setState(() {
      markers.clear();
      final Marker marcador = Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint);
      markers.add(marcador);
      mapsProvider.marker = marcador;
      mapsProvider.actualizarMarcador(marcador);
    });
  }
}
