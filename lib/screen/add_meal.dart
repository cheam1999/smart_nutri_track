import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:smart_nutri_track/controller/food_controller.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/screen/food%20details.dart';
import 'package:smart_nutri_track/theme.dart';

import '../constant/colour_constant.dart';
import '../constant/showLoadingDialog.dart';
import '../controller/auth_controller.dart';
import '../size_config.dart';

import 'package:smart_nutri_track/models/food_model.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddMealScreen extends HookConsumerWidget {
  static String routeName = "/add_meal";
  const AddMealScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    final food = ref.watch(foodControllerProvider).retrieveFood;

    return Scaffold(
      backgroundColor: ColourConstant.kWhiteColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Add Meal",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: ColourConstant.kWhiteColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
          child: RefreshIndicator(
              displacement: 10,
              onRefresh: () async {
                await ref.watch(foodControllerProvider).retrieveFood();
              },
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical(y: 0),
                    controller: searchController,
                    onChanged: (value) {
                      EasyDebounce.debounce(
                          'search',
                          Duration(milliseconds: 500),
                          () => ref
                              .watch(foodControllerProvider)
                              .filterSearchResults(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Search a Food',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: ColourConstant.kDarkColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: ColourConstant.kDarkColor,
                        ),
                      ),
                      suffixIcon:
                          //searchController.text.length == 0
                          GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                            ),
                          ],
                        ),
                        // onTap: () async {
                        //   await ref
                        //       .watch(foodControllerProvider)
                        //       .filterSearchResults(value);
                        // },
                      ),
                      // : GestureDetector(
                      //     child: const Icon(Icons.close),
                      //     onTap: () {
                      //       // ref.refresh(discountControllerProvider(listingType));
                      //       // refresh();
                      //       ref.watch(foodControllerProvider).refresh();
                      //       searchController.text = '';
                      //     },
                      //   ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, BarcodeScanningScreen.routeName),
                        child: Container(
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(10)),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColourConstant.kDarkColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.barcode),
                              Text('Scan a barcode'),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: FutureBuilder(
                        future: //retrieveFood(),
                            ref.watch(foodControllerProvider).getSearchResult(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(
                                child: CircularProgressIndicator(
                              // backgroundColor: ColourConstant.kWhiteColor,
                              color: ColourConstant.kDarkColor,
                            ));
                          } else {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                  "Search a food to show results",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColourConstant.kDarkColor),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                  onRefresh: () async {},
                                  child: Column(children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Search Results',
                                          style: textTheme().bodyMedium,
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(20),
                                        ),
                                        ListView.builder(
                                            itemCount: snapshot.data.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Card(
                                                elevation: 5,
                                                shadowColor:
                                                    ColourConstant.kGreyColor,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.blue.withAlpha(30),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                             FoodDetailScreen(
                                                               food: snapshot
                                                                .data[index],
                                                             )
                                                        ));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10.0,
                                                            10.0,
                                                            10.0,
                                                            10),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)),
                                                    ),
                                                    child: Text(
                                                      '${snapshot.data[index].food_name}',
                                                      style:
                                                          textTheme().bodySmall,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ]));
                            }
                          }
                        }),
                  ),
                ],
              )),
        )),
      ),
    );
  }

  Future<List<Food>> retrieveFood() async {
    // final int id = _read(authControllerProvider).id!;
    // String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;
    final String apiRoute = 'get_all_food';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      print('Response status 2: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        final results =
            List<Map<String, dynamic>>.from(json.decode(responseBody));
        print('enter1 ${results.length}');

        List<Food> items = List.filled(results.length, Food());

        for (var i = 0; i < results.length; i++) {
          Food temp = Food(
              id: results[i]['id'],
              food_code: results[i]['food_code'],
              food_name: results[i]['food_name'],
              food_quantity: results[i]['food_quantity'],
              food_serving_size: results[i]['food_serving_size'],
              energy_kcal_100g: results[i]['energy_kcal_100g'],
              carbohydrates_100g: '${results[i]['carbohydrates_100g']}',
              proteins_100g: '${results[i]['proteins_100g']}',
              sodium_100g: '${results[i]['sodium_100g']}',
              calcium_100g: '${results[i]['calcium_100g']}');

          items[i] = temp;
        }
        // List<Food> items =
        //     results.map((item) => Food.fromMap(item)).toList(growable: false);
        // // print(items[0]);
        // print('enter2 ${items}');
        return items;
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
