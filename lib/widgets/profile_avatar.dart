import 'package:flutter/material.dart';

class PerfilAvatar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PerfilAvatar();
  }
}

class _PerfilAvatar extends State<PerfilAvatar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white, // border color
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/guacamole.jpg'),
        backgroundColor: Colors.blueGrey,
        radius: 30.0,
        child: Text("R",
        style: TextStyle(
              fontSize: 20
            ),),
      ),
    );
  }
}