import 'package:eatapp/models/receta.dart';
import 'package:flutter/material.dart';

class RecetaTile extends StatefulWidget {
  RecetaTile(this.receta, this.height, this.width);
  final Receta receta;
  final double height;
  final double width;
  @override
  State<StatefulWidget> createState() {
    return _RecetaTile(receta, height, width);
  }
}

class _RecetaTile extends State<RecetaTile> {
  _RecetaTile(this.receta, this.height, this.width);

  final Receta receta;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.blueGrey,
          image: new DecorationImage(
            image: new ExactAssetImage(receta.imgUrl),
            fit: BoxFit.cover,
          ),
        ),
        child:Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.favorite, color: Colors.redAccent),
              Text(receta.titulo, style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}