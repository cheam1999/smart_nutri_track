import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/repositories/ur_repository.dart';

import '../env.dart';
import '../models/custom_exception.dart';
import '../models/ingredients.dart';
import '../models/ur_model.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseIngredientsRepository {
  Future<List<Ingredients>> generateGroceryList();
}

final ingredientsRepositoryProvider =
    Provider<IngredientsRepository>((ref) => IngredientsRepository(ref.read));

class IngredientsRepository implements BaseIngredientsRepository {
  final Reader _read;
  const IngredientsRepository(this._read);

  Future<List<Ingredients>> generateGroceryList() async {
    final String apiRoute = 'generate_grocery';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    print("Requesting to $url");

    Ur temp = await _read(UrRepositoryProvider).retrieveUrByUserID();

    try {
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'breakfast': temp.ur_breakfast!,
          'lunch': temp.ur_lunch!,
          'snacks': temp.ur_snacks!,
          'dinner': temp.ur_dinner!
        }),
      );

      print('Response status recipe by id: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;

      if (response.statusCode == 200) {
        final results =
            List<Map<String, dynamic>>.from(json.decode(responseBody));

//         List<Ingredients> items = results
//             .map((item) => Ingredients.fromMap(item))
//             .toList(growable: false);
// print(items);

        List<Ingredients> items = List.filled(results.length, Ingredients());
        for (var i = 0; i < results.length; i++) {
          Ingredients temp = Ingredients(
              ingredients_name: results[i]['ingredients_name'],
              amount: results[i]['amount'],
              measure_name: results[i]['measure_name']);

          items[i] = temp;
        }
        return items;
      } else {
        throw CustomException(message: 'Failed to retrieve recipe!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
