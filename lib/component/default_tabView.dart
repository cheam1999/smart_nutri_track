import 'package:flutter/material.dart';

class DefaultTabBarView extends StatelessWidget {
  const DefaultTabBarView({Key? key, required this.childWidget})
      : super(key: key);

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints.expand(),
        // decoration: UgekStyles.tabBodyDecoration(),
        child: SafeArea(
          child: childWidget,
        ),
      ),
    );
  }
}