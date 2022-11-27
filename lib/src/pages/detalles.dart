import 'package:fichas/services/fichas_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Detalles extends StatefulWidget {
  const Detalles({Key? key}) : super(key: key);

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  String dropdownValueGeneradores = "";
  @override
  Widget build(BuildContext context) {
    final fichasService = Provider.of<FichasService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                child: Text(
                    "                               Ficha: ${fichasService.selectedFicha.folio}"),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              _seccionFolio(fichasService),
              _crearSepador(),
              _seccionComentario(fichasService)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _crearSepador() {
  return const SizedBox(
    height: 30,
  );
}

Widget _seccionFolio(FichasService fichasServices) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    decoration: _cardBorders(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: const Text(
            "Datos sobre la ficha",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ListTile(
          title: const Text("Folio:"),
          subtitle: Text(fichasServices.selectedFicha.folio),
        ),
      ],
    ),
  );
}

Widget _seccionComentario(FichasService fichasServices) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    decoration: _cardBorders(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: const Text(
            "Comentarios",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ListTile(
          title: const Text("Comentario primer etapa:"),
          subtitle: Text(fichasServices.selectedFicha.comentario!),
        ),
      ],
    ),
  );
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(0, 7), blurRadius: 10)
        ]);
