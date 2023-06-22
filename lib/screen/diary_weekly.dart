import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_nutri_track/models/weekly_intake.dart';
import 'package:smart_nutri_track/screen/diary_diabetes.dart';
import 'package:smart_nutri_track/theme.dart';
import '../component/default_button.dart';
import '../component/nutrient_status.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../size_config.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:http/http.dart' as http;

import '../utilities/user_shared_preferences.dart';

class WeeklyDiary extends HookConsumerWidget {
  WeeklyDiary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
                child: FutureBuilder(
                    future: retrieveWeeklySummary(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                            child: CircularProgressIndicator(
                          // backgroundColor: ColourConstant.kWhiteColor,
                          color: ColourConstant.kDarkColor,
                        ));
                      } else {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                              padding: EdgeInsets.all(
                                  getProportionateScreenWidth(30)),
                              child: RefreshIndicator(
                                  onRefresh: () async {},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Nutrients Summary",
                                          style: textTheme().bodyLarge),
                                      Text(
                                        "From ${DateFormat('dd-MMMM-yyyy').format(snapshot.data.from_date)} to ${DateFormat('dd-MMMM-yyyy').format(snapshot.data.sun_date)}",
                                        style: textTheme().bodySmall,
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(20)),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Your weekly dietary score',
                                              style: textTheme().bodyMedium,
                                            ),
                                            Text(
                                              '${double.parse(snapshot.data.score).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          50),
                                                  fontWeight: FontWeight.bold,
                                                  color: ColourConstant
                                                      .kBlueColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Carbohydrates',
                                            style: textTheme().bodyMedium,
                                          ),
                                          Text(
                                              '${snapshot.data.carb_val.toStringAsFixed(2)} %'),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Nutrient_status(
                                        level: snapshot.data.carb_level,
                                        display_calcium: false,
                                        percentage:
                                            snapshot.data.carb_val / 100 >= 1
                                                ? 1
                                                : snapshot.data.carb_val / 100,
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(25)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Protein',
                                            style: textTheme().bodyMedium,
                                          ),
                                          Text(
                                              '${(snapshot.data.protein_val.toStringAsFixed(2))} g'),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Nutrient_status(
                                          level: snapshot.data.protein_level,
                                          display_calcium: false,
                                          percentage:
                                              snapshot.data.protein_val / 62 >=
                                                      1
                                                  ? 1
                                                  : snapshot.data.protein_val /
                                                      62),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(25)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sodium',
                                            style: textTheme().bodyMedium,
                                          ),
                                          Text(
                                              '${snapshot.data.sodium_val.toStringAsFixed(2)} g'),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Nutrient_status(
                                        level: snapshot.data.sodium_level,
                                        display_calcium: false,
                                        percentage:
                                            snapshot.data.sodium_val / 9 >= 1
                                                ? 1
                                                : snapshot.data.sodium_val / 9,
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(25)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Calcium',
                                            style: textTheme().bodyMedium,
                                          ),
                                          Text(
                                              '${snapshot.data.calcium_val.toStringAsFixed(2)} g'),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Nutrient_status(
                                        level: snapshot.data.calcium_level,
                                        display_calcium: true,
                                        percentage:
                                            snapshot.data.calcium_val / 2 >=1
                                                ? 1
                                                : snapshot.data.calcium_val / 2,
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(20)),
                                      DefaultButton(
                                        text: "Check Gestational Diabetes",
                                        press: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DiabetesScreen(
                                                  carbVal: snapshot
                                                      .data.carb_val
                                                      .toStringAsFixed(2),
                                                ),
                                              ));
                                        },
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     color: ColourConstant.kPinkColor
                                      //         .withOpacity(0.9),
                                      //     borderRadius: BorderRadius.all(
                                      //         Radius.circular(30)),
                                      //   ),
                                      //   margin: EdgeInsets.only(top: 20),
                                      //   padding: EdgeInsets.all(30),
                                      //   child: Column(
                                      //     children: [
                                      //       Text(
                                      //         "Your Diabetes Prediction Result",
                                      //         style: textTheme().bodyMedium,
                                      //       ),
                                      //       SizedBox(
                                      //         height:
                                      //             getProportionateScreenHeight(
                                      //                 5),
                                      //       ),
                                      // FutureBuilder(
                                      //     future:
                                      //         retrieveDiabetesPrediction(
                                      //             snapshot.data.sodium_val
                                      //                 .toStringAsFixed(
                                      //                     2)),
                                      //     builder: (context,
                                      //         AsyncSnapshot snapshot) {
                                      //       if (snapshot
                                      //               .connectionState !=
                                      //           ConnectionState.done) {
                                      //         return Center(
                                      //             child:
                                      //                 CircularProgressIndicator(
                                      //           // backgroundColor: ColourConstant.kWhiteColor,
                                      //           color: ColourConstant
                                      //               .kDarkColor,
                                      //         ));
                                      //       } else {
                                      //         if (!snapshot.hasData) {
                                      //           return Center(
                                      //             child: Text(
                                      //               "",
                                      //               style: TextStyle(
                                      //                 fontSize: 14,
                                      //               ),
                                      //             ),
                                      //           );
                                      //         } else {
                                      //           return Center(
                                      //             child: snapshot.data
                                      //                 ? Text(
                                      //                     'Hooray! You are free from gestational diabetes.',
                                      //                     textAlign:
                                      //                         TextAlign
                                      //                             .center,
                                      //                   )
                                      //                 : Text(
                                      //                     'You suspect gestational diabetes! We suggest you have a medical check-up.',
                                      //                     textAlign:
                                      //                         TextAlign
                                      //                             .center,
                                      //                   ),
                                      //           );
                                      //         }
                                      //       }
                                      //     }),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  )));
                        }
                      }
                    })),
          ],
        ),
      ),
    );
  }

  Future<Weekly_summary> retrieveWeeklySummary() async {
    // final int id = _read(authControllerProvider).id!;

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    final String apiRoute = 'get_weekly_summary';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
      );

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        print('test1');
        // final results =
        //     List<Map<String, dynamic>>.from(json.decode(responseBody));

        final results = json.decode(responseBody);

        // Calculate range of week
        final DateTime fromDate = DateTime.parse(results['sun_date'])
            .subtract(const Duration(days: 7));

        Weekly_summary temp = Weekly_summary(
            carb_val: results['carb_val'].toDouble() as double,
            carb_level: results['carb_level'],
            protein_val: results['protein_val'].toDouble() as double,
            protein_level: results['protein_level'],
            sodium_val: results['sodium_val'].toDouble() as double,
            sodium_level: results['sodium_level'],
            calcium_val: results['calcium_val'].toDouble() as double,
            calcium_level: results['calcium_level'],
            score: results['score'],
            sun_date: (DateTime.parse(results['sun_date'])),
            from_date: fromDate);

        return temp;
      } else {
        throw CustomException(message: 'Failed to retrieve weekly summary!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> retrieveDiabetesPrediction(String carb) async {
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    final String apiRoute = 'get_diabetes/$carb';
    var url = Uri.parse(env!.baseUrl + apiRoute);

    print('Requesting to $url');

    try {
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        if (responseBody == '0') {
          return false;
        } else {
          return true;
        }
      } else {
        throw CustomException(
            message: 'Failed to predict gestational diabetes!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
