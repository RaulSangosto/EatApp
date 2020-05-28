import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Container(
          color: Theme.of(context).accentColor,
          child: Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  // image: DecorationImage(
                  //     image: AssetImage("assets/imagenes/logo.png"),
                  //     fit: BoxFit.cover)
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
