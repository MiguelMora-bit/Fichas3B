import 'package:fichas/models/ficha_model.dart';
import 'package:fichas/providers/providers.dart';
import 'package:fichas/services/empleados_services.dart';
import 'package:fichas/services/fichas_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FinalizarPage extends StatefulWidget {
  const FinalizarPage({Key? key}) : super(key: key);

  @override
  State<FinalizarPage> createState() => _FinalizarPageState();
}

class _FinalizarPageState extends State<FinalizarPage> {
  bool disponible = true;
  @override
  Widget build(BuildContext context) {
    final colaboradorProvider = Provider.of<ColaboradorProvider>(context);
    final ubicacionProvider = Provider.of<UbicacionSitioProvider>(context);
    final datosLocalesProvider = Provider.of<DatosLocalProvider>(context);
    final competenciasProvider = Provider.of<CompetenciasProvider>(context);
    final conteosProvider = Provider.of<ConteosProvider>(context);
    final fortalezasDebilidadesProvider =
        Provider.of<FortalezasDebilidadesProvider>(context);
    final generadoresProvider = Provider.of<GeneradoresProvider>(context);
    final croquisProvider = Provider.of<CroquisProvider>(context);

    final fichasService = Provider.of<FichasService>(context);
    final empleadoService = Provider.of<EmpleadosServices>(context);

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
                child: Text("          FINALIZAR"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _felicidades(),
          _boton(
              context,
              colaboradorProvider,
              ubicacionProvider,
              datosLocalesProvider,
              competenciasProvider,
              conteosProvider,
              fortalezasDebilidadesProvider,
              generadoresProvider,
              croquisProvider,
              fichasService,
              empleadoService)
        ],
      ),
    );
  }

  Widget _felicidades() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
      child: Column(children: const [
        Text("¡FELICIDADES!"),
        Text("HAS LLENADO CORRECTAMENTE TU FICHA")
      ]),
    );
  }

  Widget _boton(
    BuildContext context,
    ColaboradorProvider colaboradorProvider,
    UbicacionSitioProvider ubicacionProvider,
    DatosLocalProvider datosLocalesProvider,
    CompetenciasProvider competenciasProvider,
    ConteosProvider conteosProvider,
    FortalezasDebilidadesProvider fortalezasDebilidadesProvider,
    GeneradoresProvider generadoresProvider,
    CroquisProvider croquisProvider,
    FichasService fichasService,
    EmpleadosServices empleadoService,
  ) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: disponible
            ? () async {
                setState(() {
                  disponible = false;
                });
                final String? urlPicture =
                    await fichasService.uploadImage(croquisProvider.foto);

                Ficha nuevaFicha = Ficha(
                  calle1: ubicacionProvider.calle1,
                  calle2: ubicacionProvider.calle2,
                  colonia: ubicacionProvider.colonia,
                  estado: ubicacionProvider.estado,
                  competencias: competenciasProvider.competencias,
                  conteos: conteosProvider.conteos,
                  debilidades: fortalezasDebilidadesProvider.debilidades,
                  delegacion: ubicacionProvider.delegacion,
                  direccion: ubicacionProvider.direccion,
                  fondo: datosLocalesProvider.fondo,
                  fortalezas: fortalezasDebilidadesProvider.fortalezas,
                  fotoUrl: urlPicture!,
                  frente: datosLocalesProvider.frente,
                  generadores: generadoresProvider.generadores,
                  latLong: croquisProvider.coordenadas.toString(),
                  nombreSitio: ubicacionProvider.nombreSitio,
                  numEmpleado: colaboradorProvider.numeroEmpleado,
                  propietario: datosLocalesProvider.propietario,
                  telefono: datosLocalesProvider.telefono,
                  ventaRenta: datosLocalesProvider.ventaRenta,
                  costo: datosLocalesProvider.costo,
                  tipoInmueble: datosLocalesProvider.tipoInmueble,
                  nombreEmpleado: colaboradorProvider.nombreEmpleado,
                  puesto: colaboradorProvider.puesto,
                  tienda: colaboradorProvider.tienda,
                );

                final String folio =
                    await fichasService.createFicha(nuevaFicha);

                final List<dynamic> fichas = await empleadoService
                    .obtenerFichasEmpleado(colaboradorProvider.numeroEmpleado);
                fichas.add(folio);

                await empleadoService.updateFichasEmpleado(
                    colaboradorProvider.numeroEmpleado, fichas);

                displayDialogAndroid(context, folio);
              }
            : null,
        child: const Text("ENVIAR"),
      ),
    );
  }

  void displayDialogAndroid(context, String folio) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(
                child: Text(
              'Ficha guardada correctamente',
              textAlign: TextAlign.center,
            )),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Folio: $folio',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Aceptar'))
            ],
          );
        });
  }
}
