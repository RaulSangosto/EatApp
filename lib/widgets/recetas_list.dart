import 'dart:math';

import 'package:eatapp/models/receta.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';

class RecetaList extends StatefulWidget {
  RecetaList(this.cardH, this.recetas, {this.hasDots = false, pageIdCallback, this.refreshDataCallback}) : _pageIdCallback = pageIdCallback;
  final double cardH;
  final List<Receta> recetas;
  final bool hasDots;
  final Function _pageIdCallback;
  final Function refreshDataCallback;

  @override
  State<StatefulWidget> createState() {
    return _RecetaList();
  }
}

class _RecetaList extends State<RecetaList> {
  ScrollController _controller;
  double length = 0;
  int itemSelected = 0;

  _scrollListener() {
    setState(() {
      itemSelected = (_controller.offset / widget.cardH).floor();
    });
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

    return Column(
      children: [
        SizedBox(
          height: widget.cardH,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: widget.recetas.length,
              itemBuilder: (BuildContext context, int index) {
                Receta receta = widget.recetas[index];
                if (index == 0) {
                  return Padding(
                      padding: EdgeInsets.only(left: 70.0),
                      child: RecetaTile(receta, widget.cardH, widget.cardH));
                }
                return RecetaTile(receta, widget.cardH, widget.cardH);
              }),
        ),
        (widget.hasDots)
            ? new Dots(widget.recetas.length, itemSelected, widget._pageIdCallback)
            : SizedBox.shrink(),
      ],
    );
  }
}

class Dots extends StatefulWidget {
  const Dots(this.numItems, this.selected, this._pageIdCallback, {Key key}) : super(key: key);
  final int numItems;
  final int selected;
  final Function _pageIdCallback;

  @override
  _DotsState createState() => _DotsState();
}

class _DotsState extends State<Dots> {
  Color selectedColor;
  Color unselectedColor;
  double selectedRadius = 13;
  double unselectedRadius = 10;
  List<Dot> dots;
  int maxDots = 5;

  @override
  void initState() {
    selectedColor = Colors.blueGrey;
    unselectedColor = Colors.grey;
    super.initState();
    dots = new List<Dot>.generate(min(maxDots, widget.numItems), (index) => (index == widget.selected) ? Dot(selectedRadius, selectedColor) : Dot(unselectedRadius, unselectedColor));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(children: new List<Dot>.generate(min(maxDots, widget.numItems), (index) => (index == widget.selected || (index == maxDots-1 && widget.selected >= maxDots)) ? Dot(selectedRadius, selectedColor) : Dot(unselectedRadius, unselectedColor)),),
          Container(
            margin: const EdgeInsets.only(left: 70.0),
            child: OutlineButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              borderSide: BorderSide(
                color: Color(0xff48A299),
              ),
              onPressed: () {
                setState(() {
                  widget._pageIdCallback(1);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ver todas",
                  style: TextStyle(color: Color(0xff48A299)),
                ),
              ),
            ),
          ),
          SizedBox(width: 20.0,),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot(this.radius, this.color, {Key key}) : super(key: key);
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: radius/2),
      width: radius,
      height: radius,
      decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}
