import 'package:fichas/providers/generadores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GeneradoresPage extends StatefulWidget {
  const GeneradoresPage({Key? key}) : super(key: key);

  @override
  _GeneradoresPageState createState() => _GeneradoresPageState();
}

class _GeneradoresPageState extends State<GeneradoresPage> {
  String dropdownValueGeneradores = "";

  @override
  Widget build(BuildContext context) {
    final generadoresProvider = Provider.of<GeneradoresProvider>(context);
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
                child: Text("        GENERADORES"),
              ),
            ),
          ],
        ),
      ),
      body: generadoresProvider.generadores.isEmpty
          ? const Center(
              child: Text(
                "No hay generadores",
                style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              children: [
                ..._crearItems(generadoresProvider),
                if (generadoresProvider.generadores.length >= 2) _boton()
              ],
            ),
      floatingActionButton: _botonAgregar(generadoresProvider),
    );
  }

  Widget _contruirSeparador() {
    return Container(
      height: 20,
    );
  }

  Widget _inputGeneradores(generadoresProvider) {
    dropdownValueGeneradores = "";
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Generadores",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (String? newValue) {
        generadoresProvider.generador = newValue;
        setState(() {
          dropdownValueGeneradores = newValue!;
        });
      },
      items: <String>[
        "Mercado",
        "Iglesia",
        "Oficina de Gobierno",
        "Estación de Metro",
        "Parada pecero",
        "Banco",
        "Hospital",
        "Escuela"
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

  Widget _crearInputDistancia(generadoresProvider) {
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
      onChanged: (value) => generadoresProvider.distancia = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar la distancia" : null;
      },
    );
  }

  void _displayDialogIntrucciones() {
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
                  'Indica los competidores directos',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
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
          Navigator.pushReplacementNamed(context, "competencias");
          _displayDialogIntrucciones();
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  Widget _botonAgregar(GeneradoresProvider generadoresProvider) {
    return FloatingActionButton(
      onPressed: () => _openDialog(generadoresProvider),
      child: const Icon(Icons.add),
      backgroundColor: Colors.red,
      elevation: 0,
    );
  }

  void _openDialog(GeneradoresProvider generadoresProvider) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Agregar generador')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Form(
              key: generadoresProvider.formGeneradoresKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: MediaQuery.of(context).size.width - 2),
                  _inputGeneradores(generadoresProvider),
                  _contruirSeparador(),
                  _crearInputDistancia(generadoresProvider),
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

                    if (!generadoresProvider.isValidForm()) return;

                    setState(() {
                      generadoresProvider.generadores.add({
                        "id": generadoresProvider.generadores.length,
                        "generador": generadoresProvider.generador,
                        "distancia": generadoresProvider.distancia
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar'))
            ],
          );
        });
  }

  List _crearItems(generadoresProvider) {
    List temporal = [];

    for (Map<String, dynamic> generador in generadoresProvider.generadores) {
      Widget item = ListTile(
        title: Text("${generador["generador"]}"),
        subtitle: Text(("Distancia: ${generador["distancia"]} metros")),
        isThreeLine: true,
        trailing: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onTap: () {
          setState(() {
            generadoresProvider.generadores.removeWhere(
                (currenItem) => currenItem["id"] == generador["id"]);
          });
        },
      );
      temporal.add(item);
    }
    return temporal;
  }
}
