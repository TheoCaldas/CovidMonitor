import 'package:flutter/material.dart';

class Constants {
  static final Color backgroundColor = Color.fromARGB(255, 124, 209, 176);
  static final Color primaryColor = Color.fromARGB(255, 255, 255, 255);

  static final TextTheme theme = TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      color: Constants.backgroundColor,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.bold,
      color: Constants.backgroundColor,
      fontSize: 28,
    ),
    bodyText1: TextStyle(
      fontWeight: FontWeight.normal,
      color: Constants.backgroundColor,
    ),
  );
}
