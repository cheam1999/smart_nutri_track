import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/controller/meal_controller.dart';
import 'package:smart_nutri_track/controller/update_profile_controller.dart';
import 'package:smart_nutri_track/models/weekly_intake.dart';
import 'package:smart_nutri_track/screen/add_meal.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/screen/edit_profile.dart';
import 'package:smart_nutri_track/screen/profile.dart';
import 'package:smart_nutri_track/size_config.dart';
import 'package:smart_nutri_track/theme.dart';
import 'package:smart_nutri_track/utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../component/normal_text.dart';
import '../constant/showLoadingDialog.dart';
import '../controller/auth_controller.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../models/food_intakes.dart';
import 'auth/sign_in.dart';

class HomeScreen extends HookConsumerWidget {
  static String routeName = "/home";
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ColourConstant.kLightBlueColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(
        //   " Home",
        //   style: TextStyle(
        //     color: ColourConstant.kWhiteColor,
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        foregroundColor: ColourConstant.kDarkColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            // color: ColourConstant.kGreyColor,
            onPressed: () {
              print('${authControllerState.name}');
              showLogoutDialog(
                context: context,
                confirmEvent: () {
                  ref.read(authControllerProvider.notifier).signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,
                    ModalRoute.withName('/'),
                  );
                },
              );
            },
          ),
        ],
        // leading: IconButton(
        //     // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
        //     icon: FaIcon(
        //       FontAwesomeIcons.solidCircleUser,
        //       color: ColourConstant.kDarkColor,
        //     ),
        //     onPressed: () async {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => ProfileScreen()),
        //       );
        //     }),
        backgroundColor: ColourConstant.kLightBlueColor,
        elevation: 0,
      ),
      body: Container(
        //  decoration: BoxDecoration(gradient: ColourConstant.kBackgroundColor),
        //  height: double.infinity,
        child: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return RefreshIndicator(
            displacement: 10,
            onRefresh: () async {
              // await ref
              //     .read(authControllerProvider.notifier)
              //     .getFoodSavedAndWaste();
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                child: FutureBuilder(
                    future: retrieveMeals(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
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
                          return SingleChildScrollView(
                              child: RefreshIndicator(
                                  onRefresh: () async {},
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Container(
                                        // color: ColourConstant.kWhiteColor,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 50.0,
                                              backgroundColor:
                                                  ColourConstant.kWhiteColor,
                                              child: ClipOval(
                                                child: Image.network(
                                                  'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/7th.jpg',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      20),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Welcome ${authControllerState.name}!',
                                                  style: TextStyle(
                                                    fontSize: ColourConstant.h1,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          10),
                                                ),
                                                Text(
                                                  '${authControllerState.email}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          ColourConstant.h3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColourConstant
                                                          .kDarkColor),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                                icon: FaIcon(
                                                    FontAwesomeIcons.pen),
                                                onPressed: () async => {
                                                      await ref
                                                          .watch(
                                                              updateProfileController)
                                                          .getUser(),
                                                      Navigator.pushNamed(
                                                          context,
                                                          EditProfileScreen
                                                              .routeName)
                                                    })
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: ColourConstant.kWhiteColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                          margin: EdgeInsets.only(top: 20),
                                          padding: EdgeInsets.all(30),
                                          child: //Text('data')
                                              Column(
                                            children: [
                                              Text(
                                                "Your meal today",
                                                style: TextStyle(
                                                  fontSize: ColourConstant.h1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        30),
                                              ),
                                              BuildingList(list: snapshot.data),
                                            ],
                                          )),
                                    ],
                                  )));
                        }
                      }
                    })),
          );
        })),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Meal",
        backgroundColor: ColourConstant.kButtonColor,
        elevation: 5.0,
        onPressed: () async {
          Navigator.pushNamed(
            context,
            AddMealScreen.routeName,
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

  Future<List<Food_intakes>> retrieveMeals() async {
    // final int id = _read(authControllerProvider).id!;
    print('entering');

    String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

    final String apiRoute = 'get_current_meals';
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
        final results =
            List<Map<String, dynamic>>.from(json.decode(responseBody));

        List<Food_intakes> items = results
            .map((item) => Food_intakes.fromMap(item))
            .toList(growable: false);

        return items;
      } else {
        throw CustomException(message: 'Failed to retrieve product detail!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

class BuildingList extends StatelessWidget {
  const BuildingList({Key? key, required this.list}) : super(key: key);

  final List<Food_intakes> list;

  @override
  Widget build(BuildContext context) {
    List<Food_intakes> breakfast =
        list.where((i) => i.meal == 'BREAKFAST').toList();
    List<Food_intakes> lunch = list.where((i) => i.meal == 'LUNCH').toList();
    List<Food_intakes> dinner = list.where((i) => i.meal == 'DINNER').toList();
    List<Food_intakes> snacks = list.where((i) => i.meal == 'SNACKS').toList();
    // List<Food_intakes> supper = list.where((i) => i.meal == 'SUPPER').toList();

    return Column(
      children: [
        Text(
          'Breakfast',
          style: textTheme().bodyLarge,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: breakfast.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                  fName: breakfast[index].food_name!,
                  size: breakfast[index].intake_serving_size!);
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Text(
          'Lunch',
          style: textTheme().bodyLarge,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: lunch.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                  fName: lunch[index].food_name!,
                  size: lunch[index].intake_serving_size!);
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Text(
          'Dinner',
          style: textTheme().bodyLarge,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: dinner.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                  fName: dinner[index].food_name!,
                  size: dinner[index].intake_serving_size!);
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Text(
          'Snacks',
          style: textTheme().bodyLarge,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: snacks.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                  fName: snacks[index].food_name!,
                  size: snacks[index].intake_serving_size!);
            }),
      ],
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({Key? key, required this.fName, required this.size})
      : super(key: key);

  final String fName;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fName,
            style: TextStyle(
                fontSize: ColourConstant.h4,
                color: ColourConstant.kDarkColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "$size g/ml",
            style: TextStyle(
                fontSize: ColourConstant.h5, color: ColourConstant.kDarkColor),
          ),
        ],
      ),
    );
  }
}
