import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/controller/meal_controller.dart';
import 'package:smart_nutri_track/models/weekly_intake.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/size_config.dart';
import 'package:smart_nutri_track/theme.dart';
import 'package:smart_nutri_track/utilities/user_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../component/normal_text.dart';
import '../env.dart';
import '../models/custom_exception.dart';
import '../models/food_intakes.dart';
import '../models/recipe_model.dart';

class RecipeDetailPage extends HookConsumerWidget {
  static String routeName = "/recipe_detail";
  // final String title;
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: ColourConstant.kWhiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          foregroundColor: ColourConstant.kDarkColor,
          title: Text(
            "Recipe Details",
            style: TextStyle(
              color: ColourConstant.kDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: ColourConstant.kWhiteColor,
          elevation: 0,
        ),
        body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              Container(
                child: Expanded(
                    child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          getProportionateScreenWidth(20),
                          getProportionateScreenHeight(10),
                          getProportionateScreenWidth(20),
                          getProportionateScreenHeight(20),
                        ),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: NormalText(
                                      text: "${recipe.recipe_name}",
                                      textColor: Colors.black,
                                      fontSize: 20,
                                      align: TextAlign.center,
                                      isBold: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  '${recipe.recipe_image}',
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Ingredients',
                                style: textTheme().bodyLarge,
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(5),
                              ),
                              NormalText(text: "${recipe.recipe_ingredients}"),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              Text(
                                'Instructions',
                                style: textTheme().bodyLarge,
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(5),
                              ),
                              NormalText(text: "${recipe.recipe_instructions}"),
                               SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                                'Recipe Source',
                                style: textTheme().bodyLarge,
                              ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _launchUrl(recipe.recipe_source.toString());
                              },
                              child: Text(
                                '${recipe.recipe_source}',
                                style: TextStyle(
                                  color: ColourConstant.kDarkColor,
                                  decoration: TextDecoration.underline,
                                  
                                ),
                              ),
                            ),
                            ]),
                      )
                    ],
                  ),
                )),
              )
            ],
          );
        })));
  }

//   Future<List<Food_intakes>> retrieveMeals() async {
//     // final int id = _read(authControllerProvider).id!;
//     print('entering');

//     String? _accesToken = await UserSharedPreferences.getAccessToken() ?? null;

//     final String apiRoute = 'get_current_meals';
//     var url = Uri.parse(env!.baseUrl + apiRoute);

//     print('Requesting to $url');

//     try {
//       var response = await http.get(
//         url,
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $_accesToken',
//         },
//       );

//       print('Response status: ${response.statusCode}');
//       // print('Response body: ${response.body}');

//       var responseBody = response.body;
//       if (response.statusCode == 200) {
//         final results =
//             List<Map<String, dynamic>>.from(json.decode(responseBody));

//         List<Food_intakes> items = results
//             .map((item) => Food_intakes.fromMap(item))
//             .toList(growable: false);

//         return items;
//       } else {
//         throw CustomException(message: 'Failed to retrieve product detail!');
//       }
//     } catch (e) {
//       return Future.error(e);
//     }
//   }
// }

Future<void> _launchUrl(String string) async  {
  final Uri _url = Uri.parse(string);

   if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }

}
}

// class BuildingList extends StatelessWidget {
//   const BuildingList({Key? key, required this.list}) : super(key: key);

//   final List<Food_intakes> list;

//   @override
//   Widget build(BuildContext context) {
//     List<Food_intakes> breakfast =
//         list.where((i) => i.meal == 'BREAKFAST').toList();
//     List<Food_intakes> lunch = list.where((i) => i.meal == 'LUNCH').toList();
//     List<Food_intakes> dinner = list.where((i) => i.meal == 'DINNER').toList();
//     List<Food_intakes> snacks = list.where((i) => i.meal == 'SNACKS').toList();
//     // List<Food_intakes> supper = list.where((i) => i.meal == 'SUPPER').toList();

//     return Column(
//       children: [
//         Text(
//           'Breakfast',
//           style: textTheme().bodyLarge,
//         ),
//         SizedBox(
//           height: getProportionateScreenHeight(20),
//         ),
//         ListView.builder(
//             itemCount: breakfast.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               return MealCard(
//                   fName: breakfast[index].food_name!,
//                   size: breakfast[index].intake_serving_size!);
//             }),
//         Divider(
//           height: getProportionateScreenHeight(20),
//           thickness: 0.5,
//           color: ColourConstant.kDarkColor,
//         ),
//         Text(
//           'Lunch',
//           style: textTheme().bodyLarge,
//         ),
//         SizedBox(
//           height: getProportionateScreenHeight(20),
//         ),
//         ListView.builder(
//             itemCount: lunch.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               return MealCard(
//                   fName: lunch[index].food_name!,
//                   size: lunch[index].intake_serving_size!);
//             }),
//         Divider(
//           height: getProportionateScreenHeight(20),
//           thickness: 0.5,
//           color: ColourConstant.kDarkColor,
//         ),
//         Text(
//           'Dinner',
//           style: textTheme().bodyLarge,
//         ),
//         SizedBox(
//           height: getProportionateScreenHeight(20),
//         ),
//         ListView.builder(
//             itemCount: dinner.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               return MealCard(
//                   fName: dinner[index].food_name!,
//                   size: dinner[index].intake_serving_size!);
//             }),
//         Divider(
//           height: getProportionateScreenHeight(20),
//           thickness: 0.5,
//           color: ColourConstant.kDarkColor,
//         ),
//         Text(
//           'Snacks',
//           style: textTheme().bodyLarge,
//         ),
//         SizedBox(
//           height: getProportionateScreenHeight(20),
//         ),
//         ListView.builder(
//             itemCount: snacks.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               return MealCard(
//                   fName: snacks[index].food_name!,
//                   size: snacks[index].intake_serving_size!);
//             }),
//       ],
//     );
//   }
// }

// class MealCard extends StatelessWidget {
//   const MealCard({Key? key, required this.fName, required this.size})
//       : super(key: key);

//   final String fName;
//   final int size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             fName,
//             style: TextStyle(
//                 fontSize: ColourConstant.h4,
//                 color: ColourConstant.kDarkColor,
//                 fontWeight: FontWeight.bold),
//           ),
//           Text(
//             "$size g/ml",
//             style: TextStyle(
//                 fontSize: ColourConstant.h5, color: ColourConstant.kDarkColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
