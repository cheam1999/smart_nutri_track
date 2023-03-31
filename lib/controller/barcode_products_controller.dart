import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/models/barcode_products_model.dart';

import '../models/custom_exception.dart';
import '../repositories/barcode_products_repository.dart';

// class BarcodeProductsID {
//   final String barcodeProductsId;

//   BarcodeProductsID({
//     required this.barcodeProductsId,
//   });
// }

final barcodeProductsExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final barcodeProductsControllerProvider = StateNotifierProvider.autoDispose
    .family<BarcodeProductsController, AsyncValue<Barcode_products>,
        String>((ref, code) {
  return BarcodeProductsController(ref.read, code);
});

class BarcodeProductsController
    extends StateNotifier<AsyncValue<Barcode_products>> {
  final Reader _read;
  final String _code;

  BarcodeProductsController(this._read, this._code) : super(AsyncLoading()) {
    retrieveBarcodeProducts();
  }

  Future<void> retrieveBarcodeProducts({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final barcodeProducts =
          await _read(BarcodeRepositoryProvider).retrieveBarcodeProducts(_code);

      print(barcodeProducts);

      
    } on CustomException catch (e, st) {
       state = AsyncValue.error(e, stackTrace: st);
    } catch (e) {
      //TODO: handle error
      state = AsyncValue.error(e);
    }
  }
}
