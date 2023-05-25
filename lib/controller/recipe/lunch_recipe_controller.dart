import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/custom_exception.dart';

import '../../models/recipe_model.dart';
import '../../repositories/recipe_repository.dart';

final lunchRecipeControllerProvider =
    ChangeNotifierProvider.autoDispose<LunchRecipeController>((ref) {
  return LunchRecipeController(ref.read);
});

class LunchRecipeController extends ChangeNotifier {
  final Reader _read;
  List<Recipe> lunch_list = [];

  Recipe _currentLunch = Recipe();
  set currentLunchSet(value) => {_currentLunch = value};

  LunchRecipeController(this._read);

  // Future<Recipe> currentLunch() async {
  //   await randomLunchRecipe();

  //   return _currentLunch;
  // }

  Future<Recipe> randomLunchRecipe() async {
    if (lunch_list.isEmpty) {
      await retrieveLunchRecipe();
    }

    var intValue = Random().nextInt(lunch_list.length);

    print(intValue);

    _currentLunch = lunch_list[intValue];
    
    notifyListeners();

    return _currentLunch;
  }

  Future<void> retrieveLunchRecipe() async {
    try {
      var lunch_list_temp =
          await _read(recipeRepositoryProvider).retrieveLunchRecipe();
      print('result ${lunch_list_temp.length}');

      lunch_list = lunch_list_temp
          .map((item) => Recipe.fromMap(item))
          .toList(growable: false);

      print("item ${lunch_list[0].recipe_name}");
    } on CustomException catch (e, st) {
      print(e);
    } catch (e) {
      CustomException(message: "Retrieve Recipe Error!");
    }
  }
}
