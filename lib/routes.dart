import 'package:flutter/widgets.dart';
import 'package:smart_nutri_track/controller/update_profile_controller.dart';
import 'package:smart_nutri_track/screen/add_food.dart';
import 'package:smart_nutri_track/screen/add_meal.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';
import 'package:smart_nutri_track/screen/auth/sign_up.dart';
import 'package:smart_nutri_track/screen/barcode_details.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/screen/diary.dart';
import 'package:smart_nutri_track/screen/diary_diabetes.dart';
import 'package:smart_nutri_track/screen/edit_profile.dart';
import 'package:smart_nutri_track/screen/food%20details.dart';
import 'package:smart_nutri_track/screen/grocery_list.dart';
import 'package:smart_nutri_track/screen/home.dart';
import 'package:smart_nutri_track/screen/photo_scanning.dart';
import 'package:smart_nutri_track/screen/profile.dart';
import 'package:smart_nutri_track/screen/recipe.dart';
import 'package:smart_nutri_track/screen/start.dart';
import 'screen/init.dart';

final Map<String, WidgetBuilder> routes = {
  StartScreen.routeName: (context) => StartScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  InitScreen.routeName: (context) => InitScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DiaryScreen.routeName: (context) => DiaryScreen(),
  RecipeScreen.routeName: (context) => RecipeScreen(),
  BarcodeScanningScreen.routeName: (context) => BarcodeScanningScreen(),
  BarcodeDetailScreen.routeName: (context) => BarcodeDetailScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
  AddMealScreen.routeName: (context) => AddMealScreen(),
  FoodDetailScreen.routeName: (context) => FoodDetailScreen(),
  AddFoodScreen.routeName: (context) => AddFoodScreen(),
  GroceryListScreen.routeName: (context) => GroceryListScreen(),
  // PhotoScanning.routeName: (context) => PhotoScanning()
  PlantRecogniser.routeName:(context) => PlantRecogniser(),
  DiabetesScreen.routeName: (context) => DiabetesScreen(),
};
