import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/repositories/food_repository.dart';

import '../models/custom_exception.dart';
import '../models/food_model.dart';

final foodControllerProvider =
    ChangeNotifierProvider.autoDispose<FoodController>((ref) {
  return FoodController(ref.read);
});

class FoodController extends ChangeNotifier {
  final Reader _read;
  List<Food> food = [];
  List<Food> searched = [];
  String searchWord = '';

  String get getsearchWord => searchWord;

  void changeSearchWord(String value) {
    searchWord = value;
    print('search $searchWord');
    notifyListeners();
  }

  FoodController(this._read) : super() {
    retrieveFood();
  }

  Future<List<Food>> getSearchResult() async => searched;

  Future<List<Food>> retrieveFood() async {
    try {
      List<Food> food = await _read(FoodRepositoryProvider).retrieveFood();

      return food;
    } on CustomException catch (e, st) {
      return Future.error(e);
    } catch (e) {
      //TODO: handle error
      return Future.error(e);
    }
  }

  void refresh() {
    searchWord = "";
    notifyListeners();
  }

  Future<void> filterSearchResults(String value) async {
    // searched.clear();
    if (value == "") {
      searched.clear();
    }

    changeSearchWord(value);

    if (food.isEmpty) {
      print('food $food');
      food = await retrieveFood();
    }
    searched = food
        .where((item) =>
            item.food_name!.toLowerCase().contains(searchWord.toLowerCase()))
        .toList();
    print('Search $searched');
    // getSearchResult();
    notifyListeners();
  }
}
