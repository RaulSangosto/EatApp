import 'package:eatapp/models/receta.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';

class RecetaList extends StatefulWidget {
  RecetaList(this.cardH, this.cardW, this.recetas);
  final double cardW;
  final double cardH;
  final List<Receta> recetas;

  @override
  State<StatefulWidget> createState() {
    return _RecetaList(cardW, cardH, recetas);
  }
}

class _RecetaList extends State<RecetaList> {
  _RecetaList(this.cardH, this.cardW, this.recetas);

  final double cardW;
  final double cardH;
  final List<Receta> recetas;
  ScrollController _controller;

  _scrollListener() {
 
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
    //double itemSize = cardW;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      //controller: _controller,
      itemCount: recetas.length,
      itemBuilder: (BuildContext context, int index) {
        Receta receta = recetas[index];
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(left: 70.0),
            child: RecetaTile(receta, cardH, cardW)
          );
        }
        return RecetaTile(receta, cardH, cardW);
      }
    );
  }
}