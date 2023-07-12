import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/screen/home.dart';
import 'package:smart_nutri_track/theme.dart';
import 'package:smart_nutri_track/screen/init.dart';
import '../../size_config.dart';
import '../component/default_button.dart';
import '../controller/auth_controller.dart';
import '../controller/update_profile_controller.dart';

class EditProfileScreen extends HookConsumerWidget {
  static String routeName = "/edit_profile";

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
        ),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     //gradient: UgekColors.kPrimaryGradientColor,
        //   ),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // height: double.infinity,
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                ProfileDetail()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDetail extends HookConsumerWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authControllerState = ref.watch(authControllerProvider);
    // final initUpdate = ref.watch(updateProfileController).getUser();
    final updateProfileControllerState = ref.watch(updateProfileController);
    final snackBar = SnackBar(content: Text('Nothing to update'));

    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        Text(
          'Name',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: ColourConstant.kBlueColor),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        TextFormField(
          //autofocus: true,
          style: TextStyle(
            color: ref.watch(updateProfileController).name.value == null
                ? ColourConstant.kGreyColor
                : ColourConstant.kDarkColor,
          ),
          initialValue: updateProfileControllerState.getInitialName,
          decoration: InputDecoration(
            errorText: updateProfileControllerState.name.error,
          ),
          onChanged: (String value) {
            print('update ${updateProfileControllerState.name.value}');
            ref.read(updateProfileController).changeName(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Text(
          'Email',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: ColourConstant.kBlueColor),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        TextFormField(
          style: TextStyle(
            color: ref.watch(updateProfileController).email.value == null
                ? ColourConstant.kGreyColor
                : ColourConstant.kDarkColor,
          ),
          initialValue: updateProfileControllerState.getInitialEmail,
          decoration: InputDecoration(
            errorText: updateProfileControllerState.email.error,
          ),
          onChanged: (String value) {
            ref.read(updateProfileController).changeEmail(value);
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        Center(
          child: SizedBox(
            width: 180,
            child: DefaultButton(
              text: "Update",
              press: () async {
                if (updateProfileControllerState.isFilled) {
                  if ("${updateProfileControllerState.name.value}" == 'null') {
                    ref.read(updateProfileController).initialName(
                        updateProfileControllerState.getInitialName);
                  }
                  if ("${updateProfileControllerState.email.value}" == 'null') {
                    ref.read(updateProfileController).initialEmail(
                        updateProfileControllerState.getInitialEmail);
                  }

                  final bool isSuccess =
                      await ref.read(updateProfileController).submitData();
                  print(isSuccess);
                  if (isSuccess) {
                    final bool isUpdated =
                        await ref.read(updateProfileController).updateUser();

                    if (isUpdated)
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        InitScreen.routeName,
                        ModalRoute.withName('/'),
                      );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              isPrimary: updateProfileControllerState.isFilled,
            ),
          ),
        )
      ],
    );
  }
}
