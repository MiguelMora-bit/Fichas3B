import 'package:fichas/providers/conteos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConteoPage extends StatefulWidget {
  const ConteoPage({Key? key}) : super(key: key);

  @override
  _ConteoPageState createState() => _ConteoPageState();
}

class _ConteoPageState extends State<ConteoPage> {
  String dropdownValueGeneradores = "";

  @override
  Widget build(BuildContext context) {
    final conteosProvider = Provider.of<ConteosProvider>(context);
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
              width: 120,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("              CONTEO"),
              ),
            ),
          ],
        ),
      ),
      body: conteosProvider.conteos.isEmpty
          ? const Center(
              child: Text(
                "No hay conteos",
                style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              children: [
                _contruirSeparador(),
                ..._crearItems(conteosProvider),
                conteosProvider.conteos.length >= 2
                    ? _boton()
                    : _contruirSeparador(),
              ],
            ),
      floatingActionButton: _botonAgregar(conteosProvider),
    );
  }

  Widget _contruirSeparador() {
    return Container(
      height: 20,
    );
  }

  Widget _boton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "croquis");
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  Widget _botonAgregar(ConteosProvider conteosProvider) {
    return FloatingActionButton(
      onPressed: () =>
          {Navigator.pushReplacementNamed(context, "agregarConteo")},
      child: const Icon(Icons.add),
      backgroundColor: Colors.red,
      elevation: 0,
    );
  }

  List _crearItems(conteosProvider) {
    List temporal = [];

    for (Map<String, dynamic> conteo in conteosProvider.conteos) {
      Widget item = ListTile(
        title: Text("Conteo ${conteo["id"] + 1}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${conteo["fecha"]}"),
            Text(("Personas: ${conteo["personas"]}")),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onTap: () {
          setState(() {
            conteosProvider.conteos
                .removeWhere((currenItem) => currenItem["id"] == conteo["id"]);
          });
        },
      );
      temporal.add(item);
    }
    return temporal;
  }
}
