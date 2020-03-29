import 'package:flutter/material.dart';

class PerfilAvatar extends StatefulWidget {
  PerfilAvatar(this.radius);
  final double radius;

  @override
  State<StatefulWidget> createState() {
    return _PerfilAvatar(radius);
  }
}

class _PerfilAvatar extends State<PerfilAvatar> {
  _PerfilAvatar(this.radius);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: EdgeInsets.all((radius *0.08) <= 2.0 ? 2.0 : (radius * 0.08)),
      decoration: BoxDecoration(
        color: Colors.white, // border color
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/guacamole.jpg'),
        backgroundColor: Colors.blueGrey,
        radius: radius,
        child: Text(
          "R",
          style: TextStyle(fontSize: radius /~ 8),
        ),
      ),
    );
  }
}
