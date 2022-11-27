import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/generadores_provider.dart';
import '../../widgets/card_table.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Card Table
              const CardTable(),
              _boton(generadoresProvider)
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
            title: const Center(
                child: Text('Confirmación',
                    style: TextStyle(color: Colors.black))),
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
                Text('¿Estas seguro de agregar estos generadores?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
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
                    Navigator.pushReplacementNamed(context, "competencias");
                    _displayDialogIntrucciones();
                  },
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black))),
            ],
          );
        });
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
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 60.0,
                ),
                SizedBox(height: 30),
                Text('Indica los competidores',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
                Text('directos',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  void _displayDialogErrores() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(
                child: Text('Error', style: TextStyle(color: Colors.black))),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 20),
                Icon(
                  Icons.error_outline_outlined,
                  size: 60.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Necesitas agregar como mínimo',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '2 generadores',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  Widget _boton(GeneradoresProvider generadoresProvider) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          generadoresProvider.validacionAvanzar()
              ? displayDialogConfirmation()
              : _displayDialogErrores();
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }
}
