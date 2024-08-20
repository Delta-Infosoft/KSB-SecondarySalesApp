
import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      foregroundColor: ColorScheme.fromSeed(seedColor : Colors.blueAccent).onPrimary,
      backgroundColor: ColorScheme.fromSeed(seedColor: Colors.blueAccent).primary
    ),
    brightness: Brightness.light,colorSchemeSeed: Colors.blueAccent);
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,colorSchemeSeed: Colors.red);
}