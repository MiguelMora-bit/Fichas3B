import 'package:fichas/widgets/card_table%20competencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/competencias_provider.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Card Table
              const CardTableCompetencias(),
              _boton(competenciasProvider)
            ],
          ),
        ));
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
                SizedBox(height: 20),
                Icon(
                  Icons.save,
                  size: 60.0,
                ),
                SizedBox(height: 30),
                Text(
                  '¿Estas seguro de agregar estos competidores?',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.black))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "croquis");
                  },
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black))),
            ],
          );
        });
  }

  Widget _boton(CompetenciasProvider competenciasProvider) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          displayDialogConfirmation();
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }
}
