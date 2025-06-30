import 'package:flutter/material.dart';

class ModeTheme {

  static final lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
  seedColor: Color(0xFF508776),
  // ···
  brightness: Brightness.light,
  ),
  );
  static final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
  seedColor: Color(0xFF508776),
  // ···
  brightness: Brightness.dark,
  ),
  );


}