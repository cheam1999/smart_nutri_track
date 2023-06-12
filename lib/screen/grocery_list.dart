import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_nutri_track/repositories/ingredients_repository.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../constant/colour_constant.dart';
import '../theme.dart';

class GroceryListScreen extends HookConsumerWidget {
  static String routeName = "/grocery_list";
  const GroceryListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: ColourConstant.kLightBlueColor,
        appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(
              color: ColourConstant.kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraint) {
          return Expanded(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20),
                child: Container(
                    decoration: BoxDecoration(
                      color: ColourConstant.kWhiteColor,
                      borderRadius: BorderRadius.all(
                           Radius.circular(20)),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: FutureBuilder(
                        future: ref
                            .watch(ingredientsRepositoryProvider)
                            .generateGroceryList(),
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
                              return Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    Text("Your Grocery List ",
                                        style: textTheme().bodyLarge),
                                    Text(
                                      "For ${DateFormat('dd-MMMM-yyyy').format(DateTime.now())}",
                                      style: textTheme().bodySmall,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          primary: false,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return Row(
                                              children: [
                                                CheckboxExample(),
                                                Text(snapshot.data[index].amount),
                                                Text(" ${snapshot.data[index].measure_name} of "),
                                                Text(snapshot.data[index]
                                                    .ingredients_name),
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }))),
          );
        })));
  }
}

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return ColourConstant.kBlueColor;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
