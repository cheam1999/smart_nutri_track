import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/screen/init.dart';

import '../../component/default_button.dart';
import '../../component/sign_in_text.dart';
import '../../constant/showLoadingDialog.dart';
import '../../controller/general_controller.dart';
import '../../controller/sign_up_controller.dart';
import '../../size_config.dart';

class SignUpScreen extends HookConsumerWidget {
  static String routeName = "/sign_up";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  SignUpForm(), // Form
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends HookConsumerWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpControllerState = ref.watch(signUpController);
    final signUpObscureTextControllerState =
        ref.watch(signUpObscureTextController);
    return Column(
      children: [
        // name
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Username",
            errorText: signUpControllerState.name.error,
            hintText: "Enter your username",
          ),
          onChanged: (String value) {
            ref.read(signUpController).changename(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        //Email
        TextFormField(
          decoration: InputDecoration(
            labelText: "Email",
            errorText: signUpControllerState.email.error,
            hintText: "Enter email",
          ),
          onChanged: (String value) {
            ref.read(signUpController).changeEmail(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        //Password
        TextFormField(
          obscureText: signUpObscureTextControllerState.isTrue,
          decoration: InputDecoration(
            labelText: "Password",
            errorText: signUpControllerState.password.error,
            hintText: "Enter password",
            suffixIcon: IconButton(
              icon: signUpObscureTextControllerState.switchObsIcon,
              onPressed: () =>
                  ref.read(signUpObscureTextController).toggleObs(),
            ),
          ),
          onChanged: (String value) {
            ref.read(signUpController).changePassword(value);
          },
        ),
        //SizedBox(height: getProportionateScreenHeight(30)),
        //Password
        // TextFormField(
        //   obscureText: signUpObscureTextControllerState.isTrue,
        //   decoration: InputDecoration(
        //     labelText: "Password Confirmation",
        //     errorText: signUpControllerState.passwordConfirmation.error,
        //     hintText: "Confirm password",
        //     suffixIcon: IconButton(
        //       icon: signUpObscureTextControllerState.switchObsIcon,
        //       onPressed: () =>
        //           ref.read(signUpObscureTextController).toggleObs(),
        //     ),
        //   ),
        //   onChanged: (String value) {
        //     ref.read(signUpController).changeConfirmationPassword(value);
        //   },
        // ),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
          text: "Sign Up",
          press: () async {
            showLoadingDialog(context: context);
            bool isSucess = await ref.read(signUpController).submitData();
            Navigator.of(context).pop();
            print(isSucess);
            if (isSucess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, InitScreen.routeName, ModalRoute.withName('/'));
            }
          },
          isPrimary: signUpControllerState.isFilled,
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        SignInText(),
      ],
    );
  }
}
