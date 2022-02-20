import 'package:fichas/providers/providers.dart';
import 'package:fichas/services/fichas_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/empleados_services.dart';
import 'package:fichas/src/router/app_routes.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmpleadosServices(),
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
        ChangeNotifierProvider(
          create: (_) => ConteosProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CroquisProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => FortalezasDebilidadesProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => FichasService(),
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
      color: Colors.red,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
