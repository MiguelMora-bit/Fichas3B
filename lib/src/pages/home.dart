import 'package:fichas/src/theme/light_theme.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _logo(),
            _texto(),
            _imagenTienda(),
            _ButtonsHome(),
          ],
        ),
      ),
    );
  }
}

Widget _logo() {
  return Image.asset(
    "assets/Logo3B.png",
    height: 100.0,
    width: 100.0,
  );
}

Widget _texto() {
  return Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(children: [
        TextSpan(
            text: "“Una tienda nueva\nnuevas familas ahorrando”\n",
            style: AppTheme.textH1),
        TextSpan(text: "y tu ganando ", style: AppTheme.textEnfasis)
      ]),
    ),
  );
}

Widget _imagenTienda() {
  return Container(
    child: Lottie.asset('assets/tienda.json', width: 250, height: 250),
  );
}

class _CustomElevatedButton extends StatelessWidget {
  final String text;
  final String routeName;

  const _CustomElevatedButton({required this.text, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: FittedBox(child: Text(text)),
    );
  }
}

class _ButtonsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _CustomElevatedButton(
              text: "REGISTRA UNA FICHA", routeName: "introduction"),
          _CustomElevatedButton(
              text: "ESTADO DE TUS FICHAS", routeName: "estadoFichas"),
          _CustomElevatedButton(text: "MISIONES", routeName: "lista_misiones"),
        ],
      ),
    );
  }
}
