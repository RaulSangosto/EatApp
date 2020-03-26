import 'package:eatapp/models/receta.dart';
import 'package:eatapp/test/data.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';

class RecetaList extends StatefulWidget {
  RecetaList(this.itemCount);
  final int itemCount;

  @override
  State<StatefulWidget> createState() {
    return _RecetaList(itemCount);
  }
}

class _RecetaList extends State<RecetaList> {
  _RecetaList(this._itemCount);

  final int _itemCount;
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
    double itemSize = 160.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        double _pos;
        int item;

        if (scrollNotification is ScrollStartNotification){
          _pos =  _controller.offset;
          print("start");
        }
        else if (scrollNotification is ScrollUpdateNotification){

        }
        else if (scrollNotification is ScrollEndNotification) {
          double pixelsToMove;
          // if (_pos >= _controller.offset){
          //   item = (_controller.offset / itemSize).floor();
          // } else {
          //   item = (_controller.offset / itemSize).ceil();
          // }
          item = _controller.offset ~/ itemSize;
          pixelsToMove = item * itemSize;

          _controller.jumpTo(0);
          print("end");
        }
        item = _controller.offset ~/ itemSize;
        return true;
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemCount: _itemCount,
        itemBuilder: (BuildContext context, int index) {
          Receta receta = recetas[index % recetas.length];
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(left: 70.0),
              child: RecetaTile(receta, 250, itemSize));
          }
          return RecetaTile(receta, 250, 160);
        }
      ),
    );
  }
}