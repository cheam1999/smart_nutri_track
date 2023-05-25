import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/models/recipe_model.dart';

import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseRecipeRepository {
  Future<List<Map<String, dynamic>>> retrieveBreakfastRecipe();
}

final recipeRepositoryProvider =
    Provider<RecipeRepository>((ref) => RecipeRepository(ref.read));

class RecipeRepository implements BaseRecipeRepository {
  final Reader _read;
  const RecipeRepository(this._read);

  @override
  Future<List<Map<String, dynamic>>> retrieveBreakfastRecipe() async {
    final String apiRoute = 'get_breakfast_recipe';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    print("Requesting to $url");

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      final results =
          List<Map<String, dynamic>>.from(json.decode(responseBody));
      return results;
    } else {
      throw CustomException(message: 'Failed to retrieve recipe!');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> retrieveLunchRecipe() async {
    final String apiRoute = 'get_lunch_recipe';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    print("Requesting to $url");

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      final results =
          List<Map<String, dynamic>>.from(json.decode(responseBody));
      return results;
    } else {
      throw CustomException(message: 'Failed to retrieve recipe!');
    }
  }
}
