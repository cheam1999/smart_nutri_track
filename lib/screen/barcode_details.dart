import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/controller/barcode_products_controller.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../component/default_button.dart';
import '../constant/colour_constant.dart';
import '../controller/camera_view.dart';
import '../controller/painters/barcode_detector_painter.dart';
import '../models/barcode_products_model.dart';
import '../models/custom_exception.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class BarcodeDetailScreen extends HookConsumerWidget {
  static String routeName = "/barcodeDetails";

  BarcodeDetailScreen({
    Key? key,
    this.code,
  }) : super(key: key);

  final String? code;

  // @override
  // State<BarcodeScanningScreen> createState() => _BarcodeScanningScreen();

  // @override
  // State<BarcodeScanningScreen> createState() => _BarcodeScanningState();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var today = DateTime.now();

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
            child: FutureBuilder(
                future: retrieveBarcodeProducts(code!),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "Sorry, the product does not exist in our database.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                        child: RefreshIndicator(
                            onRefresh: () async {},
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(snapshot.data[index].recipeIngredients);
                                  // print(ingredientList);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    20)),
                                        Text(
                                          snapshot.data.food_name,
                                          style: TextStyle(
                                            fontSize: ColourConstant.h1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: ColourConstant.kDarkColor,
                                          thickness: 0.5,
                                          height:
                                              getProportionateScreenHeight(30),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      150),
                                              child: Text(
                                                'Date',
                                                style: TextStyle(
                                                  fontSize: ColourConstant.h4,
                                                  color:
                                                      ColourConstant.kDarkColor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${today.toString().substring(0, 10)}",
                                              style: TextStyle(
                                                fontSize: ColourConstant.h4,
                                                color:
                                                    ColourConstant.kBlueColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10)),
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      150),
                                              child: Text(
                                                'Meal',
                                                style: TextStyle(
                                                  fontSize: ColourConstant.h4,
                                                  color:
                                                      ColourConstant.kDarkColor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Lunch",
                                              style: TextStyle(
                                                fontSize: ColourConstant.h4,
                                                color:
                                                    ColourConstant.kBlueColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10)),
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      150),
                                              child: Text(
                                                'Serving Size',
                                                style: TextStyle(
                                                  fontSize: ColourConstant.h4,
                                                  color:
                                                      ColourConstant.kDarkColor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${snapshot.data.food_serving_size}",
                                              style: TextStyle(
                                                fontSize: ColourConstant.h4,
                                                color:
                                                    ColourConstant.kBlueColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          color: ColourConstant.kDarkColor,
                                          thickness: 0.5,
                                          height:
                                              getProportionateScreenHeight(30),
                                        ),
                                        Text(
                                          'Nutrition',
                                          style: TextStyle(
                                              fontSize: ColourConstant.h3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    20)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Carbohydrates'),
                                            Text(
                                              '${snapshot.data.carbohydrates_100g} g',
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Protein'),
                                            Text(
                                              '${snapshot.data.proteins_100g} g',
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Sodium'),
                                            Text(
                                              '${snapshot.data.sodium_100g} g',
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Calcium'),
                                            Text(
                                              '${snapshot.data.calcium_100g} g',
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    30)),
                                        DefaultButton(
                                          text: "Add meal",
                                          press: () =>
                                              Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            InitScreen.routeName,
                                            ModalRoute.withName('/'),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    20)),
                                        DefaultButton(
                                          text: "Not Now",
                                          press: () =>
                                              Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            InitScreen.routeName,
                                            ModalRoute.withName('/'),
                                          ),
                                          isPrimary: false,
                                        ),
                                      ],
                                    ),
                                  );
                                })));
                  }
                })));
  }

  @override
  Future<Barcode_products> retrieveBarcodeProducts(String code) async {
    // final int id = _read(authControllerProvider).id!;
    // String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'get_barcode_products/$code';
    var url = Uri.parse(env!.baseUrl + apiRoute);
    Barcode_products result = Barcode_products();

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // 'Authorization': 'Bearer $_accesToken',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        // // return Barcode_products.fromJson(response.body);
        // final results =
        //     List<Map<String, dynamic>>.from(json.decode(responseBody));

        // List<Barcode_products> items = results
        //     .map((item) => Barcode_products.fromMap(item))
        //     .toList(growable: false);

        Barcode_products items = Barcode_products(
          food_code: responseBody['food_code'],
          food_name: responseBody['food_name'],
          food_quantity: responseBody['food_quantity'],
          food_serving_size: responseBody['food_serving_size'],
          energy_kcal_100g: responseBody['energy_kcal_100g'],
          carbohydrates_100g: responseBody['carbohydrates_100g'],
          proteins_100g: responseBody['proteins_100g'],
          sodium_100g: responseBody['sodium_100g'],
          calcium_100g: responseBody['calcium_100g'],
        );

        return items;
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
