import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/component/change_recipe.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/repositories/ur_repository.dart';
import 'package:smart_nutri_track/screen/grocery_list.dart';
import 'package:smart_nutri_track/screen/recipe_detail.dart';
import 'package:smart_nutri_track/theme.dart';

import '../component/default_button.dart';
import '../component/touchable_feedback.dart';

import '../controller/recipe_controller.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import '../size_config.dart';
import 'package:http/http.dart' as http;

class RecipeScreen extends HookConsumerWidget {
  static String routeName = "/recipe";
  const RecipeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        // backgroundColor: ColourConstant.kLightBlueColor,
        appBar: AppBar(
          title: Text(
            "Meal Plan",
            style: TextStyle(
              color: ColourConstant.kDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: ColourConstant.kWhiteColor,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: ColourConstant.kWhiteColor,
              ),
              child: Container(
                  // decoration: BoxDecoration(color: ColourConstant.kWhiteColor,borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20)),),
                  width: double.infinity,
                  child: FutureBuilder(
                      future:
                          ref.watch(recipeControllerProvider).retrieveRecipe(),
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
                                "No data",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Breakfast",
                                        style: TextStyle(
                                          color: ColourConstant.kDarkColor,
                                          fontSize: ColourConstant.h1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(
                                              FontAwesomeIcons.arrowsRotate),
                                          onPressed: () async => await ref
                                              .watch(recipeControllerProvider)
                                              .breakfastButtonClicked())
                                    ],
                                  ),
                                  recipeCard(snapshot.data[0]),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Lunch",
                                        style: TextStyle(
                                          color: ColourConstant.kDarkColor,
                                          fontSize: ColourConstant.h1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(
                                              FontAwesomeIcons.arrowsRotate),
                                          onPressed: () async => await ref
                                              .watch(recipeControllerProvider)
                                              .lunchButtonClicked())
                                    ],
                                  ),
                                  recipeCard(snapshot.data[1]),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Snacks",
                                        style: TextStyle(
                                          color: ColourConstant.kDarkColor,
                                          fontSize: ColourConstant.h1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(
                                              FontAwesomeIcons.arrowsRotate),
                                          onPressed: () async => await ref
                                              .watch(recipeControllerProvider)
                                              .snakcsButtonClicked())
                                    ],
                                  ),
                                  recipeCard(snapshot.data[2]),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dinner",
                                        style: TextStyle(
                                          color: ColourConstant.kDarkColor,
                                          fontSize: ColourConstant.h1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(
                                              FontAwesomeIcons.arrowsRotate),
                                          onPressed: () async => await ref
                                              .watch(recipeControllerProvider)
                                              .dinnerButtonClicked())
                                    ],
                                  ),
                                  recipeCard(snapshot.data[3]),
                                  SizedBox(
                                    height: getProportionateScreenHeight(30),
                                  ),
                                  DefaultButton(
                                      text: "Generate Grocery List",
                                      press: () async {
                                        Navigator.pushNamed(context,
                                            GroceryListScreen.routeName);
                                      }),
                                  SizedBox(
                                    height: getProportionateScreenHeight(30),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      })));
        })));
  }
}

class recipeCard extends HookConsumerWidget {
  const recipeCard(
    this.snapshot, {
    Key? key,
  }) : super(key: key);

  final dynamic snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return Container(
      child: RefreshIndicator(
          onRefresh: () async {},
          child: Column(
            children: [
              TouchableFeedback(
                onTap: () async {
                  // print("Testing");
                  // await ref.read(UrRepositoryProvider).retrieveUrByUserID();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                              // title:
                              //     '${snapshot.data[index].recipeName}',
                              recipe: snapshot,
                            )),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // shadowColor: ColourConstant.kLightBlueColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(10),
                    ),
                    // height: getProportionateScreenHeight(125),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenHeight(100),
                          child: Opacity(
                            opacity: 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/graphics/food.png',
                                  image: '${snapshot.recipe_image}',
                                )),
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: getProportionateScreenHeight(100),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.recipe_name}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
