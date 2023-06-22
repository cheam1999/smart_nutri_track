import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Nutrient.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constant/colour_constant.dart';
import '../size_config.dart';

class Nutrient_status extends StatelessWidget {
  Nutrient_status({
    Key? key,
    required this.level,
    required this.display_calcium,
    required this.percentage,
  }) : super(key: key);

  final String level;
  final bool display_calcium;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (!display_calcium) {
      if (level == '0') {
        // deficiency
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: percentage,
              progressColor: Colors.yellow,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            buildText(true, false,false),
          ],
        );
      } else if (level == '1') {
        // sufficiency
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: percentage,
              progressColor: Colors.green,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            buildText(false,true,false),
          ],
        );
      } else {
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: percentage,
              progressColor: Colors.red,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            buildText(false,false,true),
          ],
        );
      }
    } else {
      if (level == '0') {
        // deficiency
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: percentage,
              progressColor: Colors.yellow,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deficiency',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    fontWeight: FontWeight.bold,
                    color: ColourConstant.kDarkColor,
                  ),
                ),
                Text(
                  'Sufficiency',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    color: ColourConstant.kGreyColor,
                    
                  ),
                ),
              ],
            )
          ],
        );
      } else {
        // sufficiency
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: percentage,
              progressColor: Colors.green,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deficiency',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    color: ColourConstant.kGreyColor,
                  ),
                ),
                Text(
                  'Sufficiency',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    color: ColourConstant.kDarkColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        );
      }
    }
  }

  Widget buildText(bool def,bool suf, bool over) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'Deficiency',
        style: TextStyle(
          fontSize: ColourConstant.h6,
          fontWeight: def ? FontWeight.bold:FontWeight.normal,
          color: def ? ColourConstant.kDarkColor : ColourConstant.kGreyColor,
        ),
      ),
      Text(
        'Sufficiency',
        style: TextStyle(
          fontSize: ColourConstant.h6,
          fontWeight: suf ? FontWeight.bold:FontWeight.normal,
          color: suf ? ColourConstant.kDarkColor : ColourConstant.kGreyColor,
        ),
      ),
      Text(
        'Overnutrition',
        style: TextStyle(
          fontSize: ColourConstant.h6,
          fontWeight: over ? FontWeight.bold:FontWeight.normal,
          color: over ? ColourConstant.kDarkColor : ColourConstant.kGreyColor,
        ),
      ),
    ]);
  }
}
