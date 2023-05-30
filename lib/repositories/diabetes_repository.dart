import 'dart:convert';
import 'dart:ffi';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/food_model.dart';
import '../models/custom_exception.dart';

abstract class BaseDiabetesRepository {}

final DiabetesRepositoryProvider =
    Provider<DiabetesRepository>((ref) => DiabetesRepository(ref.read));

class DiabetesRepository implements BaseDiabetesRepository {
  final Reader _read;
  const DiabetesRepository(this._read);

  @override
  Future<void> retrieveDiabetesProducts() async {
    var url = Uri.parse(
        ' https://snt-diabetes-api.herokuapp.com/diabetes_prediction');
    
    var inputDataForModel = json.encode({
      'Carbohydrate_intake': 70.2,
    });

    try {
      var response = await http.post(
        url,
        body: inputDataForModel,
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
