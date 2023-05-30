import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smart_nutri_track/controller/sign_up_controller.dart';

import '../constant/errorMessage.dart';
import '../models/custom_exception.dart';
import '../models/user_model.dart';
import '../models/validation_item.dart';
import '../utilities/user_shared_preferences.dart';
import 'auth_controller.dart';
import 'auth_repository.dart';

final updateProfileController =
    ChangeNotifierProvider.autoDispose<UpdateProfileController>(
        (ref) => UpdateProfileController(ref.read));

class UpdateProfileController extends ChangeNotifier {
  final Reader _read;

  //TODO: Try change all using TextEditingController
  // TextEditingController otpTextController = TextEditingController();

  UpdateProfileController(this._read);
  final int _nameLength = 3;

  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _email = ValidationItem(null, null);

  ValidationItem get name => _name;
  ValidationItem get email => _email;

  String get getInitialName => _user.name!;
  String get getInitialEmail => _user.email!;

  User _user = User();

  Future<User> getUser() async {
    _user = await _read(authRepositoryProvider).getCurrentUser();

    // initialName(_user.name!);
    // initialEmail(_user.email!);
    print('name ${_name.value}');
    return _user;
    // notifyListeners();
  }

  void initialName(String value) {
    // print('Name: $value');
    _name = ValidationItem(value, null);

    notifyListeners();
  }

  void initialEmail(String value) {
    // print('Email: $value');
    _email = ValidationItem(value, null);

    notifyListeners();
  }

  void changeName(String value) {
    print('Name: $value');
    _name = ValidationItem(value, null);

    notifyListeners();
  }

  void changeEmail(String value) {
    print('Email: $value');
    _email = ValidationItem(value, null);

    notifyListeners();
  }

  bool get isNameValid {
    if (_name.value != null && _name.value!.length >= _nameLength) return true;
    return false;
  }

  bool get isEmailValid {
    if (_email.value != null && EmailValidator.validate(_email.value ?? ''))
      return true;
    return false;
  }

  bool get isValid {
    if (isNameValid && isEmailValid) return true;
    return false;
  }

  bool get isFilled {
    if (_name.value == null && _email.value == null) return false;
    return true;
  }

  bool submitData() {
    if (isValid) {
      print(isValid);
      print("Name: ${_name.value}, Email: ${_email.value}");

      return true;
    } else {
      if (!isNameValid)
        _name = ValidationItem(
            _name.value,
            ErrorMessages.enterMinimumCharactersErrorMessage(
                _nameLength.toString()));

      if (!isEmailValid)
        _email = ValidationItem(
            _email.value, ErrorMessages.enterEmailAddressErrorMessage);

      notifyListeners();
    }

    return false;
  }

  Future<bool> updateUser() async {
    try {
      bool success = await _read(authRepositoryProvider)
          .updateProfileDetails(email: _email.value!, name: _name.value!);

      User updatedUser = User(
        name: _name.value!,
        email: _email.value!,
      );

       _read(authControllerProvider.notifier)
          .updateProfileState(updatedUser: updatedUser);

      return true;
    } on CustomException catch (e) {
      _handleException(e);
    } catch (e) {
      //TODO: Apply this to other functions
      _handleException(
        CustomException(message: "Update Error!"),
      );
    }

    return false;
  }

  void _handleException(CustomException e) {
    //_read(exceptionControllerProvider)!.state =  e;
    //TODO: Revise this validation method, try make it for sign up only
    if (e.errors != null) {
      print("e: $e");
      if (e.errors?['name'] != null) {
        _read(updateProfileController.notifier).editErrorMessage(
          fieldType: 'name',
          errorText: e.errors!['name'][0],
        );
      }

      if (e.errors?['email'] != null) {
        _read(updateProfileController.notifier).editErrorMessage(
          fieldType: 'email',
          errorText: e.errors!['email'][0],
        );
      }
    }
  }

  void editErrorMessage(
      {required String fieldType, required String errorText}) {
    switch (fieldType) {
      case 'name':
        _name = ValidationItem(_name.value, errorText);
        break;
      case 'email':
        _email = ValidationItem(_email.value, errorText);
        break;
      // case 'password_confirmation':
      //   _passwordConfirmation =
      //       ValidationItem(_passwordConfirmation.value, errorText);
      //   break;
    }
    notifyListeners();
  }
}
