import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.red;

  static const TextStyle textH1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: Colors.black,
  );

  static const TextStyle textEnfasis = TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: 25,
      color: Colors.red);

  static InputDecoration customImputDecoration(
      {required IconData icono, required String label}) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(0.2),
        child: Icon(
          icono,
          color: Colors.black,
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primary,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primary,
              elevation: 0,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3))))),
      appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 0));

  static final ThemeData darkTheme = ThemeData.dark().copyWith();
}
