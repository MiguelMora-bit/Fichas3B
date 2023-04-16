import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamed(context, "datosGenerales");
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 70),
          child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            child: const Text(
              'Registremos una ficha ahora!!!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "",
          body:
              "1.- Debe contar con una dimensión mínima de 350 metros cuadrados siendo el ideal 500 metros \n \n 2.- Debe de tener un frente de fachada de mínimo 10 metros. \n \n3.- Estar a pie de calle y amplitud para estacionar el camión de CEDIS \n \n",
          image: _buildImage('ubicacion.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Los sitios sugeridos deben estar cerca de una zona de abasto",
          body:
              "¿Qué es una zona de abasto? \n \n Una zona de abasto es donde las amas de casa realizan cotidianamente sus compras de verdura, fruta, carne, pollo, tortillas, etc...",
          image: _buildImage('sugeridos.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Competencias",
          body:
              "Todo aquel comercio con un giro similar que puede: \n -Robar nuestros clientes potenciales. \n -Ser un generador para ganar clientes que actualmente asisten a ese comercio \n \n IMPORTANTE: \n Si hay competencia cercana esto no impide que se pueda abrir una Tienda 3B",
          image: _buildImage('competencias.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Generadores",
          body:
              "Son comercios o lugares que generan flujo de posibles clientes \n \n Ejemplos: \n \n -Mercados  -Igleasias \n \n -Escuelas -Etc.",
          image: _buildImage('generadores.jpg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Colors.red,
      ),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.red,
      ),
      done: const Text('Finalizar',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.red,
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
