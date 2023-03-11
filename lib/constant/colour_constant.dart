import 'package:flutter/material.dart';

class ColourConstant {
  ColourConstant._(); // This is to prevent anyone from instantiating this object

  static const LinearGradient kBackgroundColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0.8, 1),
    colors: <Color>[
      Color(0xFF58BFF2),
      Color(0xFF033F6D),
    ],
  );
  static const Color kButtonColor = Color(0xFF52ABE1);
  //static const Color kBackgroundColor = Color(0xFFFBF2EC);
  static const Color kBlueColor = Color(0xFF52ABE1);
  static const Color kDarkColor = Color(0xFF272443);
  static const Color kWhiteColor = Color(0xFFFFFFFF);
  static const Color kGreyColor = Color(0xFF979797);
}
