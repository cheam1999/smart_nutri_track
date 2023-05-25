import 'package:flutter/material.dart';

import '../constant/colour_constant.dart';
import '../screen/auth/sign_up.dart';
import '../size_config.dart';
import 'normal_text.dart';


class ChangeRecipeText extends StatelessWidget {
  const ChangeRecipeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: NormalText(
              text: "Don't like this? ",
              fontSize: getProportionateScreenWidth(14),
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print('change recommendation');
                // Navigator.pushNamed(context, SignUpScreen.routeName);
              },
              child: NormalText(
                text: "Click here to change recommendation",
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
