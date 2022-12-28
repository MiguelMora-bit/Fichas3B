import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/misiones_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final misionesService = Provider.of<MisionesServices>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _boton(misionesService),
      ),
    );
  }

  Widget _boton(misionesService) {
    return Column(
      children: [
        _separador(),
        _logo(),
        _texto(),
        _imagenTienda(),
        Expanded(
          child: Column(
            children: [
              _botonRegistrar(),
              _botonRevisar(),
              _botonMisiones(misionesService)
            ],
          ),
        )
      ],
    );
  }

  Widget _botonRegistrar() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "introduction");
        },
        child: const Text("  REGISTRA UNA FICHA  "),
      ),
    );
  }

  Widget _botonRevisar() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "estadoFichas");
        },
        child: const Text("ESTADO DE TUS FICHAS"),
      ),
    );
  }

  Widget _botonMisiones(misionesService) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "lista_misiones");
        },
        child: const Text("              MISIONES            "),
      ),
    );
  }

  Widget _separador() {
    return Container(
      height: 30,
    );
  }

  Widget _logo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Image.asset(
        "assets/Logo3B.png",
        height: 100.0,
        width: 100.0,
      ),
    );
  }

  Widget _texto() {
    return Column(
      children: [
        const Text("“Una tienda nueva ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("nuevas familas ahorrando”",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Center(
              child: Text("y tu ganando ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      color: Colors.red)),
            ),
          ],
        )
      ],
    );
  }

  Widget _imagenTienda() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Lottie.asset('assets/tienda.json', width: 250, height: 250),
    );
  }
}
