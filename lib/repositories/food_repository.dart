import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/models/food_model.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseFoodRepository {
  Future<List<Food>> retrieveFood();
}

final FoodRepositoryProvider =
    Provider<FoodRepository>((ref) => FoodRepository(ref.read));

class FoodRepository implements BaseFoodRepository {
  final Reader _read;
  const FoodRepository(this._read);

  @override
  Future<List<Food>> retrieveFood() async {
    // final int id = _read(authControllerProvider).id!;
    // String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'get_all_food';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      print('Response status 2: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        final results =
            List<Map<String, dynamic>>.from(json.decode(responseBody));

        List<Food> items = List.filled(results.length, Food());

        for (var i = 0; i < results.length; i++) {
          Food temp = Food(
              id: results[i]['id'],
              food_code: results[i]['food_code'],
              food_name: results[i]['food_name'],
              food_quantity: results[i]['food_quantity'],
              food_serving_size: results[i]['food_serving_size'],
              energy_kcal_100g: results[i]['energy_kcal_100g'],
              carbohydrates_100g: '${results[i]['carbohydrates_100g']}',
              proteins_100g: '${results[i]['proteins_100g']}',
              sodium_100g: '${results[i]['sodium_100g']}',
              calcium_100g: '${results[i]['calcium_100g']}');

          items[i] = temp;
        }
        // List<Food> items =
        //     results.map((item) => Food.fromMap(item)).toList(growable: false);
        // // print(items[0]);
        // print('enter2 ${items}');
        return items;
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
