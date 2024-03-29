import 'package:fichas/services/fichas_services.dart';
import 'package:fichas/src/theme/light_theme.dart';
import 'package:fichas/widgets/customTextFormField.dart';
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

  final TextEditingController _inputFieldCorreoController =
      TextEditingController();

  final TextEditingController _inputFieldCelularController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final empleadosService = Provider.of<EmpleadosServices>(context);

    final colaboradorProvider = Provider.of<ColaboradorProvider>(context);

    final fichasService = Provider.of<FichasService>(context);

    return Scaffold(
      appBar: AppBar(
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
                child: Text("DATOS DEL COLABORADOR"),
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
            _datosEmpleado(colaboradorProvider, empleadosService),
            _contruirSeparador(),
            Visibility(
              visible: isVisibleSiguiente,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (!colaboradorProvider.isValidForm()) return;

                    var getEmpleado = await empleadosService.loadEmpleado(
                        colaboradorProvider.numeroEmpleado, context);

                    if (getEmpleado == null) return displayDialogAndroid();

                    if (getEmpleado.isEmpty) {
                      return displayDialogInternet();
                    }

                    colaboradorProvider.nombreEmpleado = getEmpleado["Nombre"];
                    colaboradorProvider.puesto = getEmpleado["Puesto"];
                    colaboradorProvider.tienda = getEmpleado["Tienda"];
                    colaboradorProvider.correoElectronico =
                        getEmpleado["correo"] ?? "";
                    colaboradorProvider.celular = getEmpleado["celular"] ?? "";

                    setState(() {
                      _inputFieldColaboradorController.text =
                          getEmpleado["Nombre"];
                      _inputFieldTiendaController.text = getEmpleado["Tienda"];
                      _inputFieldCargoController.text = getEmpleado["Puesto"];
                      _inputFieldCelularController.text =
                          getEmpleado["celular"] ?? "";
                      _inputFieldCorreoController.text =
                          getEmpleado["correo"] ?? "";

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
            _botones(
                context, colaboradorProvider, empleadosService, fichasService)
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
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
        ),
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
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.emoji_people_outlined,
            color: Colors.grey,
          ),
        ),
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
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.store_outlined,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Tienda",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _crearInputCorreo(ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    return TextField(
      enableInteractiveSelection: false,
      readOnly: true,
      controller: _inputFieldCorreoController,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.all(0.2),
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.grey,
            ),
            onPressed: () => {
              _openDialogCorreo(context, colaboradorProvider, empleadosService)
            },
          ),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.email_outlined,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Correo",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _crearInputCelular(ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    return TextField(
      readOnly: true,
      controller: _inputFieldCelularController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.edit,
          ),
          onPressed: () => {
            _openDialogCelular(context, colaboradorProvider, empleadosService)
          },
        ),
        prefixIcon: const Icon(
          Icons.phone_android_outlined,
          color: Colors.black,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Numero celular",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _crearInputPuesto() {
    return TextFormField(
      enableInteractiveSelection: false,
      readOnly: true,
      controller: _inputFieldCargoController,
      decoration: AppTheme.customImputDecoration(
          icono: Icons.work_outline_outlined, label: "Puesto"),
    );
  }

  Widget _botonRegresar() {
    return Center(
      child: ElevatedButton(
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

  Widget _botonConfirmar(
      BuildContext context,
      ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService,
      FichasService fichasService) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          colaboradorProvider.correoElectronico.isEmpty
              ? _openDialogCorreo(
                  context, colaboradorProvider, empleadosService)
              : {
                  fichasService.loadFichasEmpleado(
                      await empleadosService.obtenerFichasEmpleado(
                          colaboradorProvider.numeroEmpleado)),
                  Navigator.pushNamed(context, "listadoFichas")
                };
        },
        child: const Text("CONFIRMAR"),
      ),
    );
  }

  Widget _datosEmpleado(ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
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
          _contruirSeparador(),
          if (colaboradorProvider.correoElectronico.isNotEmpty)
            _crearInputCorreo(colaboradorProvider, empleadosService),
          if (colaboradorProvider.celular.isNotEmpty) ...[
            _contruirSeparador(),
            _crearInputCelular(colaboradorProvider, empleadosService),
          ]
        ],
      ),
    );
  }

  void _openDialogCelular(context, ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (celularContext) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Telefono celular')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Form(
              key: colaboradorProvider.formKeyCelular,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: MediaQuery.of(context).size.width - 2),
                  const Text(
                    "Ingresa tu numero de celular",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _crearInputSolicitarCelular(colaboradorProvider),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (!colaboradorProvider.isValidFormCelular()) return;

                    Navigator.pop(celularContext);

                    final bool responseCelular =
                        await empleadosService.updateCelular(
                            colaboradorProvider.numeroEmpleado,
                            colaboradorProvider.celular,
                            context);

                    if (!responseCelular) {
                      return displayDialogInternet();
                    }

                    _inputFieldCelularController.text =
                        colaboradorProvider.celular;

                    setState(() {});
                  },
                  child: const Text('Agregar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  Widget _crearInputSolicitarCelular(ColaboradorProvider colaboradorProvider) {
    return TextFormField(
      decoration: AppTheme.customImputDecoration(
        icono: Icons.phone_android,
        label: "Celular",
      ),
      onChanged: (value) => colaboradorProvider.celular = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar tu número celular" : null;
      },
    );
  }

  Widget _botones(BuildContext context, ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService, FichasService fichasService) {
    return Visibility(
      visible: isVisibleButtons,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _botonRegresar(),
          _botonConfirmar(
              context, colaboradorProvider, empleadosService, fichasService)
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

  void _openDialogCorreo(context, ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (correoContext) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Correo electronico')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Form(
              key: colaboradorProvider.formKeyCorreo,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: MediaQuery.of(context).size.width - 2),
                  const Text(
                    "Ingresa tu correo electronico personal",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _crearInputSolicitarCorreo(colaboradorProvider),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (!colaboradorProvider.isValidFormCorreo()) return;

                    Navigator.pop(correoContext);

                    final bool responseCorreo =
                        await empleadosService.updateCorreo(
                            colaboradorProvider.numeroEmpleado,
                            colaboradorProvider.correoElectronico,
                            context);

                    if (!responseCorreo) {
                      return displayDialogInternet();
                    }

                    _inputFieldCorreoController.text =
                        colaboradorProvider.correoElectronico;

                    setState(() {});
                  },
                  child: const Text('Agregar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  Widget _crearInputSolicitarCorreo(ColaboradorProvider colaboradorProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Correo electronico",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => colaboradorProvider.correoElectronico = value,
      validator: (value) {
        return value!.isEmpty
            ? "Debes de ingresar tu correo electronico "
            : !colaboradorProvider.validateEmail()
                ? "Debes de ingresar un correo valido"
                : null;
      },
    );
  }

  void displayDialogInternet() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Sin conexión a internet')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 20),
                Icon(
                  Icons.wifi_off_rounded,
                  size: 60.0,
                ),
                SizedBox(height: 30),
                Text(
                  'Upsss, no tienes internet, intenta más tarde',
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
}
