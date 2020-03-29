import 'package:eatapp/models/receta.dart';
import 'package:eatapp/test/data.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';

class RecetaList extends StatefulWidget {
  RecetaList(this.itemCount, this.cardH, this.cardW);
  final int itemCount;
  final double cardW;
  final double cardH;

  @override
  State<StatefulWidget> createState() {
    return _RecetaList(itemCount, cardW, cardH);
  }
}

class _RecetaList extends State<RecetaList> {
  _RecetaList(this._itemCount, this.cardH, this.cardW);

  final int _itemCount;
  final double cardW;
  final double cardH;
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
    double itemSize = cardW;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      //controller: _controller,
      itemCount: _itemCount,
      itemBuilder: (BuildContext context, int index) {
        Receta receta = recetas[index % recetas.length];
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