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
  }) : super(key: key);

  final String level;
  final bool display_calcium;
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
              percent: 0.2,
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
                Text(
                  'Overnutrition',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    color: ColourConstant.kGreyColor,
                  ),
                ),
              ],
            )
          ],
        );
      } else if (level == '1') {
        // sufficiency
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: 0.6,
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
                  ),
                ),
                Text(
                  'Overnutrition',
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
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: 0.8,
              progressColor: Colors.red,
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
                    color: ColourConstant.kGreyColor,
                  ),
                ),
                Text(
                  'Overnutrition',
                  style: TextStyle(
                    fontSize: ColourConstant.h6,
                    color: ColourConstant.kDarkColor,
                  ),
                ),
              ],
            )
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
              percent: 0.4,
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
              percent: 0.6,
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
                  ),
                ),
              ],
            )
          ],
        );
      }
    }
  }
}
