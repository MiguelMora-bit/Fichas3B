import 'package:fichas/services/fichas_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fichas/providers/colaborador_provider.dart';
import 'package:fichas/services/empleados_services.dart';

class ColaboradorStadoPage extends StatefulWidget {
  const ColaboradorStadoPage({Key? key}) : super(key: key);

  @override
  _ColaboradorStadoPageState createState() => _ColaboradorStadoPageState();
}

class _ColaboradorStadoPageState extends State<ColaboradorStadoPage> {
  bool isVisible = false;
  bool isVisibleButtons = false;
  bool isVisibleSiguiente = true;
  bool isReadNumEmpleado = false;

  final TextEditingController _inputFieldColaboradorController =
      TextEditingController();

  final TextEditingController _inputFieldTiendaController =
      TextEditingController();

  final TextEditingController _inputFieldCargoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final empleadosService = Provider.of<EmpleadosServices>(context);

    final colaboradorProvider = Provider.of<ColaboradorProvider>(context);

    final fichasService = Provider.of<FichasService>(context);

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
              width: 50,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("  FICHAS DEL COLABORADOR"),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: colaboradorProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          children: [
            _crearInputNumEmpleado(colaboradorProvider),
            _datosEmpleado(),
            _contruirSeparador(),
            Visibility(
              visible: isVisibleSiguiente,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.red,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (!colaboradorProvider.isValidForm()) return;

                    var getEmpleado = await (empleadosService
                        .loadEmpleado(colaboradorProvider.numeroEmpleado));

                    if (getEmpleado == null) return displayDialogAndroid();
                    colaboradorProvider.nombreEmpleado = getEmpleado["Nombre"];
                    colaboradorProvider.puesto = getEmpleado["Puesto"];
                    colaboradorProvider.tienda = getEmpleado["Tienda"];

                    setState(() {
                      _inputFieldColaboradorController.text =
                          getEmpleado["Nombre"];
                      _inputFieldTiendaController.text = getEmpleado["Tienda"];
                      _inputFieldCargoController.text = getEmpleado["Puesto"];

                      isVisible = true;
                      isReadNumEmpleado = true;
                      isVisibleButtons = true;
                      isVisibleSiguiente = false;
                    });
                  },
                  child: const Text("SIGUIENTE"),
                ),
              ),
            ),
            _contruirSeparador(),
            _botones(empleadosService, colaboradorProvider, fichasService)
          ],
        ),
      ),
    );
  }

  Widget _contruirSeparador() {
    return Container(
      height: 20,
    );
  }

  Widget _crearInputColaborador() {
    return TextField(
      readOnly: true,
      controller: _inputFieldColaboradorController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Nombre",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _crearInputNumEmpleado(colaboradorProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      readOnly: isReadNumEmpleado,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Número de empleado",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => colaboradorProvider.numeroEmpleado = value,
      validator: (value) {
        return value!.isEmpty
            ? "Debes de ingresar el número de empleado"
            : null;
      },
    );
  }

  Widget _crearInputTienda() {
    return TextField(
      enableInteractiveSelection: false,
      readOnly: true,
      controller: _inputFieldTiendaController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Tienda",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _crearInputPuesto() {
    return TextField(
      enableInteractiveSelection: false,
      readOnly: true,
      controller: _inputFieldCargoController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Puesto",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _botonRegresar() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isVisible = false;
            isVisibleButtons = false;
            isReadNumEmpleado = false;
            isVisibleSiguiente = true;
          });
        },
        child: const Text("REGRESAR"),
      ),
    );
  }

  Widget _botonConfirmar(EmpleadosServices empleadosService,
      ColaboradorProvider colaboradorProvider, FichasService fichasService) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () async {
          fichasService.loadFichasEmpleado(await empleadosService
              .obtenerFichasEmpleado(colaboradorProvider.numeroEmpleado));
          Navigator.pushReplacementNamed(context, "listadoFichas");
        },
        child: const Text("CONFIRMAR"),
      ),
    );
  }

  Widget _datosEmpleado() {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          _contruirSeparador(),
          _crearInputColaborador(),
          _contruirSeparador(),
          _crearInputPuesto(),
          _contruirSeparador(),
          _crearInputTienda(),
        ],
      ),
    );
  }

  Widget _botones(EmpleadosServices empleadosService,
      ColaboradorProvider colaboradorProvider, FichasService fichasService) {
    return Visibility(
      visible: isVisibleButtons,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _botonRegresar(),
          _botonConfirmar(empleadosService, colaboradorProvider, fichasService)
        ],
      ),
    );
  }

  void displayDialogAndroid() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Empleado no encontrado')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Número de empleado incorrecto',
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
}
