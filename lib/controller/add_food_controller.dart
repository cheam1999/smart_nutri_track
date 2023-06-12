import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/repositories/add_food_repository.dart';

import '../models/custom_exception.dart';
import '../models/food_intakes.dart';
import '../models/validation_item.dart';
import '../repositories/meal_repository.dart';

final addFoodControllerProvider =
    ChangeNotifierProvider.autoDispose<AddFoodController>((ref) {
  return AddFoodController(ref.read);
});

class AddFoodController extends ChangeNotifier {
  final Reader _read;
  // final String _listType;
  // int _page = 1;

  AddFoodController(this._read);

  ValidationItem _name = ValidationItem(null, null);
  ValidationItem get name => _name;

  ValidationItem _quantity = ValidationItem(null, null);
  ValidationItem get quantity => _quantity;

  ValidationItem _size = ValidationItem(null, null);
  ValidationItem get size => _size;

  ValidationItem _energy = ValidationItem(null, null);
  ValidationItem get energy => _energy;

  ValidationItem _carb = ValidationItem(null, null);
  ValidationItem get carb => _carb;

  ValidationItem _protein = ValidationItem(null, null);
  ValidationItem get protein => _protein;

  ValidationItem _sodium = ValidationItem(null, null);
  ValidationItem get sodium => _sodium;

  ValidationItem _calcium = ValidationItem(null, null);
  ValidationItem get calcium => _calcium;

  void changeName(String value) {
    _name = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeQuantity(String value) {
    _quantity = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeSize(String value) {
    _size = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeEnergy(String value) {
    _energy = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeCarb(String value) {
    _carb = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeProtein(String value) {
    _protein = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeSodium(String value) {
    _sodium = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  void changeCalcium(String value) {
    _calcium = ValidationItem(value.trim(), null);

    notifyListeners();
  }

  String setNameInitialValue(String val) {
    changeSize(val);
    return _size.value!;
  }

  bool get isNameValid {
    if (_name.value != "" && _name.value != null) return true;

    return false;
  }

  bool get isQuantityValid {
    if (_quantity.value != null) return true;

    return false;
  }

  bool get isSizeValid {
    if (_size.value != null) return true;

    return false;
  }

  bool get isEnergyValid {
    if (_energy.value != null) return true;

    return false;
  }

  bool get isCarbValid {
    if (_carb.value != null) return true;

    return false;
  }

  bool get isProteinValid {
    if (_protein.value != null) return true;

    return false;
  }

  bool get isSodiumValid {
    if (_sodium.value != null) return true;

    return false;
  }

  bool get isCalciumValid {
    if (_calcium.value != null) return true;

    return false;
  }

  bool get submitDataValid {
    if (isNameValid &&
        isQuantityValid &&
        isSizeValid &&
        isEnergyValid &&
        isCarbValid &&
        isProteinValid &&
        isSodiumValid &&
        isCalciumValid) return true;

    return false;
  }

  Future<bool> saveFood() async {
    bool success = false;
    print("name $isNameValid ");
    print("quan $isQuantityValid ");
    print("size  $isSizeValid ");
    print("energy $isEnergyValid ");
    print("carb $isCarbValid ");
    print("pro $isProteinValid ");
    print("so $isSodiumValid ");
    print("cal $isCalciumValid ");
    if (submitDataValid) {
      try {
        // success = await _read(MealRepositoryProvider).saveMeals(
        //     meal: cat.value!, size: int.parse(size.value!), food_id: food_id);
        print('enter controller');
        success = await _read(AddFoodRepositoryProvider).addFood(
            name: _name.value!,
            quantity: int.parse(_quantity.value!),
            size: int.parse(_size.value!),
            energy: int.parse(_energy.value!),
            carb: double.parse(_carb.value!),
            protein: double.parse(_protein.value!),
            sodium: double.parse(_sodium.value!),
            calcium: double.parse(_calcium.value!));

        print('sucess: $success');
      } on CustomException catch (e) {
        print(e);
      } catch (e) {
        //TODO: Apply this to other functions
        print(e);
        CustomException(message: "Save Food Error!");
      }

      return success;
    } else {
      if (!isNameValid) {
        String errorName = "Please enter the food name";

        _name = ValidationItem(_name.value, errorName);
      }
      if (!isQuantityValid) {
        String errorQuantity = "Please enter the food Quantity";

        _quantity = ValidationItem(_quantity.value, errorQuantity);
      }
      if (!isSizeValid) {
        String errorSize = "Please enter the serving size";

        print(errorSize);
        _size = ValidationItem(_size.value, errorSize);
      }
      if (!isEnergyValid) {
        String errorEnergy = "Please enter the energy in kcal";

        _energy = ValidationItem(_energy.value, errorEnergy);
      }
      if (!isCarbValid) {
        String errorCarb = "Please enter the total carbohydrate";

        _carb = ValidationItem(_name.value, errorCarb);
      }
      if (!isProteinValid) {
        String errorProtein = "Please enter the total protein";

        _protein = ValidationItem(_protein.value, errorProtein);
      }

      if (!isSodiumValid) {
        String errorSodium = "Please enter the total sodium";

        _sodium = ValidationItem(_sodium.value, errorSodium);
      }

      if (!isCalciumValid) {
        String errorCalcium = "Please enter the total calcium";

        _calcium = ValidationItem(_calcium.value, errorCalcium);
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
