import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/models/food_model.dart';

import '../constant/colour_constant.dart';
import '../controller/barcode_products_controller.dart';
import '../controller/camera_view.dart';
import '../controller/painters/barcode_detector_painter.dart';
import '../repositories/barcode_products_repository.dart';
import 'barcode_details.dart';

class BarcodeScanningScreen extends HookConsumerWidget {
  static String routeName = "/barcodeScanning";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBlueColor,
      extendBodyBehindAppBar: true,
      body: _BarcodeScanningScreen(),
    );
  }
}

class _BarcodeScanningScreen extends HookConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CameraView(
      title: 'Barcode Scanner',
    );
  }
}
