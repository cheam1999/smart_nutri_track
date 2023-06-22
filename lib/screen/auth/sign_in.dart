import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/screen/init.dart';

import '../../component/default_button.dart';
import '../../component/no_account_text.dart';
import '../../constant/showLoadingDialog.dart';
import '../../controller/auth_controller.dart';
import '../../controller/general_controller.dart';
import '../../controller/sign_in_controller.dart';
import '../../size_config.dart';
import '../home.dart';

class SignInScreen extends HookConsumerWidget {
  static String routeName = "/sign_in";
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   titleTextStyle: TextStyle(
      //     // color: Colors.white,
      //     fontSize: 20,
      //     // fontWeight: FontWeight.bold,
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(80)),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      SignInForm(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      NoAccountText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends HookConsumerWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInControllerState = ref.watch(signInController);
    final signInObscureTextControllerState =
        ref.watch(signInObscureTextController);

    return Column(
      children: [
        buildLoginInfoTextFormField(signInControllerState, ref),
        SizedBox(height: getProportionateScreenHeight(30)),
        buildPasswordTextFormField(
            signInObscureTextControllerState, signInControllerState, ref),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
          text: "Sign In",
          press: () async {
            showLoadingDialog(context: context);
            bool isSucess = await ref.read(signInController).submitData();
            Navigator.of(context).pop();
            print(isSucess);
            if (isSucess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, InitScreen.routeName, ModalRoute.withName('/'));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Invalid login details!"),
                ),
              );
            }
          },
          isPrimary: signInControllerState.isFilled,
        ),
        SizedBox(height: getProportionateScreenHeight(15)),
      ],
    );
  }

  TextFormField buildLoginInfoTextFormField(
      SignInController signInControllerState, WidgetRef ref) {
    return TextFormField(
      // autofocus: true,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: signInControllerState.loginInfo.error,
        hintText: "Enter email",
      ),
      onChanged: (String value) {
        ref.read(signInController).changeloginInfo(value);
      },
    );
  }

  TextFormField buildPasswordTextFormField(
      SignInObscureTextController signInObscureTextControllerState,
      SignInController signInControllerState,
      WidgetRef ref) {
    return TextFormField(
      obscureText: signInObscureTextControllerState.isTrue,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: signInControllerState.password.error,
        hintText: "Enter password",
        suffixIcon: IconButton(
          icon: signInObscureTextControllerState.switchObsIcon,
          onPressed: () => ref.read(signInObscureTextController).toggleObs(),
        ),
      ),
      onChanged: (String value) {
        ref.read(signInController).changePassword(value);
      },
    );
  }
}
