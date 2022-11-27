import 'package:fichas/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/codigo_postal.services.dart';

class UbicacionSitioPage extends StatefulWidget {
  const UbicacionSitioPage({Key? key}) : super(key: key);

  @override
  State<UbicacionSitioPage> createState() => _UbicacionSitioPageState();
}

class _UbicacionSitioPageState extends State<UbicacionSitioPage> {
  String dropdownValueGeneradores = "";
  @override
  Widget build(BuildContext context) {
    final ubicacionProvider = Provider.of<UbicacionSitioProvider>(context);
    final codigoPostalServices = Provider.of<CodigoPostalServices>(context);
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
                child: Text("     UBICACIÓN DEL SITIO"),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: ubicacionProvider.formUbicacionKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                _crearInputDireccion(ubicacionProvider),
                _contruirSeparador(),
                _crearInputCodigoPostal(
                    ubicacionProvider, codigoPostalServices, context),
                _contruirSeparador(),
                _inputBarrio(ubicacionProvider, codigoPostalServices),
                _contruirSeparador(),
                _inputDelegacion(ubicacionProvider, codigoPostalServices),
                _contruirSeparador(),
                _crearInputEstado(ubicacionProvider, codigoPostalServices),
                _contruirSeparador(),
                _crearInputEntreCalles(ubicacionProvider),
                _contruirSeparador(),
                _crearInputNombreSItio(ubicacionProvider),
                _contruirSeparador(),
                _boton(ubicacionProvider, context),
              ],
            )),
      ),
    );
  }

  Widget _inputBarrio(
      ubicacionProvider, CodigoPostalServices codigoPostalServices) {
    dropdownValueGeneradores = "";

    final barrios = codigoPostalServices.devolverBarrios();
    if (barrios.length == 1) {
      final TextEditingController _inputFieldColoniaController =
          TextEditingController();

      _inputFieldColoniaController.text = barrios[0];
      ubicacionProvider.colonia = barrios[0];

      return TextField(
        readOnly: true,
        controller: _inputFieldColoniaController,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(0.2),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Colonia o barrio",
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
    } else {
      return DropdownButtonFormField<String>(
        menuMaxHeight: 500,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(0.2),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Colonia o barrio",
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        onChanged: (String? newValue) {
          ubicacionProvider.colonia = newValue;
          setState(() {
            dropdownValueGeneradores = newValue!;
          });
        },
        items: barrios.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(dropdownValueGeneradores),
        validator: (value) {
          return value == null ? "Debes de ingresar un estado" : null;
        },
      );
    }
  }

  Widget _inputDelegacion(UbicacionSitioProvider ubicacionProvider,
      CodigoPostalServices codigoPostalServices) {
    dropdownValueGeneradores = "";

    final delegaciones = codigoPostalServices.devolverDelegacion();
    if (delegaciones.length == 1) {
      final TextEditingController _inputFieldDelegacionesController =
          TextEditingController();

      _inputFieldDelegacionesController.text = delegaciones[0];
      ubicacionProvider.delegacion = delegaciones[0];

      return TextField(
        readOnly: true,
        controller: _inputFieldDelegacionesController,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(0.2),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Delegacion o municipio",
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
    } else {
      return DropdownButtonFormField<String>(
        menuMaxHeight: 500,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(0.2),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Delegacion o municipio",
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        onChanged: (newValue) {
          ubicacionProvider.delegacion = newValue!;
          setState(() {
            dropdownValueGeneradores = newValue;
          });
        },
        items: delegaciones.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(dropdownValueGeneradores),
        validator: (value) {
          return value == null ? "Debes de ingresar un estado" : null;
        },
      );
    }
  }
}

Widget _contruirSeparador() {
  return Container(
    height: 20,
  );
}

Widget _crearInputDireccion(ubicacionProvider) {
  return TextFormField(
    decoration: InputDecoration(
      prefixIcon: const Padding(
        padding: EdgeInsets.all(0.2),
        child: Icon(
          Icons.location_on_outlined,
          color: Colors.grey,
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      labelText: "Dirección",
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    onChanged: (value) => ubicacionProvider.direccion = value,
    validator: (value) {
      return value!.isEmpty ? "Debes de ingresar la dirección" : null;
    },
  );
}

Widget _crearInputEntreCalles(ubicacionProvider) {
  return Column(
    children: [
      TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(0.2),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Entre calle",
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        onChanged: (value) => ubicacionProvider.calle1 = value,
        validator: (value) {
          return value!.isEmpty ? "Debes de ingresar la calle" : null;
        },
      ),
      Container(
        height: 10,
      ),
      const Text(
        "Y",
        style: TextStyle(fontSize: 17),
      ),
      Container(
        height: 10,
      ),
      TextFormField(
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.all(0.2),
              child: Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
              ),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: "Calle",
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          onChanged: (value) => ubicacionProvider.calle2 = value,
          validator: (value) {
            return value!.isEmpty ? "Debes de ingresar la calle" : null;
          }),
    ],
  );
}

Widget _crearInputNombreSItio(ubicacionProvider) {
  return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Nombre del sitio",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => ubicacionProvider.nombreSitio = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar el nombre del sitio" : null;
      });
}

Widget _crearInputEstado(UbicacionSitioProvider ubicacionProvider,
    CodigoPostalServices codigoPostalServices) {
  final TextEditingController _inputFieldEstadoController =
      TextEditingController();

  _inputFieldEstadoController.text = codigoPostalServices.estado;
  ubicacionProvider.estado = codigoPostalServices.estado;

  return TextField(
    enableInteractiveSelection: false,
    readOnly: true,
    controller: _inputFieldEstadoController,
    decoration: InputDecoration(
      prefixIcon: const Padding(
        padding: EdgeInsets.all(0.2),
        child: Icon(
          Icons.location_on_outlined,
          color: Colors.grey,
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      labelText: "Estado",
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
  );
}

Widget _crearInputCodigoPostal(UbicacionSitioProvider ubicacionProvider,
    CodigoPostalServices codigoPostalServices, BuildContext context) {
  return TextFormField(
      maxLength: 5,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.all(0.2),
          child: Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Código postal",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) async {
        if (value.length == 4 || value.length == 5) {
          ubicacionProvider.codigoPostal = value;
          final bool respuestaPostal = await codigoPostalServices.loadPostal(
              ubicacionProvider.codigoPostal, context);
          if (!respuestaPostal) {
            displayDialogInternet(context);
          }
        } else {
          codigoPostalServices.limpiarListas();
          ubicacionProvider.colonia = "";
          ubicacionProvider.delegacion = "";
          ubicacionProvider.estado = "";
        }
      },
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar el código postal" : null;
      });
}

Widget _boton(ubicacionProvider, context) {
  return Center(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.red,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (!ubicacionProvider.isValidForm()) return;
        Navigator.pushReplacementNamed(context, "datosLocal");
      },
      child: const Text("SIGUIENTE"),
    ),
  );
}

void displayDialogInternet(context) {
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
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ))
          ],
        );
      });
}
