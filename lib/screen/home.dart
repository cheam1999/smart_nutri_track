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
import 'package:smart_nutri_track/repositories/meal_repository.dart';
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
import 'init.dart';

class HomeScreen extends HookConsumerWidget {
  static String routeName = "/home";
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ColourConstant.kWhiteColor,
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
        backgroundColor: ColourConstant.kWhiteColor,
        elevation: 0,
      ),
      body: Container(
        //  decoration: BoxDecoration(color: ColourConstant.kWhiteColor),
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
                    future: ref.watch(MealRepositoryProvider).retrieveMeals(),
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
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: ColourConstant.h1,
                                                    fontWeight: FontWeight.bold,
                                                    // color: ColourConstant.kBlueColor
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
                                                          .kBlueColor),
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
                                            color: ColourConstant.kWhiteColor
                                                .withOpacity(0.9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                                spreadRadius: 2,
                                                blurRadius: 4,
                                                offset: Offset(0,
                                                    2), // changes the shadow position
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
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
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(30),
                                      ),
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
        backgroundColor: ColourConstant.kBlueColor,
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMealScreen(
                  foodName: "",
                ),
              ));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: ColourConstant.kWhiteColor,
              child: ClipOval(
                child: Image.network(
                  'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/breakfast.png',
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(5),
            ),
            Text(
              'Breakfast',
              style: textTheme().bodyLarge,
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: breakfast.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                fName: breakfast[index].food_name!,
                size: breakfast[index].intake_serving_size!,
                food_intake_id: breakfast[index].id!,
              );
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: ColourConstant.kWhiteColor,
              child: ClipOval(
                child: Image.network(
                  'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/lunch.png',
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(5),
            ),
            Text(
              'Lunch',
              style: textTheme().bodyLarge,
            ),
          ],
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
                  size: lunch[index].intake_serving_size!,
                  food_intake_id: lunch[index].id!);
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: ColourConstant.kWhiteColor,
              child: ClipOval(
                child: Image.network(
                  'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/tea.png',
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(5),
            ),
            Text(
              'Snacks',
              style: textTheme().bodyLarge,
            ),
          ],
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
                  size: snacks[index].intake_serving_size!,
                  food_intake_id: snacks[index].id!);
            }),
        Divider(
          height: getProportionateScreenHeight(20),
          thickness: 0.5,
          color: ColourConstant.kDarkColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: ColourConstant.kWhiteColor,
              child: ClipOval(
                child: Image.network(
                  'https://snt-recipe-image.s3.ap-southeast-1.amazonaws.com/dinner.png',
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(5),
            ),
            Text(
              'Dinner',
              style: textTheme().bodyLarge,
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ListView.builder(
            itemCount: dinner.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return MealCard(
                  fName: dinner[index].food_name!,
                  size: dinner[index].intake_serving_size!,
                  food_intake_id: dinner[index].id!);
            }),
      ],
    );
  }
}

class MealCard extends HookConsumerWidget {
  const MealCard(
      {Key? key,
      required this.fName,
      required this.size,
      required this.food_intake_id})
      : super(key: key);

  final String fName;
  final int size;
  final int food_intake_id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool deleteSuccess;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getProportionateScreenWidth(150),
                child: Text(
                  fName,
                  style: TextStyle(
                      fontSize: ColourConstant.h4,
                      color: ColourConstant.kDarkColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "$size g/ml/unit",
                style: TextStyle(
                    fontSize: ColourConstant.h5,
                    color: ColourConstant.kDarkColor),
              ),
            ],
          ),
          IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(
                FontAwesomeIcons.trash,
                size: 16,
              ),
              onPressed: () async => {
                    showDeleteDialog(
                      context: context,
                      confirmEvent: () async {
                        deleteSuccess = await ref
                            .watch(MealRepositoryProvider)
                            .deleteMeals(food_intake_id);

                        if (deleteSuccess == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('Delete failed.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Delete the food intake successully!')));
                        };
                        // await ref.watch(updateProfileController).getUser(),
                        Navigator.pushNamedAndRemoveUntil(context,
                            InitScreen.routeName, ModalRoute.withName('/'));
                      },
                    ),
                  })
        ],
      ),
    );
  }
}
