import 'package:flutter/material.dart';

class Texto extends StatelessWidget {
  const Texto(this.texto, {Key key}) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
          color: Colors.red,
          fontSize: 24.0,
          fontWeight: FontWeight.bold),
    );
  }
}

class RowAndCol extends StatelessWidget {
  const RowAndCol({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.alarm),
        Icon(Icons.play_arrow),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.settings),
          ],
        )
      ],
    );
  }
}

class StackWidget extends StatelessWidget {
  const StackWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(height: 50.0,
                  width: 50.0, 
                  color: Colors.blueAccent, 
                  margin: EdgeInsets.only(left: 20.0),
                  ),
        Positioned(top: 20.0, child: Text("Hola!"),)
      ],
    );
  }
}

class Contenedor extends StatelessWidget {
  const Contenedor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 40.0,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
                spreadRadius: 5.0)
          ]),
      child: Text("Soy un Conainer"),
    );
  }
}

class StateFulWidgetExample extends StatefulWidget {
  StateFulWidgetExample({Key key}) : super(key: key);

  @override
  _StateFulWidgetExampleState createState() => _StateFulWidgetExampleState();
}

class _StateFulWidgetExampleState extends State<StateFulWidgetExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Titulo"),),
       body: Container(),
    );
  }
}