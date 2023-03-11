import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';

class HomeScreen extends HookConsumerWidget {
  static String routeName = "/home";
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBlueColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          " Home",
          style: TextStyle(
            color: ColourConstant.kWhiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox.expand(child: Container(
        child: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Expanded(
            child: RefreshIndicator(
              displacement: 10,
              onRefresh: () async {
                // await ref
                //     .read(authControllerProvider.notifier)
                //     .getFoodSavedAndWaste();
              },
              child: Container(
                child: SingleChildScrollView(

                ),
              ),
            ),
          );
        })),
      )),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Meal",
        backgroundColor: ColourConstant.kButtonColor,
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BarcodeScanningScreen()
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 20,
          color: ColourConstant.kWhiteColor,
        ),
      ),
    );
  }
}
