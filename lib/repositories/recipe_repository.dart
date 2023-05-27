import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/models/recipe_model.dart';

import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseRecipeRepository {
  Future<Recipe> retrieveRecipebyID(int id);
}

final recipeRepositoryProvider =
    Provider<RecipeRepository>((ref) => RecipeRepository(ref.read));

class RecipeRepository implements BaseRecipeRepository {
  final Reader _read;
  const RecipeRepository(this._read);

  @override
  Future<Recipe> retrieveRecipebyID(int id) async {
    final String apiRoute = 'get_recipe_by_id';
    var url = Uri.parse(env!.baseUrl + apiRoute + '/$id');
    print("Requesting to $url");

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      print('Response status recipe by id: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;

      if (response.statusCode == 200) {
        var decode_results = json.decode(responseBody);

        Recipe results = Recipe(
          recipe_id: decode_results[0]['recipe_id'],
          recipe_name: decode_results[0]['recipe_name'],
          recipe_image: decode_results[0]['recipe_image'],
          recipe_ingredients: decode_results[0]['recipe_ingredients'],
          recipe_instructions: decode_results[0]['recipe_instructions'],
          recipe_source: decode_results[0]['recipe_source'],
          recipe_meal: decode_results[0]['recipe_meal']
        );

        return results;
      } else {
        throw CustomException(message: 'Failed to retrieve recipe!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // @override
  // Future<List<Map<String, dynamic>>> retrieveLunchRecipe() async {
  //   final String apiRoute = 'get_lunch_recipe';
  //   var url = Uri.parse(env!.baseUrl + apiRoute);
  //   print("Requesting to $url");

  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //     },
  //   );

  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');

  //   var responseBody = response.body;

  //   if (response.statusCode == 200) {
  //     final results =
  //         List<Map<String, dynamic>>.from(json.decode(responseBody));
  //     return results;
  //   } else {
  //     throw CustomException(message: 'Failed to retrieve recipe!');
  //   }
  // }
}
