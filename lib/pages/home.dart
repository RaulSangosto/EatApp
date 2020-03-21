import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 30.0,
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Para hoy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                    ),
                  Text("Hidratos de Carbono"),
                ]
              ),
              CircleAvatar(
                backgroundColor: Colors.blueGrey,
                radius: 28.0,
                child: Text("R",
                style: TextStyle(
                      fontSize: 20
                    ),),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 30.0,
        ),
      ],
    );
  }
}
