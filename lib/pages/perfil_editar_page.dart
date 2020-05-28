import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../perfil_services.dart';

class PerfilEditarPage extends StatefulWidget {
  const PerfilEditarPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<PerfilEditarPage> {
  PerfilService get service => GetIt.I<PerfilService>();
  Perfil perfil;
  bool _isLoading = false;
  String nombre, email, ubicacion, descripcion, dieta, kcalDiarias;

  @override
  initState() {
    super.initState();
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

    setState(() {
      _isLoading = false;
    });
  }

  logout() async {
    print("logout");
    service.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading)
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
                    height: 150.0,
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
                              Navigator.of(context).pop();
                            },
                          ),
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 32.0,
                          ),
                          Container(
                            child: Stack(
                              children: <Widget>[
                                new PerfilAvatar(80),
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white70,
                                  size: 32.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 170.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    perfil = await service.updatePerfil();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 0),
                                    child: Text(
                                      "Guardar",
                                      style: TextStyle(color: Colors.white),
                                    ),
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
            ]),
    );
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
