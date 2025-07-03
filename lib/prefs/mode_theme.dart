import 'package:flutter/material.dart';

class ModeTheme {

  static final lightMode = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF508776),
      // ···
      brightness: Brightness.light,
      ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFE0E0E0), // لون الحقول في الوضع الفاتح
    ),
  );



  static final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF508776),
      // ···
      brightness: Brightness.dark,
      ),

  textTheme: const TextTheme(
  bodyLarge: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
  fillColor: Color(0xFF424242), // لون الحقول في الوضع الداكن
  ),
  );


}