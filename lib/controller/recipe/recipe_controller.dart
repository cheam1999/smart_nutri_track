import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/repositories/ur_repository.dart';

import '../../models/custom_exception.dart';

import '../../models/recipe_model.dart';
import '../../models/ur_model.dart';
import '../../repositories/recipe_repository.dart';

final recipeControllerProvider =
    ChangeNotifierProvider.autoDispose<RecipeController>((ref) {
  return RecipeController(ref.read);
});

class RecipeController extends ChangeNotifier {
  final Reader _read;
  final _list = List.filled(4, new Recipe());

  // Recipe _current = Recipe();
  // set currentSet(value) => {_current = value};

  RecipeController(this._read);

  // Future<Recipe> current() async {
  //   await randomRecipe();

  //   return _current;
  // }

  Future<List<Recipe>> retrieveRecipe() async {
    try {
      Ur results = await _read(UrRepositoryProvider).retrieveUrByUserID();

      Recipe breakfast = await retrieveRecipebyID(results.ur_breakfast!);
      Recipe lunch = await retrieveRecipebyID(results.ur_lunch!);
      Recipe snacks = await retrieveRecipebyID(results.ur_snacks!);
      Recipe dinner = await retrieveRecipebyID(results.ur_dinner!);

      _list[0] = breakfast;
      _list[1] = lunch;
      _list[2] = snacks;
      _list[3] = dinner;

      return _list;

      // create a list
    } on CustomException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<Recipe> retrieveRecipebyID(int id) async {
    try {
      Recipe recipe =
          await _read(recipeRepositoryProvider).retrieveRecipebyID(id);
      // print('result ${breakfast_list_temp.length}');

      // breakfast_list = breakfast_list_temp
      //     .map((item) => Recipe.fromMap(item))
      //     .toList(growable: false);

      // print("item ${breakfast_list[0].recipe_name}");
      // print(breakfast);
      return recipe;
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> breakfastButtonClicked() async {
    try {
      Ur results = await _read(UrRepositoryProvider)
          .updateUrColumn(meal: "ur_breakfast");

      Recipe breakfast = await retrieveRecipebyID(results.ur_breakfast!);

      _list[0] = breakfast;

      notifyListeners();
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  
  Future<void> lunchButtonClicked() async {
    try {
      Ur results = await _read(UrRepositoryProvider)
          .updateUrColumn(meal: "ur_lunch");

      Recipe lunch = await retrieveRecipebyID(results.ur_lunch!);

      _list[1] = lunch;

      notifyListeners();
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

    Future<void> snakcsButtonClicked() async {
    try {
      Ur results = await _read(UrRepositoryProvider)
          .updateUrColumn(meal: "ur_snacks");

      Recipe snacks = await retrieveRecipebyID(results.ur_snacks!);

      _list[2] = snacks;

      notifyListeners();
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

    Future<void> dinnerButtonClicked() async {
    try {
      Ur results = await _read(UrRepositoryProvider)
          .updateUrColumn(meal: "ur_dinner");

      Recipe dinner = await retrieveRecipebyID(results.ur_dinner!);

      _list[3] = dinner;

      notifyListeners();
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }
}

