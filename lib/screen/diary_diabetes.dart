import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_nutri_track/repositories/ingredients_repository.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../constant/colour_constant.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../theme.dart';
import '../utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;

class DiabetesScreen extends HookConsumerWidget {
  static String routeName = "/diabetes";
  final String? carbVal;

  const DiabetesScreen({Key? key, this.carbVal}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: ColourConstant.kWhiteColor,
        appBar: AppBar(
          foregroundColor: ColourConstant.kDarkColor,
          backgroundColor: ColourConstant.kWhiteColor,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Expanded(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30),
                child: Container(
                    decoration: BoxDecoration(
                      // gradient: ColourConstant.kPrimaryGradientColor,
                      color: ColourConstant.kWhiteColor,
                      border: Border.all(
                        color: ColourConstant.kBlueColor,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: FutureBuilder(
                        future: retrieveDiabetesPrediction(),
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
                                  "No data",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                padding:
                                    EdgeInsets.fromLTRB(30.0, 30.0, 20.0, 0),
                                child: Column(
                                  children: [
                                    // SizedBox(
                                    //   height: getProportionateScreenHeight(15),
                                    // ),
                                    Text(
                                      "Gestational Diabetes ",
                                      style: TextStyle(
                                        color: ColourConstant.kDarkColor,
                                        fontSize: ColourConstant.h1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: ColourConstant.kWhiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColourConstant.kDarkColor
                                                .withOpacity(0.6),
                                            // spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0,
                                                2), // changes the shadow position
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          snapshot.data
                                              ? CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor:
                                                      ColourConstant
                                                          .kWhiteColor,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/confetti.png',
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor:
                                                      ColourConstant
                                                          .kWhiteColor,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/exclamation.png',
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          Text(
                                            "Based on your weekly carbohydrate intake, ",
                                            style: TextStyle(
                                              color: ColourConstant.kDarkColor
                                                  .withOpacity(0.9),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(5),
                                          ),
                                          snapshot.data
                                              ? Text(
                                                  'You are free from it!',
                                                  style: TextStyle(
                                                      color: ColourConstant
                                                          .kDarkColor,
                                                      fontSize:
                                                          ColourConstant.h4,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'You might be diagnosed!',
                                                      style: TextStyle(
                                                          color: ColourConstant
                                                              .kDarkColor,
                                                          fontSize:
                                                              ColourConstant.h4,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '\nWe suggest you to go for a medical check-up!',
                                                          style: TextStyle(
                                                            color:
                                                                ColourConstant
                                                                    .kGreyColor,
                                                            fontSize:
                                                                ColourConstant
                                                                    .h6,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                    ),
                                    Card(
                                        elevation: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor:
                                                    ColourConstant.kWhiteColor,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/question+mark.png',
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                'What is it?',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '\nGestational diabetes is a type diabetes diagnosed during pregnancy for the first time.',
                                                style: TextStyle(
                                                  color: ColourConstant
                                                      .kDarkColor
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                    ),
                                    Card(
                                        elevation: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor:
                                                    ColourConstant.kWhiteColor,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/alert.png',
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                'Any warning signs?',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '\nThere are usually no warning signs of gestational diabetes. Symptoms are mild and often go unnoticed until you’re tested for diabetes in the second trimester of pregnancy.',
                                                style: TextStyle(
                                                  color: ColourConstant
                                                      .kDarkColor
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            }
                          }
                        }))),
          );
        })));
  }

  @override
  Future<bool> retrieveDiabetesPrediction() async {
    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    final String apiRoute = 'get_diabetes/$carbVal';
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
