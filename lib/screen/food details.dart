import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/controller/barcode_products_controller.dart';
import 'package:smart_nutri_track/controller/meal_controller.dart';
import 'package:smart_nutri_track/models/meal_category_model.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../component/default_button.dart';
import '../constant/colour_constant.dart';
import '../controller/camera_view.dart';
import '../controller/painters/barcode_detector_painter.dart';
import '../models/food_model.dart';
import '../models/custom_exception.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import 'package:intl/intl.dart';

class FoodDetailScreen extends HookConsumerWidget {
  static String routeName = "/foodDetails";

  FoodDetailScreen({Key? key, this.food}) : super(key: key);

  Food? food;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var today = DateTime.now();
    final mealControllerState = ref.watch(mealControllerProvider);
    final sizeController = useTextEditingController();

    List<String> meal = [
      "BREAKFAST",
      "LUNCH",
      "DINNER",
      "SNACKS",
    ];
    return Scaffold(
        backgroundColor: ColourConstant.kWhiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Add Meal",
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
                            Text(
                              food!.food_name!,
                              style: TextStyle(
                                fontSize: ColourConstant.h1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              color: ColourConstant.kDarkColor,
                              thickness: 0.5,
                              height: getProportionateScreenHeight(30),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${today.toString().substring(0, 10)}",
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kBlueColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Meal',
                                    style: TextStyle(
                                      fontSize: ColourConstant.h4,
                                      color: ColourConstant.kDarkColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      // labelText: "Meal",
                                      errorText: mealControllerState.cat.error,
                                    ),
                                    hint: Text("Select your meal"),
                                    value: ref.watch(mealControllerProvider).cat.value, 
                                    //mealControllerState.cat.value,
                                    onChanged: (String? value) {
                                      ref
                                          .read(mealControllerProvider)
                                          .changeCat(value!);
                                    },
                                    items: meal
                                        .map(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              '${value}',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
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
                                      // controller: sizeController,
                                      initialValue: ref.read(mealControllerProvider).setInitialValue('${food!.food_serving_size}'),
                                      decoration: InputDecoration(
                                        errorText:
                                            mealControllerState.size.error,
                                        hintText:
                                            "serving size in gram (g) or ml",
                                        
                                      ),
                                      onChanged: (String value) {
                                        ref
                                            .read(mealControllerProvider)
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
                            Text(
                              'Nutrition',
                              style: TextStyle(
                                  fontSize: ColourConstant.h3,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Carbohydrates'),
                                Text(
                                  '${food!.carbohydrates_100g} g',
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Protein'),
                                Text(
                                  '${food!.proteins_100g} g',
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sodium'),
                                Text(
                                  '${food!.sodium_100g} g',
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Calcium'),
                                Text(
                                  '${food!.calcium_100g} g',
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            DefaultButton(
                                text: "Add meal",
                                press: () async {
                                  final bool success = await ref
                                      .read(mealControllerProvider)
                                      .saveMeals(
                                          meal: "Breakfast",
                                          // size: 100,
                                          food_id: food!.id!);

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

  // @override
  // Future<Food> retrieveBarcodeProducts(String code) async {
  //   // final int id = _read(authControllerProvider).id!;
  //   // String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
  //   final String apiRoute = 'get_barcode_products/$code';
  //   var url = Uri.parse(env!.baseUrl + apiRoute);
  //   Food result = Food();

  //   print('Requesting to $url');

  //   try {
  //     var response = await http.get(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json",
  //         // 'Authorization': 'Bearer $_accesToken',
  //       },
  //     );

  //     print('Response status: ${response.statusCode}');
  //     // print('Response body: ${response.body}');

  //     var responseBody = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       // // return Food.fromJson(response.body);
  //       // final results =
  //       //     List<Map<String, dynamic>>.from(json.decode(responseBody));

  //       // List<Food> items = results
  //       //     .map((item) => Food.fromMap(item))
  //       //     .toList(growable: false);
  //       // print('${responseBody[0]['food_name']}');
  //       Food items = Food(
  //         id: responseBody[0]['id'],
  //         food_code: responseBody[0]['food_code'],
  //         food_name: responseBody[0]['food_name'],
  //         food_quantity: responseBody[0]['food_quantity'],
  //         food_serving_size: responseBody[0]['food_serving_size'],
  //         energy_kcal_100g: responseBody[0]['energy_kcal_100g'],
  //         carbohydrates_100g: responseBody[0]['carbohydrates_100g'],
  //         proteins_100g: responseBody[0]['proteins_100g'],
  //         sodium_100g: responseBody[0]['sodium_100g'],
  //         calcium_100g: responseBody[0]['calcium_100g'],
  //       );

  //       print(items.food_name);

  //       return items;
  //     } else {
  //       throw CustomException(message: 'Failed to retrieve product detail!');
  //     }
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }
}
