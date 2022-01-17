import 'package:fichas/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FortalezasDebilidaesPage extends StatelessWidget {
  const FortalezasDebilidaesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fortalezasDebilidadesProvider =
        Provider.of<FortalezasDebilidadesProvider>(context);
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
                child: Text("FORTALEZAS & DEBILIDADES"),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: fortalezasDebilidadesProvider.formFortalezasDebilidadesKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          children: [
            _contruirSeparador(),
            _inputFortalezas(fortalezasDebilidadesProvider),
            _contruirSeparador(),
            _inputDebilidades(fortalezasDebilidadesProvider),
            _contruirSeparador(),
            _boton(context, fortalezasDebilidadesProvider),
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

  Widget _inputFortalezas(
      FortalezasDebilidadesProvider fortalezasDebilidadesProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      minLines: 10,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Fortalezas",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => fortalezasDebilidadesProvider.fortalezas = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar las fortalezas" : null;
      },
    );
  }

  Widget _inputDebilidades(
      FortalezasDebilidadesProvider fortalezasDebilidadesProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      minLines: 10,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Debilidades",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => fortalezasDebilidadesProvider.debilidades = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar las debilidades" : null;
      },
    );
  }

  Widget _boton(BuildContext context,
      FortalezasDebilidadesProvider fortalezasDebilidadesProvider) {
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
          if (!fortalezasDebilidadesProvider.isValidForm()) return;
          Navigator.pushReplacementNamed(context, "finalizar");
        },
        child: const Text("SIGUIENTE"),
      ),
    );
  }
}
