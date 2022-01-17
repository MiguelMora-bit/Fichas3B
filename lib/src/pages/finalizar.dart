import 'package:flutter/material.dart';

class FinalizarPage extends StatelessWidget {
  const FinalizarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              width: 140,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("          FINALIZAR"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _felicidades(),
          _boton(context),
        ],
      ),
    );
  }

  Widget _felicidades() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
      child: Column(children: const [
        Center(child: Text("¡FELICIDADES!")),
        Text("HAS LLENADO CORRECTAMENTE TU FICHA")
      ]),
    );
  }

  Widget _boton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "home");
        },
        child: const Text("ENVIAR"),
      ),
    );
  }
}
