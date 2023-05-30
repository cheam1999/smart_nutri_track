import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/custom_exception.dart';
import '../models/user_model.dart';
import '../utilities/user_shared_preferences.dart';
import 'auth_controller.dart';

abstract class BaseAuthRepository {
  Future<User> getCurrentUser();
  Future<User> signIn({required String loginInfo, required String password});
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
    //required String password_confirmation,
  });

  // Future<User> updateUserDetails({
  //   required String name,
  //   required String email,
  // });
  Future<void> signOut();
  // Future<int> getUserIdByEmail({
  //   email = null,
  //   // studentEmail = null,
  // });
  Future<bool> changePassword({required int id, required String password});
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository implements BaseAuthRepository {
  // You can refer to other provider with this (must initialize in constructor)
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Future<User> getCurrentUser() async {
    final String apiRoute = 'me';

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute);
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
    print('Response body me: ${response.body}');

    // var responseBody = json.decode(response.body);
    var responseBody = response.body;

    if (response.statusCode == 200) {
      var decode_results = json.decode(responseBody);

      print('test ${decode_results[0]}');
      User user = User(
          id: decode_results[0]['id'],
          name: decode_results[0]['name'],
          email: decode_results[0]['email'],
          accessToken: decode_results[0]['accessToken'],
          tokenType: decode_results[0]['tokenType'],
          isLogin: decode_results[0]['isLogin']);

      return user;
    } else {
      throw response.statusCode;
    }
  }

  @override
  Future<void> signOut() async {
    final String apiRoute = 'logout';

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute);
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
  }

  @override
  Future<User> signIn(
      {required String loginInfo, required String password}) async {
    final String apiRoute = 'login';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer $accesToken',
      },
      body: jsonEncode({'email': loginInfo, 'password': password}),
    );
    print('Response status: ${response.statusCode}');

    // var responseBody = json.decode(response.body);
    var responseBody = response.body;
    print('Response body: $responseBody');
    if (response.statusCode == 200) {
      var decode_results = json.decode(responseBody);

      print('test ${decode_results[0]['id']}');
      User user = User(
          id: decode_results[0]['id'],
          name: decode_results[0]['name'],
          email: decode_results[0]['email'],
          accessToken: decode_results[0]['accessToken'],
          tokenType: decode_results[0]['tokenType'],
          isLogin: decode_results[0]['isLogin']);

      return user;
    } else {
      throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }

  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password, //required String password_confirmation,
  }) async {
    final String apiRoute = 'register';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer $accesToken',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    var responseBody = response.body;
    // print('user: ${responseBody.runtimeType}');
    if (response.statusCode == 200) {
      var decode_results = json.decode(responseBody);

      // print('test ${temp[0]['id']}');
      User user = User(
          id: decode_results[0]['id'],
          name: decode_results[0]['name'],
          email: decode_results[0]['email'],
          accessToken: decode_results[0]['accessToken'],
          tokenType: decode_results[0]['tokenType'],
          isLogin: decode_results[0]['isLogin']);

      return user;
    } else {
      throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }

  @override
  Future<bool> changePassword(
      {required int id, required String password}) async {
    final String apiRoute = 'change_password';

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'id': id, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      return json.decode(responseBody)['success'];
    } else {
      throw CustomException(message: "Failed to update password");
    }
  }

  @override
  Future<bool> updateProfileDetails(
      {required String name, required String email}) async {
    final String apiRoute = 'updateProfileDetails';
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    var url = Uri.parse(env!.baseUrl + apiRoute);
    print('Requesting to $url');
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
      body: jsonEncode({'email': email, 'name': name}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var responseBody = response.body;

    if (response.statusCode == 200) {
      if (responseBody == '0') {
        return false;
      } else {
        return true;
      }
    } else {
       throw CustomException.fromJson(
          jsonDecode(responseBody) as Map<String, dynamic>);
    }
  }
}
