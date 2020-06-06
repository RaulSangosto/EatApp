import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/pages/receta_page.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RecetaTile extends StatefulWidget {
  RecetaTile(this.receta, this.height, this.width, {this.margin = 0, this.refreshDataCallback});
  final Receta receta;
  final double height;
  final double width;
  final double margin;
  final Function refreshDataCallback;

  @override
  State<StatefulWidget> createState() {
    return _RecetaTile();
  }
}

class _RecetaTile extends State<RecetaTile> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  bool _favorito;
  bool _isLoading = false;
  Perfil perfil;

  @override
  void initState() {
     _fetchPerfil();
    super.initState();
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });
    perfil = await perfilService.getPerfil();
    for(int fav in perfil.favoritos){
      if(fav == widget.receta.id){
        widget.receta.favorito = true;
        break;
      }
    }
    _favorito = widget.receta.favorito;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading) ? Center(child: CircularProgressIndicator()) : Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecetaPage(recetaId: widget.receta.id)),
          ).then((value) {
            setState(() {
              _favorito = false;
              for(int f in perfil.favoritos){
                if(f == widget.receta.id){
                  _favorito = true;
                  break;
                }
              }
              widget.receta.favorito = _favorito;
              widget.refreshDataCallback();
            });
          });
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
                  onTap: () async {
                    setState(() {
                      if(_favorito){
                        perfil.favoritos.remove(widget.receta.id);
                        _favorito = false;
                      }
                      else {
                        perfil.favoritos.add(widget.receta.id);
                        _favorito = true;
                      }
                      widget.receta.favorito = _favorito;
                    });
                    perfil = await perfilService.updatePerfil();
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
