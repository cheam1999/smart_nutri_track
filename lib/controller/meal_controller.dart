import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/custom_exception.dart';
import '../models/food_intakes.dart';
import '../models/validation_item.dart';
import '../repositories/meal_repository.dart';

final mealControllerProvider =
    ChangeNotifierProvider.autoDispose<MealController>((ref) {
  return MealController(ref.read);
});

class MealController extends ChangeNotifier {
  final Reader _read;
  // final String _listType;
  // int _page = 1;

  MealController(this._read);

  ValidationItem _size = ValidationItem(null, null);
  ValidationItem get size => _size;

  ValidationItem _cat = ValidationItem(null, null);
  ValidationItem get cat => _cat;

  void changeSize(String value) {
    _size = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeCat(String value) {
    _cat = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  bool get isSizeValid {
    if (_size.value != "" && _size.value != null) return true;

    return false;
  }

  bool get isCatValid {
    if (_size.value != "" && _size.value != null) return true;

    return false;
  }

  bool get submitDataValid {
    if (isSizeValid && isCatValid) return true;

    return false;
  }

  Future<bool> saveMeals({
    required String meal,
    // required int size,
    required int food_id,
  }) async {
    bool success = false;
    print("is size valid: $isSizeValid catvalid: $isCatValid ");

    if (submitDataValid) {
      try {
        success = await _read(MealRepositoryProvider).saveMeals(
            meal: cat.value!, size: int.parse(size.value!), food_id: food_id);

        print('sucess: $success');
      } on CustomException catch (e) {
        print(e);
      } catch (e) {
        //TODO: Apply this to other functions
        CustomException(message: "Save Meal Error!");
      }

      return success;
    } else {
      if (!isSizeValid) {
        String errorSize = "Please enter the intake size";

        print(errorSize);
        _size = ValidationItem(_size.value, errorSize);
      }
      if (!isCatValid) {
        String errorCat = "Please select a meal";

        print(errorCat);
        _cat = ValidationItem(_cat.error,errorCat);
      }


      notifyListeners();
      return false;
    }
  }
  // void handleScrollWithIndex(int index) {
  //   final itemPosition = index + 1;
  //   final requestMoreData = itemPosition % 5 == 0 && itemPosition != 0;
  //   final pageToRequest = itemPosition ~/ 5;

  //   if (requestMoreData && pageToRequest + 1 >= this._page) {
  //     retrieveMeals();
  //   }
  // }
}
