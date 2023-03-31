import 'package:flutter/material.dart';

import '../constant/colour_constant.dart';
import '../screen/auth/sign_in.dart';
import '../size_config.dart';


class SignInText extends StatelessWidget {
  const SignInText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Have an account? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(14)),
        ),
        GestureDetector(
          onTap: () {
            print('Navigate to sign in');
            Navigator.pushNamed(context, SignInScreen.routeName);
          },
          child: Text(
            "Click here to sign in!",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              color: ColourConstant.kButtonColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
