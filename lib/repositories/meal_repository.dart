import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_nutri_track/models/food_intakes.dart';

import '../env.dart';
import '../models/barcode_products_model.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';

abstract class BaseMealRepository {
  Future<void> retrieveMeals();
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
}
