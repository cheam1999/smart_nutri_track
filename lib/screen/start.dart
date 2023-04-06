import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_nutri_track/screen/auth/sign_in.dart';

import '../constant/showLoadingDialog.dart';
import '../controller/auth_controller.dart';
import '../size_config.dart';
import 'home.dart';

class StartScreen extends ConsumerStatefulWidget {
  static String routeName = "/start";
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  // PageController _pageController = PageController();
  // int _selectedIndex = 0;

  // List<Widget> _screens = [IngredientScreen(), SelectIngredientPage(), ProfileScreen()];

  bool isLoading = true;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    try {
      print('get user...');
      await ref.read(authControllerProvider.notifier).appStarted();
      setState(() => isLoading = false);
    } catch (e) {
      print('Failed to get user info');
      showErrorDialog(
          context: context,
          action: () {
            Navigator.pushNamedAndRemoveUntil(
                context, StartScreen.routeName, ModalRoute.withName('/'));
          },
          error: "Failed to connect to the server.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authControllerState = ref.watch(authControllerProvider);

    //hardcode
    isLoading = false;

    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : authControllerState.isLogin
            ? HomeScreen()
            : SignInScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
