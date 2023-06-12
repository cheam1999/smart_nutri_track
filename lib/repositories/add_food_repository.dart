import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';

abstract class BaseAddFoodRepository {
  Future<bool> addFood({
    required String name,
    required int quantity,
    required int size,
    required int energy,
    required double carb,
    required double protein,
    required double sodium,
    required double calcium,
  });
  //  Future<List<Food_intakes>> retrieveAddFoods();
}

final AddFoodRepositoryProvider =
    Provider<AddFoodRepository>((ref) => AddFoodRepository(ref.read));

class AddFoodRepository implements BaseAddFoodRepository {
  final Reader _read;
  const AddFoodRepository(this._read);

  @override
  Future<bool> addFood({
    required String name,
    required int quantity,
    required int size,
    required int energy,
    required double carb,
    required double protein,
    required double sodium,
    required double calcium,
  }) async {
    // final int id = _read(authControllerProvider).id!;
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'create_food';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('entered add food ${sodium.runtimeType}');

    print('Requesting to $url');

    try {
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
        body: jsonEncode({
          'food_name': name,
          'food_quantity': quantity,
          'food_serving_size': size,
          'energy_kcal_100g': energy,
          'carbohydrates_100g': carb,
          'proteins_100g': protein,
          'sodium_100g': sodium,
          'calcium_100g': calcium
        }),
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        print("response body: $responseBody");

        if (responseBody == '0')
          return false;
        else
          return true;
      } else {
        throw CustomException(message: 'Failed to create food!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
