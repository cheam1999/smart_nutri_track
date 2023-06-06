import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/component/default_button.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:http/http.dart' as http;
import 'package:smart_nutri_track/screen/diary_daily.dart';
import 'package:smart_nutri_track/screen/diary_weekly.dart';

import '../component/default_tabView.dart';
import '../models/custom_exception.dart';
import '../size_config.dart';

class DiaryScreen extends HookConsumerWidget {
  static String routeName = "/diary";
  const DiaryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TabController _tabController = useTabController(
      initialLength: 2,
      initialIndex: 0,
    );

    return Container(
      // decoration: BoxDecoration(gradient: UgekColors.kPrimaryGradientColor),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Diary"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              getProportionateScreenHeight(50),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: ColourConstant.kWhiteColor,
                labelStyle: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                ),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: ColourConstant.kDarkColor),
                automaticIndicatorColorAdjustment: true,
                // indicatorSize: TabBarIndicatorSize.label,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: 'Daily',
                  ),
                  Tab(
                    text: 'Weekly',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DefaultTabBarView(
              childWidget: DailyDiary(),
            ),
            DefaultTabBarView(
              childWidget: WeeklyDiary(),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //     backgroundColor: ColourConstant.kBlueColor,
    //     extendBodyBehindAppBar: true,
    //     appBar: AppBar(
    //       title: Text(
    //         "Diary",
    //         style: TextStyle(
    //           color: ColourConstant.kWhiteColor,
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       elevation: 0,
    //     ),

    // body: SafeArea(
    //   child: ElevatedButton(
    //     onPressed: () async {
    //       bool diabetes = false;

    //       diabetes = await retrieveDiabetesPrediction();

    //       if (diabetes) {
    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //             content: const Text(
    //                 'You suspect gestational diabetes! We suggest you have a medical check-up.')));
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //             content: const Text(
    //                 'Hooray! You are free from gestational diabetes.')));
    //       }
    //     },
    //     child: Text(
    //       'Prediction',
    //     ),
    //   ),
    // ));
  }
}
