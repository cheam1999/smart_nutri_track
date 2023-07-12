import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/controller/add_food_controller.dart';
import 'package:smart_nutri_track/controller/barcode_products_controller.dart';
import 'package:smart_nutri_track/controller/meal_controller.dart';
import 'package:smart_nutri_track/models/meal_category_model.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../component/default_button.dart';
import '../constant/colour_constant.dart';
import '../controller/camera_view.dart';
import '../controller/food_controller.dart';
import '../controller/painters/barcode_detector_painter.dart';
import '../models/food_model.dart';
import '../models/custom_exception.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import 'package:intl/intl.dart';

class AddFoodScreen extends HookConsumerWidget {
  static String routeName = "/addFood";

  AddFoodScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var today = DateTime.now();
    final addFoodControllerState = ref.watch(addFoodControllerProvider);
    final nameController = useTextEditingController();
    final quantityController = useTextEditingController();
    final sizeController = useTextEditingController();
    final energyController = useTextEditingController();
    final carbController = useTextEditingController();
    final proteinController = useTextEditingController();
    final sodiumController = useTextEditingController();
    final calciumController = useTextEditingController();
    // List<String> meal = [
    //   "BREAKFAST",
    //   "LUNCH",
    //   "DINNER",
    //   "SNACKS",
    // ];
    return Scaffold(
        backgroundColor: ColourConstant.kWhiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Add Food",
            style: TextStyle(
              color: ColourConstant.kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
            child: SingleChildScrollView(
                child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Food Name',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: nameController,
                                      // initialValue: await ref
                                      //     .read(addFoodControllerProvider)
                                      //     .setNameInitialValue(
                                      //         '${ref.read(foodControllerProvider).getsearchWord}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.name.error,
                                        hintText: "Name of the food",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeName(value);
                                      },
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: quantityController,
                                      // initialValue: ref
                                      //     .read(addFoodControllerProvider)
                                      //     .setNameInitialValue(
                                      //         '${ref.read(foodControllerProvider).getsearchWord}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.name.error,
                                        hintText:
                                            "Total food quantity (unit/gram)",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeQuantity(value);
                                      },
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Serving Size',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: sizeController,
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.size.error,
                                        hintText:
                                            "serving size in gram, ml or unit",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeSize(value);
                                      },
                                    ))
                              ],
                            ),
                            Divider(
                              color: ColourConstant.kDarkColor,
                              thickness: 0.5,
                              height: getProportionateScreenHeight(30),
                            ),
                            // SizedBox(height: getProportionateScreenHeight(20),),
                            Text(
                              'Nutrition',
                              style: TextStyle(
                                  fontSize: ColourConstant.h3,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Total Energy',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: energyController,
                                      // initialValue: ref
                                      //     .read(addFoodControllerProvider)
                                      //     .setNameInitialValue(
                                      //         '${ref.read(foodControllerProvider).getsearchWord}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.energy.error,
                                        hintText:
                                            "Total energy in kcal for 100g",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeEnergy(value);
                                      },
                                    ))
                              ],
                            ),
                            // SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Carbohydrates',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: carbController,
                                      // initialValue: ref
                                      //     .read(addFoodControllerProvider)
                                      //     .setNameInitialValue(
                                      //         '${ref.read(foodControllerProvider).getsearchWord}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.carb.error,
                                        hintText:
                                            "Total carbohydrates for 100g",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeCarb(value);
                                      },
                                    ))
                              ],
                            ),
                            // SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Protein',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: proteinController,
                                      // initialValue: ref.read(mealControllerProvider).setInitialValue('${food!.food_serving_size}'),
                                      decoration: InputDecoration(
                                        errorText: addFoodControllerState
                                            .protein.error,
                                        hintText: "Total protein for 100g",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeProtein(value);
                                      },
                                    ))
                              ],
                            ),
                            // SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Sodium',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: sodiumController,
                                      // initialValue: ref.read(mealControllerProvider).setInitialValue('${food!.food_serving_size}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            addFoodControllerState.sodium.error,
                                        hintText: "Total sodium for 100g (mg)",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeSodium(value);
                                      },
                                    ))
                              ],
                            ),
                            // SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Calcium',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: calciumController,
                                      // initialValue: ref.read(mealControllerProvider).setInitialValue('${food!.food_serving_size}'),
                                      decoration: InputDecoration(
                                        errorText: addFoodControllerState
                                            .calcium.error,
                                        hintText: "Total calcium for 100g (mg)",
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(addFoodControllerProvider)
                                            .changeCalcium(value);
                                      },
                                    ))
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            DefaultButton(
                                text: "Add food",
                                press: () async {
                                  print('buttonn clicked');
                                  final bool success = await ref
                                      .read(addFoodControllerProvider)
                                      .saveFood();

                                  if (success) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      InitScreen.routeName,
                                      ModalRoute.withName('/'),
                                    );
                                  }
                                }),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            DefaultButton(
                              text: "Not Now",
                              press: () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                InitScreen.routeName,
                                ModalRoute.withName('/'),
                              ),
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}
