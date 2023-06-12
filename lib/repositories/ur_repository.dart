import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../env.dart';
import '../models/custom_exception.dart';
import '../models/ur_model.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseUrRepository {
  Future<Ur> retrieveUrByUserID();
  Future<Ur> updateUrColumn({required String meal});
}

final UrRepositoryProvider =
    Provider<UrRepository>((ref) => UrRepository(ref.read));

class UrRepository implements BaseUrRepository {
  final Reader _read;
  const UrRepository(this._read);

  @override
  Future<Ur> retrieveUrByUserID() async {
    final String apiRoute = 'get_by_userID';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    print("Requesting to $url");

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
    );

    print('Response status: user by id ${response.statusCode}');
    // print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      var results = json.decode(responseBody);
      // print(results[0]['id']);

      Ur temp = Ur(
          id: results[0]['id'],
          ur_breakfast: results[0]['ur_breakfast'],
          ur_lunch: results[0]['ur_lunch'],
          ur_snacks: results[0]['ur_snacks'],
          ur_dinner: results[0]['ur_dinner'],
          ur_date: results[0]['ur_date']);

      return temp;
    } else {
      throw CustomException(message: 'Failed to retrieve recipe!');
    }
  }

  @override
  Future<Ur> updateUrColumn({required String meal}) async {
    final String apiRoute = 'updateUr';
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute + '/$meal');
    print('Requesting to $url');
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      var results = json.decode(responseBody);
      // print(results[0]['id']);

      Ur temp = Ur(
          id: results[0]['id'],
          ur_breakfast: results[0]['ur_breakfast'],
          ur_lunch: results[0]['ur_lunch'],
          ur_snacks: results[0]['ur_snacks'],
          ur_dinner: results[0]['ur_dinner'],
          ur_date: results[0]['ur_date']);

      return temp;
    } else {
      throw CustomException(message: "Failed to give recommendation");
    }
  }


}
