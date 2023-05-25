// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../models/custom_exception.dart';
// import '../models/recipe_model.dart';
// import '../repositories/recipe_repository.dart';

// final recipeControllerProvider =
//     ChangeNotifierProvider.autoDispose<RecipeController>((ref) {
//   return RecipeController(ref.read);
// });

// class RecipeController extends ChangeNotifier {
//   final Reader _read;
//   var breakfast_list;

//   RecipeController(this._read);

//   Future<void> retrieveRecipe() async {
//     await Future.delayed(Duration(milliseconds: 500));
//     try {
//       breakfast_list = (await _read(recipeRepositoryProvider)
//           .retrieveBreakfastRecipe()) as Recipe;
//     } on CustomException catch (e, st) {
//       print(e);
//     } catch (e) {
//       CustomException(message: "Retrieve Recipe Error!");
//     }
//   }
// }
