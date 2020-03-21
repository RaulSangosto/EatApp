import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Crear extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CrearState();
  }
}

class _CrearState extends State<Crear> {
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
                  Text("Crear",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                    ),
                  Text("Recetas"),
                ]
              ),
              CircleAvatar(
                backgroundColor: Colors.blueGrey,
                radius: 30.0,
                child: Text("R",
                style: TextStyle(
                      fontSize: 20
                    ),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
