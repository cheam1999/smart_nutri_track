import 'package:flutter/material.dart';

import '../constant/colour_constant.dart';
import '../screen/auth/sign_up.dart';
import '../size_config.dart';
import 'normal_text.dart';


class NoAccountText extends StatelessWidget {
  const NoAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: NormalText(
              text: "No account? ",
              fontSize: getProportionateScreenWidth(14),
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                print('Navigate to sign up');
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
              child: NormalText(
                text: "Sign up now!",
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
