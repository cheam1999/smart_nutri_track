import 'package:flutter/material.dart';
import 'package:smart_nutri_track/routes.dart';
import 'package:smart_nutri_track/screen/init.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: InitScreen.routeName,
      routes: routes,
    );
  }
}
