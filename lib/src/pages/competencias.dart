import 'package:fichas/providers/competencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompetenciasPage extends StatefulWidget {
  const CompetenciasPage({Key? key}) : super(key: key);

  @override
  _CompetenciasPageState createState() => _CompetenciasPageState();
}

class _CompetenciasPageState extends State<CompetenciasPage> {
  String dropdownValueGeneradores = "";

  @override
  Widget build(BuildContext context) {
    final competenciasProvider = Provider.of<CompetenciasProvider>(context);
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
                child: Text("        COMPETENCIAS"),
              ),
            ),
          ],
        ),
      ),
      body: competenciasProvider.competencias.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "No hay competidores",
                      style:
                          TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                _boton(competenciasProvider),
                const SizedBox(
                  height: 100,
                )
              ],
            )
          : ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              children: [
                _contruirSeparador(),
                ..._crearItems(competenciasProvider),
                _boton(competenciasProvider)
              ],
            ),
      floatingActionButton: _botonAgregar(competenciasProvider),
    );
  }

  Widget _contruirSeparador() {
    return Container(
      height: 20,
    );
  }

  Widget _inputGeneradores(competenciasProvider) {
    dropdownValueGeneradores = "";
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Competidores",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (String? newValue) {
        competenciasProvider.competidor = newValue;
        setState(() {
          dropdownValueGeneradores = newValue!;
        });
      },
      items: <String>[
        "Abarrotera local",
        "Aurrera express",
        "Chedraui",
        "Neto",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text(dropdownValueGeneradores),
      validator: (value) {
        return value == null ? "Debes de ingresar un valor" : null;
      },
    );
  }

  Widget _crearInputDistancia(competenciasProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Distancia",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => competenciasProvider.distancia = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar la distancia" : null;
      },
    );
  }

  Widget _boton(CompetenciasProvider competenciasProvider) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          if (competenciasProvider.competencias.isEmpty) {
            return displayDialogConfirmation();
          }

          Navigator.pushReplacementNamed(context, "conteos");
          _displayIntructions();
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  Widget _botonAgregar(CompetenciasProvider competenciasProvider) {
    return FloatingActionButton(
      onPressed: () => _openDialog(competenciasProvider),
      child: const Icon(Icons.add),
      backgroundColor: Colors.red,
      elevation: 0,
    );
  }

  void _openDialog(CompetenciasProvider competenciasProvider) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Agregar competidor')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Form(
              key: competenciasProvider.formCompetenciasKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: MediaQuery.of(context).size.width - 2),
                  _inputGeneradores(competenciasProvider),
                  _contruirSeparador(),
                  _crearInputDistancia(competenciasProvider),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (!competenciasProvider.isValidForm()) return;

                    setState(() {
                      competenciasProvider.competencias.add({
                        "id": competenciasProvider.competencias.length,
                        "competidor": competenciasProvider.competidor,
                        "distancia": competenciasProvider.distancia
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar'))
            ],
          );
        });
  }

  void displayDialogConfirmation() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Confirmación')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('¿No hay competidores?'),
                SizedBox(height: 30),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "conteos");
                    _displayIntructions();
                  },
                  child: const Text('Aceptar')),
            ],
          );
        });
  }

  void _displayIntructions() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Instrucciones')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Registra el número de posibles clientes',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Mínimo 2 conteos',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Cada conteo dura 10 minutos',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
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

  List _crearItems(competenciasProvider) {
    List temporal = [];

    for (Map<String, dynamic> competidor in competenciasProvider.competencias) {
      Widget item = ListTile(
        title: Text("${competidor["competidor"]}"),
        subtitle: Text(("Distancia: ${competidor["distancia"]} metros")),
        isThreeLine: true,
        trailing: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onTap: () {
          setState(() {
            competenciasProvider.competencias.removeWhere(
                (currenItem) => currenItem["id"] == competidor["id"]);
          });
        },
      );
      temporal.add(item);
    }
    return temporal;
  }
}
