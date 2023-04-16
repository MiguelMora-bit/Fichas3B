import 'package:confetti/confetti.dart';
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
  final controllerConfeti = ConfettiController();
  bool disponible = true;

  @override
  void initState() {
    super.initState();
    controllerConfeti.play();
  }

  @override
  Widget build(BuildContext context) {
    final colaboradorProvider = Provider.of<ColaboradorProvider>(context);
    final ubicacionProvider = Provider.of<UbicacionSitioProvider>(context);
    final datosLocalesProvider = Provider.of<DatosLocalProvider>(context);
    final competenciasProvider = Provider.of<CompetenciasProvider>(context);
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
                child: Text("  FINALIZAR  "),
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
      child: Column(
        children: [
          Stack(children: [
            ConfettiWidget(
              confettiController: controllerConfeti,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ]),
          const Text("¡FELICIDADES!"),
          const Text("HAS LLENADO CORRECTAMENTE TU FICHA")
        ],
      ),
    );
  }

  Widget _boton(
    BuildContext context,
    ColaboradorProvider colaboradorProvider,
    UbicacionSitioProvider ubicacionProvider,
    DatosLocalProvider datosLocalesProvider,
    CompetenciasProvider competenciasProvider,
    GeneradoresProvider generadoresProvider,
    CroquisProvider croquisProvider,
    FichasService fichasService,
    EmpleadosServices empleadoService,
  ) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.red,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: disponible
            ? () async {
                setState(() {
                  disponible = false;
                });

                try {
                  cargando(context, "subiendo tu informacion");

                  final String? urlPicture =
                      await fichasService.uploadImage(croquisProvider.foto);

                  Ficha nuevaFicha = Ficha(
                      folio: await empleadoService.generarFolio(
                              colaboradorProvider.numeroEmpleado) +
                          "",
                      calle1: ubicacionProvider.calle1,
                      calle2: ubicacionProvider.calle2,
                      colonia: ubicacionProvider.colonia,
                      estado: ubicacionProvider.estado,
                      competencias: competenciasProvider.devolverCompetencias(),
                      delegacion: ubicacionProvider.delegacion,
                      direccion: ubicacionProvider.direccion,
                      fondo: datosLocalesProvider.fondo,
                      fotoUrl: urlPicture!,
                      frente: datosLocalesProvider.frente,
                      generadores: generadoresProvider.devolverGeneradores(),
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
                      fecha: DateTime.now().toString(),
                      codigoPostal: ubicacionProvider.codigoPostal,
                      correo: colaboradorProvider.correoElectronico,
                      celular: colaboradorProvider.celular);

                  final String folioFirebase =
                      await fichasService.createFicha(nuevaFicha);

                  final List<dynamic> fichas =
                      await empleadoService.obtenerFichasEmpleado(
                          colaboradorProvider.numeroEmpleado);
                  fichas.add(folioFirebase);

                  await empleadoService.updateFichasEmpleado(
                      colaboradorProvider.numeroEmpleado, fichas);

                  Navigator.of(context).pop();
                  displayDialogAndroid(context, "Folio_123");

                  displayDialogAndroid(context, nuevaFicha.folio);
                } catch (e) {
                  Navigator.of(context).pop();
                  displayDialogInternet(context);
                }
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
        builder: (folioContext) {
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

  void cargando(BuildContext context, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Cargando...')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/loading.gif",
                  height: 50.0,
                  width: 50.0,
                ),
                const SizedBox(height: 40),
                Center(child: Text(mensaje))
              ],
            ),
          );
        });
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
                  child: const Text('Aceptar'))
            ],
          );
        });
  }
}
