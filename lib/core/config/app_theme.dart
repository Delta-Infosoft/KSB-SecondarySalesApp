
import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      foregroundColor: ColorScheme.fromSeed(seedColor : const Color(0xFF336699)).onPrimary,
      backgroundColor: ColorScheme.fromSeed(seedColor: const Color(0xFF336699)).primary
    ),
    brightness: Brightness.light,colorSchemeSeed: const Color(0xFF336699));
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,colorSchemeSeed: Colors.red);
}