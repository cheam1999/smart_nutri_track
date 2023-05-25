import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/custom_exception.dart';

import '../../models/recipe_model.dart';
import '../../repositories/recipe_repository.dart';

final breakfastRecipeControllerProvider =
    ChangeNotifierProvider.autoDispose<BreakfastRecipeController>((ref) {
  return BreakfastRecipeController(ref.read);
});

class BreakfastRecipeController extends ChangeNotifier {
  final Reader _read;
  List<Recipe> breakfast_list = [];

  Recipe _currentBreakfast = Recipe();
  set currentBreakfastSet(value) => {_currentBreakfast = value};

  BreakfastRecipeController(this._read);

  // Future<Recipe> currentBreakfast() async {
  //   await randomBreakfastRecipe();

  //   return _currentBreakfast;
  // }

  Future<Recipe> randomBreakfastRecipe() async {
    if (breakfast_list.isEmpty) {
      await retrieveBreakfastRecipe();
    }

    var intValue = Random().nextInt(breakfast_list.length);

    print(intValue);

    _currentBreakfast = breakfast_list[intValue];
    
    notifyListeners();

    return _currentBreakfast;
  }

  Future<void> retrieveBreakfastRecipe() async {
    try {
      var breakfast_list_temp =
          await _read(recipeRepositoryProvider).retrieveBreakfastRecipe();
      print('result ${breakfast_list_temp.length}');

      breakfast_list = breakfast_list_temp
          .map((item) => Recipe.fromMap(item))
          .toList(growable: false);

      print("item ${breakfast_list[0].recipe_name}");
    } on CustomException catch (e, st) {
      print(e);
    } catch (e) {
      CustomException(message: "Retrieve Recipe Error!");
    }
  }
}
