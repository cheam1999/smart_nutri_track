import 'package:flutter/material.dart';
import 'package:smart_nutri_track/screen/add_food.dart';

import '../constant/colour_constant.dart';
import '../screen/auth/sign_up.dart';
import '../size_config.dart';
import 'normal_text.dart';


class NoFoodFoundText extends StatelessWidget {
  const NoFoodFoundText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: NormalText(
              text: "Food not found? ",
              fontSize: getProportionateScreenWidth(14),
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print('Navigate to add food');
                Navigator.pushNamed(context, AddFoodScreen.routeName);
              },
              child: NormalText(
                text: "Click here to update our records!",
                fontSize: getProportionateScreenWidth(14),
                textColor: ColourConstant.kButtonColor,
                isBold: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
