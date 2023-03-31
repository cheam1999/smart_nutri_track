import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/component/default_button.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:http/http.dart' as http;

import '../models/custom_exception.dart';

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
        body: SafeArea(
          child: ElevatedButton(
            onPressed: () async {
              bool diabetes = false;

              diabetes = await retrieveDiabetesPrediction();

              if (diabetes) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'You suspect gestational diabetes! We suggest you have a medical check-up.')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Hooray! You are free from gestational diabetes.')));
              }
            },
            child: Text(
              'Prediction',
            ),
          ),
        ));
  }

  @override
  Future<bool> retrieveDiabetesPrediction() async {
    var url =
        Uri.parse('https://snt-diabetes-api.herokuapp.com/diabetes_prediction');

    try {
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'Carbohydrate_intake': 70.2,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      var responseBody = response.body;
      if (response.statusCode == 200) {
        if (responseBody == '0') {
          return false;
        } else {
          return true;
        }
      } else {
        throw CustomException(
            message: 'Failed to predict gestational diabetes!');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
