import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:eatapp/widgets/recetas_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../receta_services.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key key,
      bool loged,
      Function(bool) loginCallback,
      Function(int) pageIdCallback})
      : _isLoged = loged,
        _loginCallback = loginCallback,
        _pageIdCallback = pageIdCallback,
        super(key: key);
  final bool _isLoged;
  final Function(bool) _loginCallback;
  final Function(int) _pageIdCallback;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  RecetasService get service => GetIt.I<RecetasService>();
  PerfilService get perfilService => GetIt.I<PerfilService>();
  APIResponse<List<Categoria>> _apiResponseCategorias;
  APIResponse<Categoria> _apiResponseCategoriaHoy;
  APIResponse<List<Receta>> _apiResponseRecetas;
  List<Categoria> categorias;
  Categoria categoriaHoy;
  List<Receta> ultimasRecetas;
  List<Receta> recetasHoy;
  bool _isLoading = false;
  Perfil perfil;

  @override
  void initState() {
    _fetchRecetasDias();
    super.initState();
  }

  _fetchRecetasDias() async {
    setState(() {
      _isLoading = true;
    });
    perfil = await perfilService.getPerfil();
    _apiResponseCategorias = await service.getCategorias();
    categorias = _apiResponseCategorias.data;
    _apiResponseCategoriaHoy = await service.getCategoriaHoy(perfilService.token);
    Categoria cHoy = _apiResponseCategoriaHoy.data;
    for(Categoria c in categorias){
      if(c.id == cHoy.id){
        categoriaHoy = c;
        break;
      }
    }
    _apiResponseRecetas = await service.getRecetas(categoria: categoriaHoy, categorias: categorias);
    recetasHoy = _apiResponseRecetas.data;
    _apiResponseRecetas = await service.getUltimasRecetas(categorias: categorias);
    List<Receta>_ultimasRecetas = _apiResponseRecetas.data;
     _apiResponseRecetas = await service.getRecetas(categorias: categorias);
    List<Receta> _todasRecetas = _apiResponseRecetas.data;
    ultimasRecetas = new List<Receta>();
    for(Receta r in _ultimasRecetas){
      for(Receta rc in _todasRecetas){
        if (r.id == rc.id) {
          ultimasRecetas.add(rc);
          break;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    return SafeArea(
      child: Builder(builder: (_) {
        if (_isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (_apiResponseRecetas.error) {
          return Center(
              child: Text("Receta Error: " + _apiResponseRecetas.errorMessage));
        }
        if (_apiResponseCategorias.error) {
          return Center(
              child: Text(
                  "Categoria Error: " + _apiResponseCategorias.errorMessage));
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  SizedBox(
                    height: 470.0,
                    child: Stack(
                      children: <Widget>[
                        _TopCard(categoriaHoy),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 200.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.16),
                                    blurRadius:
                                        6.0, // has the effect of softening the shadow
                                    offset: Offset(
                                      0.0, // horizontal, move right 10
                                      -3.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 1),
                          child: SizedBox(
                            height: 338.0,
                            child: new RecetaList(250.0, recetasHoy, hasDots: true, pageIdCallback: widget._pageIdCallback, refreshDataCallback: _fetchRecetasDias),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      height: 250.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Nuevas Recetas",
                              style: TextStyle(
                                  color: Color(0xff363B4B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                          ),
                          SizedBox(
                              height: 160.0,
                              child: new RecetaList(160.0, ultimasRecetas, refreshDataCallback: _fetchRecetasDias,)),
                        ],
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TopCard extends StatelessWidget {
  _TopCard(this.categoria);

  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new NetworkImage(categoria.imgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, -1.3),
            end: Alignment(0, 0),
            colors: [
              Color(0xff000048),
              const Color.fromARGB(0, 0, 0, 0)
            ], // whitish to gray
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Para hoy",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        Flexible(
                          child: Text(
                            categoria.titulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
