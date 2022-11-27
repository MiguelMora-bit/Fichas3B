import 'package:flutter/material.dart';

import 'package:fichas/src/pages/pages.dart';

class AppRoutes {
  static const initialRoute = "datosLocal";

  static Map<String, Widget Function(BuildContext)> routes = {
    "home": (BuildContext context) => const HomePage(),
    "croquis": (BuildContext context) => const CroquisPage(),
    "datosGenerales": (BuildContext context) => const GeneralPage(),
    "datosLocal": (BuildContext context) => const DatosLocalPage(),
    "ubicacionSitio": (BuildContext context) => const UbicacionSitioPage(),
    "generadores": (BuildContext context) => const GeneradoresPage(),
    "competencias": (BuildContext context) => const CompetenciasPage(),
    "finalizar": (BuildContext context) => const FinalizarPage(),
    "estadoFichas": (BuildContext context) => const ColaboradorStadoPage(),
    "listadoFichas": (BuildContext context) => const EstadoFichas(),
    "introduction": (BuildContext context) => const OnBoardingPage(),
    "detalles": (BuildContext context) => const Detalles(),
    "lista_misiones": (BuildContext context) => const ListaMisiones(),
  };
}
