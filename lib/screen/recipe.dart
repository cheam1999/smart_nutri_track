import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/component/change_recipe.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/controller/recipe/lunch_recipe_controller.dart';
import 'package:smart_nutri_track/controller/recipe_controller.dart';
import 'package:smart_nutri_track/screen/recipe_detail.dart';
import 'package:smart_nutri_track/theme.dart';

import '../component/touchable_feedback.dart';
import '../controller/recipe/breakfast_recipe_controller.dart';
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
    final breakfastRecipeControllerState =
        ref.watch(breakfastRecipeControllerProvider);

    return Scaffold(
        backgroundColor: ColourConstant.kBlueColor,
        appBar: AppBar(
          title: Text(
            " Recipe",
            style: TextStyle(
              color: ColourConstant.kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: FaIcon(FontAwesomeIcons.arrowsRotate),
                          onPressed: () async => await ref
                              .watch(breakfastRecipeControllerProvider)
                              .randomBreakfastRecipe()),
                    ],
                  ),
                  breakfastCard(),
                  SizedBox(height: getProportionateScreenHeight(10),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: FaIcon(FontAwesomeIcons.arrowsRotate),
                          onPressed: () async => await ref
                              .watch(lunchRecipeControllerProvider)
                              .randomLunchRecipe()),
                    ],
                  ),
                  lunchCard(),
                ],
              ));
        })));
  }
}

class breakfastCard extends HookConsumerWidget {
  const breakfastCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        width: double.infinity,
        child: FutureBuilder(
            future: ref
                .watch(breakfastRecipeControllerProvider)
                .randomBreakfastRecipe(),
            builder: (context, AsyncSnapshot snapshot) {
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
                return recipeCard(
                  snapshot,
                );
              }
            }));
  }
}

class lunchCard extends HookConsumerWidget {
  const lunchCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        width: double.infinity,
        child: FutureBuilder(
            future: ref
                .watch(lunchRecipeControllerProvider)
                .randomLunchRecipe(),
            builder: (context, AsyncSnapshot snapshot) {
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
                return recipeCard(
                  snapshot,
                );
              }
            }));
  }
}

class recipeCard extends HookConsumerWidget {
  const recipeCard(this.snapshot, {
    Key? key,
  }) : super(key: key);

  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return Container(
      child: RefreshIndicator(
          onRefresh: () async {},
          child: Column(
            children: [
              TouchableFeedback(
                onTap: () {
                  print("Testing");
                  // Navigator.push(
                  //   // context,
                  //   // MaterialPageRoute(
                  //   //     builder: (context) =>
                  //   //         RecipeDetailPage(
                  //   //           // title:
                  //   //           //     '${snapshot.data[index].recipeName}',
                  //   //           recipe:
                  //   //               snapshot.data[index],
                  //   //         )),
                  // );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                              child: Image.network(
                                '${snapshot.data.recipe_image}',
                              ),
                            ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data.recipe_name}",
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
