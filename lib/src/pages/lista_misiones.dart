import 'package:fichas/services/misiones_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/tarjeta_misiones.dart';
import 'loading_screen.dart';

class ListaMisiones extends StatelessWidget {
  const ListaMisiones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final misionesService = Provider.of<MisionesServices>(context);

    if (misionesService.isLoading) return const LoadingScreen();

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
                child: Text("           MISIONES"),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            misionesService.misiones.clear();
            misionesService.loadMisiones();
          },
          child: misionesService.misiones.isNotEmpty
              ? ListView.builder(
                  itemCount: misionesService.misiones.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    child: MisionesCard(
                      mision: misionesService.misiones[index],
                    ),
                  ),
                )
              : const Center(
                  child: Text("Sin misiones"),
                )),
    );
  }
}
