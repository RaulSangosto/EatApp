import 'package:eatapp/models/receta.dart';
import 'package:eatapp/pages/receta_page.dart';
import 'package:flutter/material.dart';

class RecetaTile extends StatefulWidget {
  RecetaTile(this.receta, this.height, this.width, {this.margin = 0});
  final Receta receta;
  final double height;
  final double width;
  final double margin;

  @override
  State<StatefulWidget> createState() {
    return _RecetaTile();
  }
}

class _RecetaTile extends State<RecetaTile> {
  bool _favorito;

  @override
  void initState() {
    _favorito = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Receta_Page(recetaId: widget.receta.id)),
          );
        },
        child: Container(
          margin: new EdgeInsets.only(top: widget.margin),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blueGrey,
            image: widget.receta.imgUrl == null
                ? null
                : new DecorationImage(
                    image: new NetworkImage(widget.receta.imgUrl),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _favorito = !_favorito;
                    });
                  },
                    child: Icon(_favorito ? Icons.favorite : Icons.favorite_border,
                        color: _favorito
                            ? Colors.redAccent
                            : Colors.grey)),
                Text(
                  widget.receta.titulo,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
