import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/pages/perfil_editar_page.dart';
import 'package:eatapp/receta_services.dart';
import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:eatapp/widgets/recetas_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../perfil_services.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage(
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
    return _PerfilState();
  }
}

class _PerfilState extends State<PerfilPage> {
  PerfilService get service => GetIt.I<PerfilService>();
  RecetasService get recetaService => GetIt.I<RecetasService>();

  Perfil perfil;
  APIResponse<List<Receta>> apiRecetas;
  List<Receta> recetas = List<Receta>();
  List<Receta> recetasFav = List<Receta>();
  bool _isLoged;
  bool _isLoading = false;
  String nombre, email, ubicacion, descripcion, dieta, kcalDiarias;

  @override
  initState() {
    super.initState();
    _isLoged = widget._isLoged;
    _fetchPerfil();
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });

    perfil = await service.getPerfil();

    nombre = perfil.nombre;
    email = perfil.email;
    ubicacion = perfil.ubicacion;
    descripcion = perfil.descripcion;
    dieta = perfil.dieta;
    kcalDiarias = perfil.kcalDiarias;

    apiRecetas = await recetaService.getRecetas();
    recetas = apiRecetas.data;

    for (Receta r in recetas) {
      for (int f in perfil.favoritos) {
        if (f == r.id) {
          recetasFav.add(r);
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  _onPressed() {}

  logout() async {
    print("logout");
    service.logout();
    setState(() {
      _isLoged = false;
      widget._loginCallback(_isLoged);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : ListView(children: <Widget>[
            Container(
              height: 605.0,
              width: 605.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40.0)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    blurRadius: 6.0, // has the effect of softening the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      3.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Stack(children: <Widget>[
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    image: new DecorationImage(
                      image: new ExactAssetImage("assets/images/pasta.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BackButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              widget._pageIdCallback(0);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: new EdgeInsets.only(top: 110.0),
                  alignment: Alignment.topCenter,
                  child: new PerfilAvatar(90),
                ),
                Container(
                  margin: new EdgeInsets.only(top: 170.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Color(0xffC5C5C5),
                              size: 32.0,
                            ),
                            GestureDetector(
                              onTap: logout,
                              child: Icon(
                                Icons.exit_to_app,
                                color: Color(0xffC5C5C5),
                                size: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      nombre,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color,
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  OutlineButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xff48A299),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PerfilEditarPage()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 0),
                                      child: Text(
                                        "Editar",
                                        style:
                                            TextStyle(color: Color(0xff48A299)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      email,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.pin_drop),
                                        Text(
                                          ubicacion,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 25.0, bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "12",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Seguidores",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "32",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Seguidos",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(descripcion),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      dieta,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          kcalDiarias,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "kcal",
                                          style: TextStyle(fontSize: 20.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Alergias",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _CircleIcon(),
                                        _CircleIcon(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: <Widget>[
                  Text("Mis Platos Favoritos",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                      height: 160.0,
                      child: new RecetaList(150.0, 140.0, recetasFav)),
                ],
              ),
            ),
          ]);
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration:
            BoxDecoration(color: Color(0xffC5C5C5), shape: BoxShape.circle),
        child: Icon(
          Icons.fastfood,
          color: Colors.white,
          size: 15.0,
        ),
      ),
    );
  }
}
