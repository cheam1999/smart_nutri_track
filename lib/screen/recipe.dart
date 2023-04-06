import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';

class RecipeScreen extends HookConsumerWidget {
  static String routeName = "/recipe";
  const RecipeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBlueColor,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text(
          "Under Construction",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
