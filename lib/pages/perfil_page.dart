import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../perfil_services.dart';

class Perfil_Page extends StatefulWidget {
  const Perfil_Page({Key key, bool loged, Function(bool) login_callback, Function(int) pageId_callback})
      : _isLoged = loged,
        _login_callback = login_callback,
        _pageId_callback = pageId_callback,
        super(key: key);
  final bool _isLoged;
  final Function(bool) _login_callback;
  final Function(int) _pageId_callback;

  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil_Page> {
  PerfilService get service => GetIt.I<PerfilService>();
  SharedPreferences prefs;
  bool _isLoged;

  @override
  initState(){
    super.initState();
    _isLoged = widget._isLoged;
  }

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _onPressed() {}

  logout() async{
    print("logout");
    service.logout();
    await getSharedPrefs();
    prefs.remove("token");
    print("token " + prefs.containsKey("token").toString());
    setState(() {
      _isLoged = false;
      widget._login_callback(_isLoged);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        height: 605.0,
        width: 605.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
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
                  Icon(Icons.arrow_back_ios, color: Colors.white),
                ],
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(top: 110.0),
            alignment: Alignment.topCenter,
            child: PerfilAvatar(90),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Raúl Sánchez",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.body1.color,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OutlineButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xff48A299),
                              ),
                              onPressed: _onPressed,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0),
                                child: Text(
                                  "Editar",
                                  style: TextStyle(color: Color(0xff48A299)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "raul@mail.com",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.pin_drop),
                                  Text(
                                    "Murcia, España",
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
                          margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
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
                          child: Text(
                              "Descripción personal, intereses generales, lo que hago, mi dieta, mi rutina, quizá mis alergias y mi tipo de cocina favorita."),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Omnivoro",
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
                                    "2374",
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
