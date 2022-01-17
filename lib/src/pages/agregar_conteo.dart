import 'package:fichas/providers/conteos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class AgregarConteo extends StatefulWidget {
  const AgregarConteo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AgregarConteoState();
  }
}

class AgregarConteoState extends State<AgregarConteo> {
  late DateTime alert;
  int contador = 0;

  void agregar() {
    contador++;
    setState(() {});
  }

  void quitar() {
    if (contador > 0) contador--;
    setState(() {});
  }

  void guardar(ConteosProvider conteosProvider) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy h:mm').format(now);
    conteosProvider.conteos.add({
      "id": conteosProvider.conteos.length,
      "personas": contador,
      "fecha": formattedDate
    });
    Navigator.pushReplacementNamed(context, "conteos");
  }

  @override
  void initState() {
    super.initState();
    alert = DateTime.now().add(const Duration(minutes: 1));
  }

  @override
  Widget build(BuildContext context) {
    final conteosProvider = Provider.of<ConteosProvider>(context);
    return MaterialApp(
      home: Scaffold(
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
                width: 120,
              ),
              const Expanded(
                child: FittedBox(
                  child: Text("              CONTEO"),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _contador(alert, conteosProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget personas() {
    return Column(
      children: [
        const Text(
          'Contador de personas',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          '$contador',
          style: const TextStyle(fontSize: 30),
        )
      ],
    );
  }

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    // We want to round up the remaining time to the nearest second
    d += const Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }

  Widget _contador(alert, conteosProvider) {
    return TimerBuilder.scheduled([alert], builder: (context) {
      // This function will be called once the alert time is reached
      DateTime now = DateTime.now();
      bool reached = now.compareTo(alert) >= 0;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              reached ? Icons.alarm_on : Icons.alarm,
              color: reached ? Colors.red : Colors.green,
              size: 80,
            ),
            !reached
                ? TimerBuilder.periodic(const Duration(seconds: 1),
                    alignment: Duration.zero, builder: (context) {
                    // This function will be called every second until the alert time
                    DateTime now = DateTime.now();
                    var remaining = alert.difference(now);
                    return _vista(remaining, agregar, quitar);
                  })
                : _final(guardar, conteosProvider),
          ],
        ),
      );
    });
  }

  Widget _contruirSeparador() {
    return Container(
      height: 100,
    );
  }

  Widget _final(guardar, conteosProvider) {
    return Column(
      children: [
        const Text(
          "Termino el conteo",
          style: TextStyle(fontSize: 30),
        ),
        _contruirSeparador(),
        personas(),
        _contruirSeparador(),
        BotonGuardar(
          funcionGuardar: guardar,
          conteosProvider: conteosProvider,
        )
      ],
    );
  }

  Widget _vista(remaining, agregar, quitar) {
    return Column(
      children: [
        Text(
          formatDuration(remaining),
          style: const TextStyle(fontSize: 30),
        ),
        _contruirSeparador(),
        personas(),
        _contruirSeparador(),
        Botones(funcionAgregar: agregar, funcionQuitar: quitar)
      ],
    );
  }
}

class BotonGuardar extends StatelessWidget {
  final Function funcionGuardar;
  final ConteosProvider conteosProvider;

  const BotonGuardar(
      {Key? key, required this.funcionGuardar, required this.conteosProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn3",
      elevation: 0,
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.save,
      ),
      onPressed: () => funcionGuardar(conteosProvider),
    );
  }
}

class Botones extends StatelessWidget {
  final Function funcionAgregar;
  final Function funcionQuitar;

  const Botones({
    Key? key,
    required this.funcionAgregar,
    required this.funcionQuitar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: "btn1",
          elevation: 0,
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.add,
          ),
          onPressed: () => funcionAgregar(),
        ),
        FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: Colors.red,
          elevation: 0,
          child: const Icon(Icons.remove),
          onPressed: () => funcionQuitar(),
        )
      ],
    );
  }
}
