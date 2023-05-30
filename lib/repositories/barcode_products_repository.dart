import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/food_model.dart';
import '../models/custom_exception.dart';

abstract class BaseBarcodeRepository {}

final BarcodeRepositoryProvider =
    Provider<BarcodeRepository>((ref) => BarcodeRepository(ref.read));

class BarcodeRepository implements BaseBarcodeRepository {
  final Reader _read;
  const BarcodeRepository(this._read);

  @override
  Future<Food> retrieveBarcodeProducts(String code) async {
    // final int id = _read(authControllerProvider).id!;
    // String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'get_barcode_products/$code';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    Food result = Food();

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // 'Authorization': 'Bearer $_accesToken',
        },
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        // final results =
        //     List<Map<String, dynamic>>.from(json.decode(responseBody));

        // print(results.runtimeType);

        // Food item = results
        //     .map((item) => Food.fromMap(item))
        //     .toList(growable: false);
        // print('Response status: ${response.statusCode}');
        // return Food.fromJson(response.body);
        Food item = Food.fromJson(responseBody);
        print(item.food_name);
        return item;
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
