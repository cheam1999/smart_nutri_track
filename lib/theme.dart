import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'constant/colour_constant.dart';

MaterialColor swatchify(MaterialColor color, int value) {
  return MaterialColor(color[value].hashCode, <int, Color>{
    50: color[value]!,
    100: color[value]!,
    200: color[value]!,
    300: color[value]!,
    400: color[value]!,
    500: color[value]!,
    600: color[value]!,
    700: color[value]!,
    800: color[value]!,
    900: color[value]!,
  });
}

ThemeData theme() {
  return ThemeData(
    primaryColor: ColourConstant.kDarkColor,
    primarySwatch: swatchify(Colors.brown, 600),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    fontFamily: 'Montserrat',
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: ColourConstant.kDarkColor),
    gapPadding: 1,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
    errorStyle: TextStyle(color: Colors.red),
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodySmall: TextStyle(
      color: ColourConstant.kDarkColor,
      fontSize: ColourConstant.h5,
    ),
    bodyMedium: TextStyle(
        fontSize: ColourConstant.h4,
        color: ColourConstant.kDarkColor,
        fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(
      color: ColourConstant.kBlueColor,
      fontSize: ColourConstant.h1,
      fontWeight: FontWeight.bold,
    ),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: ColourConstant.kWhiteColor),
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      color: ColourConstant.kWhiteColor,
      fontSize: 20,
      // fontWeight: FontWeight.bold,
    ),
    // centerTitle: true,
  );
}
