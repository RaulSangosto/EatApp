import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Perfil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil> {
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
                  Text("Raúl Sánchez",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                    ),
                  Text("raul@mail.com"),
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
