import 'package:flutter/material.dart';

class InnsiktTheme {
  // static final Color primaryColor = Colors.amber;
  // static final Color secondaryColor = Colors.amberAccent;
  // static final Color backgroundColor = Colors.white;
  // static final Color textColor = Colors.black;
  // static final Color errorColor = Colors.red;
  // static final Color successColor = Colors.green;
  // static final Color warningColor = Colors.yellow;
  // static final Color infoColor = Colors.blue;
  // static final Color disabledColor = Colors.grey;

  static ThemeData createTheme() {
    return ThemeData(
      colorSchemeSeed: Colors.amber,
      useMaterial3: true,
    );
  }
}