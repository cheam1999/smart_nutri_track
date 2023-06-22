import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smart_nutri_track/component/nutrient_status.dart';
import 'package:smart_nutri_track/models/daily_summary_model.dart';
import 'package:smart_nutri_track/theme.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../size_config.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:http/http.dart' as http;

import '../utilities/user_shared_preferences.dart';

class DailyDiary extends HookConsumerWidget {
  DailyDiary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Container(
        child: FutureBuilder(
            future: retrieveDailySummary(),
            builder: (context, AsyncSnapshot snapshot) {
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
                    padding: EdgeInsets.all(getProportionateScreenWidth(30)),
                    child: RefreshIndicator(
                        onRefresh: () async {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nutrients", style: textTheme().bodyLarge),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Carbohydrates',
                                  style: textTheme().bodyMedium,
                                ),
                                Text(
                                    '${snapshot.data.carb_val.toStringAsFixed(2)} %'),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Nutrient_status(
                              level: snapshot.data.carb_level,
                              display_calcium: false,
                              percentage: snapshot.data.carb_val / 100 >= 1 ? 1 : snapshot.data.carb_val / 100,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Protein',
                                  style: textTheme().bodyMedium,
                                ),
                                Text(
                                    '${snapshot.data.protein_val.toStringAsFixed(2)} g'),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Nutrient_status(
                              level: snapshot.data.protein_level,
                              display_calcium: false,
                              percentage: snapshot.data.protein_val / 62 >= 1? 1 : snapshot.data.protein_val / 62,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sodium',
                                  style: textTheme().bodyMedium,
                                ),
                                Text(
                                    '${snapshot.data.sodium_val.toStringAsFixed(2)} g'),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Nutrient_status(
                              level: snapshot.data.sodium_level,
                              display_calcium: false,
                              percentage: snapshot.data.sodium_val / 9 >= 1 ? 1 : snapshot.data.sodium_val / 9,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Calcium',
                                  style: textTheme().bodyMedium,
                                ),
                                Text(
                                    '${snapshot.data.calcium_val.toStringAsFixed(2)} g'),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Nutrient_status(
                              level: snapshot.data.calcium_level,
                              display_calcium: true,
                              percentage: snapshot.data.calcium_val / 2  >= 1 ? 1 : snapshot.data.calcium_val / 2,
                            )
                          ],
                        )));
              }
            }));
  }
}

Future<Daily_summary> retrieveDailySummary() async {
  // final int id = _read(authControllerProvider).id!;

  String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

  final String apiRoute = 'get_daily_summary';
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
    print('Response body: ${response.body}');

    var responseBody = response.body;
    if (response.statusCode == 200) {
      print('test1');
      // final results =
      //     List<Map<String, dynamic>>.from(json.decode(responseBody));

      final results = json.decode(responseBody);
       print("temp ${ results['carb_val']}");

      Daily_summary temp = Daily_summary(
          carb_val: results['carb_val'].toDouble() as double,
          carb_level: results['carb_level'],
          protein_val: results['protein_val'].toDouble() as double,
          protein_level: results['protein_level'],
          sodium_val: results['sodium_val'].toDouble() as double,
          sodium_level: results['sodium_level'],
          calcium_val: results['calcium_val'].toDouble() as double,
          calcium_level: results['calcium_level']
          );

      print("temp ${temp}");

      return temp;
    } else {
      throw CustomException(message: 'Failed to retrieve daily summary!');
    }
  } catch (e) {
    return Future.error(e);
  }
}
