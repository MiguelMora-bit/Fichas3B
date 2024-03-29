import 'package:fichas/providers/maps_provder.dart';
import 'package:fichas/providers/providers.dart';
import 'package:fichas/services/codigo_postal.services.dart';
import 'package:fichas/services/fichas_services.dart';
import 'package:fichas/services/misiones_services.dart';
import 'package:fichas/src/Theme/light_theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/empleados_services.dart';
import 'package:fichas/src/router/app_routes.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppStateWidget();
  }
}

class AppStateWidget extends StatelessWidget {
  const AppStateWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmpleadosServices(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CodigoPostalServices(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ColaboradorProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UbicacionSitioProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DatosLocalProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => GeneradoresProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CompetenciasProvider(),
          // lazy: false,
        ),
        // lazy: false,
        ChangeNotifierProvider(
          create: (_) => CroquisProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => FichasService(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MisionesServices(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MapsProvider(),
          // lazy: false,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fichas 3B',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
