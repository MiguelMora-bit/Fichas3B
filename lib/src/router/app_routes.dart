import 'package:flutter/material.dart';

import 'package:fichas/src/pages/pages.dart';

class AppRoutes {
  static const initialRoute = "home";

  static Map<String, Widget Function(BuildContext)> routes = {
    "home": (BuildContext context) => const HomePage(),
    "croquis": (BuildContext context) => const CroquisPage(),
    "datosGenerales": (BuildContext context) => const GeneralPage(),
    "datosLocal": (BuildContext context) => const DatosLocalPage(),
    "ubicacionSitio": (BuildContext context) => const UbicacionSitioPage(),
    "generadores": (BuildContext context) => const GeneradoresPage(),
    "competencias": (BuildContext context) => const CompetenciasPage(),
    "conteos": (BuildContext context) => const ConteoPage(),
    "agregarConteo": (BuildContext context) => const AgregarConteo(),
    "fortalezasDebilidades": (BuildContext context) =>
        const FortalezasDebilidaesPage(),
    "finalizar": (BuildContext context) => const FinalizarPage(),
    "estadoFichas": (BuildContext context) => const ColaboradorStadoPage(),
    "listadoFichas": (BuildContext context) => const EstadoFichas(),
  };
}
