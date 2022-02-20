import 'package:fichas/providers/providers.dart';
import 'package:fichas/services/fichas_services.dart';
import 'package:fichas/services/services.dart';
import 'package:fichas/widgets/fichas_tarjetas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading_screen.dart';

class EstadoFichas extends StatelessWidget {
  const EstadoFichas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fichasService = Provider.of<FichasService>(context);
    final colaboradorProvider = Provider.of<ColaboradorProvider>(context);
    final empleadosService = Provider.of<EmpleadosServices>(context);

    if (fichasService.isLoading) return const LoadingScreen();

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
              width: 140,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("            FICHAS"),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            fichasService.fichas.clear();
            fichasService.loadFichasEmpleado(await empleadosService
                .obtenerFichasEmpleado(colaboradorProvider.numeroEmpleado));
          },
          child: fichasService.fichas.isNotEmpty
              ? ListView.builder(
                  itemCount: fichasService.fichas.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    child: FichasCard(
                      ficha: fichasService.fichas[index],
                    ),
                  ),
                )
              : const Center(
                  child: Text("Sin fichas"),
                )),
    );
  }
}
