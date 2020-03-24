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
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _TopCard(),
            ],),
          ),
        ],
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new ExactAssetImage("assets/images/guacamole.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment(0, -1.6),
          end: Alignment(0, 1.4),
          colors: [Colors.deepPurple, const Color.fromARGB(0, 0, 0, 0)], // whitish to gray
        ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:10.0,vertical: 20.0,),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("Descubrir",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                      ),
                    Text("Por Platos y Lugares", style: TextStyle(color: Colors.white)),
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
        ),
      ),
    );
  }
}
