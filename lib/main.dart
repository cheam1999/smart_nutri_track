import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_nutri_track/routes.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';
// import 'package:smart_nutri_track/screen/auth/sign_up.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/screen/init.dart';

import 'env.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  var url = Platform.isAndroid
      ? 'http://192.168.0.102:8000/api/'
      : 'http://10.0.2.2:8000/api/';
  // : 'http://localhost/smartNutriTrack_api/';

  BuildEnvironment.init(flavor: BuildFlavor.local, baseUrl: url);
  assert(env != null);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
