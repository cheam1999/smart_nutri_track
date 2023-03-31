import 'package:flutter/widgets.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';
import 'package:smart_nutri_track/screen/auth/sign_up.dart';
import 'package:smart_nutri_track/screen/barcode_details.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/screen/diary.dart';
import 'package:smart_nutri_track/screen/home.dart';
import 'package:smart_nutri_track/screen/recipe.dart';
import 'screen/init.dart';

final Map<String, WidgetBuilder> routes = {
  //StartScreen.routeName: (context) => StartScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  InitScreen.routeName: (context) => InitScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DiaryScreen.routeName: (context) => DiaryScreen(),
  RecipeScreen.routeName: (context) => RecipeScreen(),
  BarcodeScanningScreen.routeName: (context) => BarcodeScanningScreen(),
  BarcodeDetailScreen.routeName: (context) => BarcodeDetailScreen(),
};
