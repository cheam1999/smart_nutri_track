
import 'package:flutter/material.dart';
import 'package:smart_nutri_track/constant/colour_constant.dart';
import 'package:smart_nutri_track/screen/diary.dart';
import 'package:smart_nutri_track/screen/home.dart';
import 'package:smart_nutri_track/screen/recipe.dart';


class InitScreen extends StatefulWidget {
  static String routeName = "/init";
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {

  PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> _screens = [
    HomeScreen(),
    DiaryScreen(),
    RecipeScreen()
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourConstant.kWhiteColor,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        //physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColourConstant.kButtonColor,
        unselectedItemColor: ColourConstant.kGreyColor,
        // backgroundColor: Colors.white,
        // elevation: 30,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedLabelStyle: TextStyle(height: 1.5),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apple),
            label: 'Meal Plan',
          ),
        ],
      ),
    );
  }
}
