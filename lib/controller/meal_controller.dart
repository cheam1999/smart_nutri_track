import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/custom_exception.dart';
import '../models/food_intakes.dart';
import '../repositories/meal_repository.dart';

final mealControllerProvider = StateNotifierProvider.autoDispose
    .family<MealController, AsyncValue<List<Food_intakes>>, String>(
        (ref, listType) {
  return MealController(ref.read, listType);
});

class MealController extends StateNotifier<AsyncValue<List<Food_intakes>>> {
  final Reader _read;
  final String _listType;
  // int _page = 1;

  List<double> _intake_serving_size = [];
  List<String> _food_name = [];


  MealController(this._read, this._listType) : super(AsyncLoading()) {
    retrieveMeals();
  }

  Future<void> retrieveMeals({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final meals = await _read(MealRepositoryProvider).retrieveMeals();
      // this._page++;

      // if (mounted) {
      //   if (state.data == null)
      //     // state = AsyncValue.data(meals);
      //   else
      //     // state = state.whenData((d) => [...d, ...meals]);
      // }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e);
    } catch (e) {
      //TODO: handle error
      state = AsyncValue.error(e);
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