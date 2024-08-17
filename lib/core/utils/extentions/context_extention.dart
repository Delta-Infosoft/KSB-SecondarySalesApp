import 'package:flutter/material.dart';

extension ContextExtention on BuildContext{

  /* Use this shortcuts in UI code like when we need screenHeight
   then don't do like this
    double size = MediaQuery.of(this).size.height;
   instead use context.screenHeight
   Example: Container(height:context.screenHeight,width:context.screenWidth) */
  
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get primaryColor => Theme.of(this).colorScheme.primary;
}