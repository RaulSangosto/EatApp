import 'package:flutter/material.dart';

class Splash_Page extends StatefulWidget {
  Splash_Page({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash_Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
        ),
      ),
    );
  }
}
