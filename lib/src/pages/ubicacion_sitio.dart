import 'package:fichas/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          children: [
            _crearInputDireccion(ubicacionProvider),
            _contruirSeparador(),
            _inputEstados(ubicacionProvider),
            _contruirSeparador(),
            _crearInputDelegacion(ubicacionProvider),
            _contruirSeparador(),
            _crearInputColonia(ubicacionProvider),
            _contruirSeparador(),
            _crearInputEntreCalles(ubicacionProvider),
            _contruirSeparador(),
            _crearInputNombreSItio(ubicacionProvider),
            _contruirSeparador(),
            _boton(ubicacionProvider, context),
          ],
        ),
      ),
    );
  }

  Widget _inputEstados(ubicacionProvider) {
    dropdownValueGeneradores = "";
    return DropdownButtonFormField<String>(
      menuMaxHeight: 500,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Estado",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (String? newValue) {
        ubicacionProvider.estado = newValue;
        setState(() {
          dropdownValueGeneradores = newValue!;
        });
      },
      items: <String>[
        "Aguascalientes",
        "Baja California",
        "Baja California Sur",
        "Campeche",
        "Chiapas",
        "Chihuahua",
        "Ciudad de México",
        "Coahuila",
        "Colima",
        "Durango",
        "Estado de México",
        "Guanajuato",
        "Guerrero",
        "Hidalgo",
        "Jalisco",
        "Michoacán",
        "Morelos",
        "Nayarit",
        "Nuevo León",
        "Oaxaca",
        "Puebla",
        "Querétaro",
        "Quintana Roo",
        "San Luis Potosí",
        "Sinaloa",
        "Sonora",
        "Tabasco",
        "Tamaulipas",
        "Tlaxcala",
        "Veracruz",
        "Yucatán",
        "Zacatecas"
      ].map<DropdownMenuItem<String>>((String value) {
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

Widget _contruirSeparador() {
  return Container(
    height: 20,
  );
}

Widget _crearInputDireccion(ubicacionProvider) {
  return TextFormField(
    decoration: InputDecoration(
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

Widget _crearInputColonia(ubicacionProvider) {
  return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Colonia",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => ubicacionProvider.colonia = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar la colonia" : null;
      });
}

Widget _crearInputNombreSItio(ubicacionProvider) {
  return TextFormField(
      decoration: InputDecoration(
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

Widget _crearInputDelegacion(ubicacionProvider) {
  return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Delegación o municipio",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => ubicacionProvider.delegacion = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar la delegación" : null;
      });
}

Widget _boton(ubicacionProvider, context) {
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
        if (!ubicacionProvider.isValidForm()) return;
        Navigator.pushReplacementNamed(context, "datosLocal");
      },
      child: const Text("SIGUIENTE"),
    ),
  );
}
