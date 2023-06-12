import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_nutri_track/routes.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';
// import 'package:smart_nutri_track/screen/auth/sign_up.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/screen/init.dart';
import 'package:smart_nutri_track/screen/start.dart';
import 'package:smart_nutri_track/utilities/user_shared_preferences.dart';

import 'env.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("?????????????????? $fcmToken");

  var url = Platform.isAndroid
      ? 'http://10.213.20.161:8030/api/'
      // ? 'http://10.213.22.40:8030/api/'
      : 'http://10.0.2.2:8030/api/';
  // : 'http://localhost/smartNutriTrack_api/';

  BuildEnvironment.init(flavor: BuildFlavor.local, baseUrl: url);
  assert(env != null);
  await UserSharedPreferences.init();
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
