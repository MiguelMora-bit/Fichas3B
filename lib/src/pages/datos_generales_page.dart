import 'package:fichas/widgets/customAppbar.dart';
import 'package:fichas/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:fichas/providers/colaborador_provider.dart';
import 'package:fichas/services/empleados_services.dart';

import '../Theme/light_theme.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GeneralPageState();
  }
}

class _GeneralPageState extends State<GeneralPage> {
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

    return Scaffold(
      appBar: AppBar(title: const CustomAppBar(name: "DATOS DEL COLABORADOR")),
      body: Form(
        key: colaboradorProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _crearInputNumEmpleado(colaboradorProvider),
            _datosEmpleado(colaboradorProvider, empleadosService),
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
            _botones(context, colaboradorProvider, empleadosService)
          ],
        ),
      ),
    );
  }

  Widget _crearInputColaborador() {
    return CustomTextFormField(
      readOnly: true,
      controller: _inputFieldColaboradorController,
      decoration: AppTheme.customImputDecoration(
          icono: Icons.person_outline, label: 'Nombre'),
    );
  }

  Widget _crearInputNumEmpleado(colaboradorProvider) {
    return CustomTextFormField(
        readOnly: isReadNumEmpleado,
        onChanged: (value) => colaboradorProvider.numeroEmpleado = value,
        validator: (value) {
          return (value == null || value.isEmpty)
              ? "Debes de ingresar el número de empleado"
              : null;
        },
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        textInputType: TextInputType.number,
        decoration: AppTheme.customImputDecoration(
            icono: Icons.account_box_outlined, label: "Número de empleado"));
  }

  Widget _crearInputTienda() {
    return CustomTextFormField(
        readOnly: true,
        controller: _inputFieldTiendaController,
        decoration: AppTheme.customImputDecoration(
            icono: Icons.store_outlined, label: "Tienda"));
  }

  Widget _crearInputCorreo(ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    return CustomTextFormField(
      readOnly: true,
      controller: _inputFieldCorreoController,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.all(0.2),
          child: IconButton(
            icon: const Icon(
              Icons.edit,
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
    return CustomTextFormField(
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
    return CustomTextFormField(
        readOnly: true,
        controller: _inputFieldCargoController,
        decoration: AppTheme.customImputDecoration(
            icono: Icons.work_outline_outlined, label: "Puesto"));
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
      EmpleadosServices empleadosService) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          colaboradorProvider.correoElectronico.isEmpty
              ? _openDialogCorreo(
                  context, colaboradorProvider, empleadosService)
              : colaboradorProvider.celular.isEmpty
                  ? _openDialogCelular(
                      context, colaboradorProvider, empleadosService)
                  : Navigator.pushNamed(context, "ubicacionSitio");
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
          _crearInputColaborador(),
          _crearInputPuesto(),
          _crearInputTienda(),
          if (colaboradorProvider.correoElectronico.isNotEmpty)
            _crearInputCorreo(colaboradorProvider, empleadosService),
          if (colaboradorProvider.celular.isNotEmpty)
            _crearInputCelular(colaboradorProvider, empleadosService),
        ],
      ),
    );
  }

  Widget _botones(BuildContext context, ColaboradorProvider colaboradorProvider,
      EmpleadosServices empleadosService) {
    return Visibility(
      visible: isVisibleButtons,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _botonRegresar(),
          _botonConfirmar(context, colaboradorProvider, empleadosService)
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
            title: const Center(child: Text('Error')),
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
                  'Número de empleado',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'no encontrado',
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

  Widget _crearInputSolicitarCorreo(ColaboradorProvider colaboradorProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      decoration: AppTheme.customImputDecoration(
          icono: Icons.email_outlined, label: "Correo electronico"),
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
