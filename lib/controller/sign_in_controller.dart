import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/controller/validation_item_model.dart';

import '../constant/errorMessage.dart';
import 'auth_controller.dart';

final signInController = ChangeNotifierProvider.autoDispose<SignInController>(
    (ref) => SignInController(ref.read));

class SignInController extends ChangeNotifier {
  final Reader _read;

  SignInController(this._read);

  ValidationItem _loginInfo = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  // Decalre getters
  ValidationItem get loginInfo => _loginInfo;
  ValidationItem get password => _password;

  bool get isValid {
    // if (_loginInfo.value != null && _password.value != null) return true;
    if (isLoginInfoValid && isPasswordValid && isFilled) return true;
    return false;
  }

  bool get isFilled {
    if (_loginInfo.value != null &&
        _password.value != null &&
        _loginInfo.value!.length > 0 &&
        _password.value!.length > 0) return true;
    return false;
  }

  bool get isLoginInfoValid {
    if (_loginInfo.value != null && _loginInfo.value!.length > 0) return true;
    return false;
  }

  bool get isPasswordValid {
    if (_password.value != null && _password.value!.length > 0) return true;
    return false;
  }

  // Declare setters
  void changeloginInfo(String value) {
    print('Login: $value');

    _loginInfo = ValidationItem(value, null);

    notifyListeners();
  }

  void changePassword(String value) {
    print('Password: $value');

    _password = ValidationItem(value, null);
    notifyListeners();
  }

  Future<bool> submitData() async {
    if (isValid) {
      print("Login Info: ${loginInfo.value}, Password: ${_password.value}");

      bool isSuccess = await _read(authControllerProvider.notifier).signIn(
          loginInfo: loginInfo.value!.trim(), password: _password.value!);

      return isSuccess;
    } else {
      if (!isLoginInfoValid)
        _loginInfo = ValidationItem(
            _loginInfo.value, ErrorMessages.enterValueErrorMessage);

      if (!isPasswordValid)
        _password = ValidationItem(
            _password.value, ErrorMessages.enterValueErrorMessage);

      print(isPasswordValid);
      notifyListeners();
    }

    return false;
  }

  // void testAuthController() async {
  //   await _read(authRepositoryProvider).signOut();
  // }
}
