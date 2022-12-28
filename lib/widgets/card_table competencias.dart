import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/competencias_provider.dart';

class CardTableCompetencias extends StatelessWidget {
  const CardTableCompetencias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final competenciasProvider = Provider.of<CompetenciasProvider>(context);

    return Table(
      children: [
        TableRow(children: [
          _SigleCard(
            propiedades: competenciasProvider.competencias[0],
          ),
          _SigleCard(propiedades: competenciasProvider.competencias[1]),
        ]),
        TableRow(children: [
          _SigleCard(propiedades: competenciasProvider.competencias[2]),
          _SigleCard(propiedades: competenciasProvider.competencias[3]),
        ])
      ],
    );
  }
}

class _SigleCard extends StatelessWidget {
  final Map propiedades;

  const _SigleCard({Key? key, required this.propiedades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        identificador: propiedades["identificador"],
        activo: propiedades['activo'],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              propiedades['imagePath'],
              height: 100.0,
              width: 100.0,
            ),
            const SizedBox(height: 10),
            Text(
              propiedades['competidor'],
              style: TextStyle(color: propiedades['color'], fontSize: 15),
            ),
            const SizedBox(height: 10),
            propiedades['distancia'] != "0"
                ? Text(
                    "A " + propiedades['distancia'] + " metros",
                    style: TextStyle(color: propiedades['color'], fontSize: 15),
                  )
                : const SizedBox(height: 10),
          ],
        ));
  }
}

class _CardBackground extends StatefulWidget {
  final Widget child;
  final bool activo;
  final int identificador;

  const _CardBackground(
      {Key? key,
      required this.child,
      required this.activo,
      required this.identificador})
      : super(key: key);

  @override
  State<_CardBackground> createState() => _CardBackgroundState();
}

class _CardBackgroundState extends State<_CardBackground> {
  @override
  Widget build(BuildContext context) {
    final competenciasProvider = Provider.of<CompetenciasProvider>(context);

    return GestureDetector(
      onTap: widget.activo
          ? () {
              _openDialogQuitar(
                  context, competenciasProvider, widget.identificador);
            }
          : () {
              _openDialog(context, competenciasProvider, widget.identificador);
            },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              foregroundDecoration: widget.activo
                  ? const BoxDecoration()
                  : const BoxDecoration(
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.saturation),
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 5.0),
                  borderRadius: BorderRadius.circular(20)),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  void _openDialog(
      context, CompetenciasProvider competenciasProvider, int identificador) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Agregar competidor')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Form(
              key: competenciasProvider.formCompetenciasKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: MediaQuery.of(context).size.width - 2),
                  const Text(
                    "Ingresa la distancia a la que se encuentra el competidor en metros",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _crearInputDistancia(competenciasProvider),
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
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (!competenciasProvider.isValidForm()) return;

                    competenciasProvider.cambiarElemento(
                        identificador, competenciasProvider.distancia, true);
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  void _openDialogQuitar(
      context, CompetenciasProvider competenciasProvider, int identificador) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Quitar competidor')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: MediaQuery.of(context).size.width - 2),
                const Text(
                  "¿Estas seguro de quitar el competidor?",
                  textAlign: TextAlign.center,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.black))),
              TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    competenciasProvider.cambiarElemento(
                        identificador, "0", false);
                    Navigator.pop(context);
                  },
                  child: const Text('Quitar',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  Widget _crearInputDistancia(CompetenciasProvider competenciasProvider) {
    return TextFormField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Distancia",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) => competenciasProvider.distancia = value,
      validator: (value) {
        return value!.isEmpty ? "Debes de ingresar la distancia" : null;
      },
    );
  }
}
