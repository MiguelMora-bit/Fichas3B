import 'package:fichas/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DatosLocalPage extends StatefulWidget {
  const DatosLocalPage({Key? key}) : super(key: key);

  @override
  _DatosLocalPageState createState() => _DatosLocalPageState();
}

class _DatosLocalPageState extends State<DatosLocalPage> {
  String dropdownValue = "";
  String? _character = "Renta";
  @override
  Widget build(BuildContext context) {
    final datosLocalProvider = Provider.of<DatosLocalProvider>(context);
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
              width: 35,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("DATOS GENERALES DEL LOCAL"),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: datosLocalProvider.formDatosLocalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          children: [
            _crearInputPropietario(datosLocalProvider),
            _contruirSeparador(),
            _crearInputTelefono(datosLocalProvider),
            _contruirSeparador(),
            _compraRenta(datosLocalProvider),
            _contruirSeparador(),
            _character == "Renta"
                ? _crearInputCosto(
                    datosLocalProvider, "Renta solicitada mensualmente")
                : _crearInputCosto(datosLocalProvider, "Precio de venta"),
            _contruirSeparador(),
            _inputTipoInmueble(datosLocalProvider),
            _contruirSeparador(),
            _crearInputFrente(datosLocalProvider),
            _contruirSeparador(),
            _crearInputFondo(datosLocalProvider),
            _contruirSeparador(),
            _boton(datosLocalProvider),
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

  Widget _crearInputPropietario(datosLocalProvider) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Propietario",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => datosLocalProvider.propietario = value,
      validator: (value) {
        return value!.isEmpty
            ? "Debes de ingresar el nombre del propietario"
            : null;
      },
    );
  }

  Widget _crearInputTelefono(datosLocalProvider) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Teléfono",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => datosLocalProvider.telefono = value,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debes de ingresar un número de teléfono";
        } else if (value.length != 10) {
          return "Debes de ingresar un número de teléfono correcto";
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearInputCosto(datosLocalProvider, String tipo) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: tipo,
        hintText: "\$",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => datosLocalProvider.costo = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar un valor" : null;
      },
    );
  }

  Widget _crearInputFrente(datosLocalProvider) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Frente (m)",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => datosLocalProvider.frente = value,
      validator: (value) {
        return value!.isEmpty
            ? "Debes de ingresar el número de metros del frente"
            : null;
      },
    );
  }

  Widget _crearInputFondo(datosLocalProvider) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Fondo (m)",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => datosLocalProvider.fondo = value,
      validator: (value) {
        return value!.isEmpty
            ? "Debes de ingresar el número de metros del fondo"
            : null;
      },
    );
  }

  Widget _compraRenta(datosLocalProvider) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text("Renta"),
            leading: Radio(
              value: "Renta",
              groupValue: _character,
              onChanged: (String? value) {
                datosLocalProvider.ventaRenta = value;
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text("Venta"),
            leading: Radio(
              value: "Venta",
              groupValue: _character,
              onChanged: (String? value) {
                datosLocalProvider.ventaRenta = value;
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputTipoInmueble(datosLocalProvider) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Tipo de inmueble ",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (String? newValue) {
        datosLocalProvider.tipoInmueble = newValue;
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>["Local", "Casa", "Terreno"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text(dropdownValue),
      validator: (value) {
        return value == null ? "Debes de ingresar un valor" : null;
      },
    );
  }

  Widget _boton(datosLocalProvider) {
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
          if (!datosLocalProvider.isValidForm()) return;

          double metrosCuadrados = double.parse(datosLocalProvider.fondo) *
              double.parse(datosLocalProvider.frente);

          if (metrosCuadrados < 300) return _displayDialogAndroid();

          Navigator.pushReplacementNamed(context, "generadores");
          _displayIntructions();
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }

  void _displayDialogAndroid() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Local pequeño')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'La superficie mínima para una tienda 3B es de 300 metros cuadrados',
                  style: TextStyle(fontSize: 17),
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
                  'Indica a que distancia se encuentran los generadores',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Mínimo 2 generadores',
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
}
