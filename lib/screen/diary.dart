import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';

class DiaryScreen extends HookConsumerWidget {
  static String routeName = "/diary";
  const DiaryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColourConstant.kBlueColor,
      extendBodyBehindAppBar: true,
      body: const Text('diary'),
    );
  }
}
