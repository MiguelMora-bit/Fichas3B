import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fichas/providers/croquis_foto_provider.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../providers/maps_provder.dart';

class CroquisPage extends StatefulWidget {
  const CroquisPage({Key? key}) : super(key: key);

  @override
  _CroquisPageState createState() => _CroquisPageState();
}

class _CroquisPageState extends State<CroquisPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = <Marker>{};
  Position? currenPosition;
  Marker? marcador;
  final geoLocator = Geolocator();
  late StreamSubscription locationSubscription;
  late StreamSubscription markerSubscription;

  @override
  void initState() {
    final mapsProvider = Provider.of<MapsProvider>(context, listen: false);

    //Listen for selected Location
    locationSubscription = mapsProvider.selectedLocation.stream.listen((place) {
      _goToPlace(place);
    });

    locationSubscription = mapsProvider.selectedMarker.stream.listen((marker) {
      markers.clear();
      markers.add(marker);
    });
    super.initState();
  }

  @override
  void dispose() {
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

  void locatePosition(controller, Position position) async {
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final croquisProvider = Provider.of<CroquisProvider>(context);
    final mapsProvider = Provider.of<MapsProvider>(context);

    CameraPosition _puntoInicial = CameraPosition(
      target: mapsProvider.currentLocation,
      zoom: 5,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/Logo3B.png",
              height: 50.0,
              width: 50.0,
            ),
            Container(
              width: 35,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("CROQUIS & FOTO DEL INMUEBLE"),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _contruirSeparador(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, "maps"),
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: _construirCroquis(_puntoInicial, croquisProvider,
                    locatePosition, mapsProvider)),
          ),
          // _construirFotoInmueble(croquisProvider),
          _contruirSeparador(),
          _fotografia(croquisProvider),
          _contruirSeparador(),
          _boton(croquisProvider),
          _contruirSeparador()
        ],
      ),
    );
  }

  Widget _construirCroquis(
      _puntoInicial,
      CroquisProvider croquisProvider,
      void Function(dynamic controller, Position position) locatePosition,
      MapsProvider mapsProvider) {
    return SizedBox(
      height: 350,
      child: AbsorbPointer(
        absorbing: true,
        child: GoogleMap(
          mapType: MapType.normal,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _puntoInicial,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            try {
              final currentPosition = await _determinePosition();

              croquisProvider.coordenadas = "";

              locatePosition(controller, currentPosition);
            } catch (e) {
              displayDialogAndroid(
                  "Sin ubicación",
                  "Marca la ubicación de maner manual",
                  const Icon(
                    Icons.location_off_outlined,
                    size: 60.0,
                  ));
            }
          },
          markers: markers,
        ),
      ),
    );
  }

  Widget _fotografia(CroquisProvider croquisProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            height: 350,
            width: double.infinity,
            child: croquisProvider.foto != null
                ? Image.file(
                    File(croquisProvider.foto!.path),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/noImagen.png",
                    fit: BoxFit.cover,
                  ),
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                displayDialogAndroidPhoto(croquisProvider);
              },
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 45, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contruirSeparador() {
    return Container(
      height: 20,
    );
  }

  Widget _boton(CroquisProvider croquisProvider) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (croquisProvider.coordenadas == null) {
            return displayDialogAndroid(
              "Falta ubicación",
              "Debes de crear un marcador de ubicación",
              const Icon(
                Icons.location_off_outlined,
                size: 60.0,
              ),
            );
          }

          if (croquisProvider.foto == null) {
            return displayDialogAndroid(
              "Falta fotografía",
              "Debes de agregar una fotografía",
              const Icon(
                Icons.add_photo_alternate_outlined,
                size: 60.0,
              ),
            );
          }

          Navigator.pushNamed(context, "finalizar");
          setState(() {});
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  void displayDialogAndroid(String mensaje, String contenido, Icon icono) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: Center(child: Text(mensaje)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                icono,
                const SizedBox(height: 30),
                Text(
                  contenido,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  void displayDialogAndroidPhoto(CroquisProvider croquisProvider) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text("Sube una imagen")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Foto desde galeria"),
                    Semantics(
                      label: "Desde galeria",
                      child: FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          try {
                            final pickerGallery = ImagePicker();

                            final XFile? photo = await pickerGallery.pickImage(
                                source: ImageSource.gallery);

                            if (photo == null) return;
                            Navigator.pop(context);

                            croquisProvider.foto = photo;

                            setState(() {});
                            // ignore: empty_catches
                          } catch (e) {}
                        },
                        heroTag: 'image0',
                        tooltip: 'Agrega una imagen desde la galeria',
                        child: const Icon(Icons.photo_library_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("   Toma una foto   "),
                    Semantics(
                      label: "Toma una fotografia",
                      child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () async {
                            try {
                              final _pickerCamera = ImagePicker();

                              final XFile? photo = await _pickerCamera
                                  .pickImage(source: ImageSource.camera);

                              if (photo == null) return;

                              final bytes = File(photo.path).readAsBytesSync();

                              String base64Image = base64Encode(bytes);

                              croquisProvider.foto = photo;
                              croquisProvider.fotoBase64 = base64Image;

                              Navigator.pop(context);

                              setState(() {});
                            } catch (e) {
                              Navigator.pop(context);

                              displayDialogAndroid(
                                  "Sin acceso a camara",
                                  "Sube una foto desde tu galeria",
                                  const Icon(
                                    Icons.photo_size_select_actual_rounded,
                                    size: 60.0,
                                  ));
                            }
                          },
                          heroTag: 'image1',
                          tooltip: 'Fotografia desde camara',
                          child: const Icon(Icons.camera_alt_outlined)),
                    ),
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }
}
