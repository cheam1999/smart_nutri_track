import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';

abstract class BaseMealRepository {
  Future<void> retrieveMeals();
  Future<bool> saveMeals({
    required String meal,
    required int size,
    required int food_id,
  });
  //  Future<List<Food_intakes>> retrieveMeals();
}

final MealRepositoryProvider =
    Provider<MealRepository>((ref) => MealRepository(ref.read));

class MealRepository implements BaseMealRepository {
  final Reader _read;
  const MealRepository(this._read);

  @override
  Future<void> retrieveMeals() async {
    // final int id = _read(authControllerProvider).id!;
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = '/get_current_meals';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        final results =
            List<Map<String, dynamic>>.from(json.decode(responseBody));

        print(responseBody);
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> saveMeals(
    {
    required String meal,
    required int size,
    required int food_id,
  }
  ) async {
    // final int id = _read(authControllerProvider).id!;
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'save_meal';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
        body: jsonEncode(
            {'meal': meal, 'intake_serving_size': size, 'food_id': food_id}),
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        print(responseBody);

        if (responseBody == '0')
          return false;
        else
          return true;

      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
