import 'dart:async';
import 'dart:io';

import 'package:fichas/providers/croquis_foto_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CroquisPage extends StatefulWidget {
  const CroquisPage({Key? key}) : super(key: key);

  @override
  _CroquisPageState createState() => _CroquisPageState();
}

class _CroquisPageState extends State<CroquisPage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> myMarker = [];
  Set<Marker> markers = <Marker>{};
  Position? currenPosition;
  Marker? marcador;
  var geoLocator = Geolocator();

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

    const CameraPosition _puntoInicial = CameraPosition(
      target: LatLng(23.0000000, -102.0000000),
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
          Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: _construirCroquis(
                  _puntoInicial, marcador, croquisProvider, locatePosition)),
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
      Marker? marcador,
      CroquisProvider croquisProvider,
      void Function(dynamic controller) locatePosition) {
    myMarker.isNotEmpty
        ? croquisProvider.coordenadas = myMarker[0].position.toString()
        : null;
    marcador != null
        ? croquisProvider.coordenadas = marcador.position.toString()
        : null;
    return SizedBox(
      height: 500,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _puntoInicial,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          locatePosition(controller);
        },
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
        markers: markers.isEmpty ? Set.from(myMarker) : markers,
        onTap: _handleTap,
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
    });
  }

  Widget _fotografia(CroquisProvider croquisProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            height: 500,
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
                final _picker = ImagePicker();

                final XFile? photo =
                    await _picker.pickImage(source: ImageSource.camera);

                if (photo == null) return;

                croquisProvider.foto = photo;
                setState(() {});
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
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          if (croquisProvider.coordenadas == null) {
            return displayDialogAndroid(
                "Falta ubicación", "Debes de crear un marcador de ubicación");
          }

          if (croquisProvider.foto == null) {
            return displayDialogAndroid(
                "Falta fotografía", "Debes de agregar una fotografía");
          }

          Navigator.pushReplacementNamed(context, "fortalezasDebilidades");
          setState(() {});
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  void displayDialogAndroid(String mensaje, String contenido) {
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
                Text(
                  contenido,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
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
