import 'dart:convert';

import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/pages/register_page.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
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
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  SharedPreferences prefs;
  APIResponse<String> loginResponse;
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  APIResponse<Perfil> _apiResponsePerfil;
  Map<String, dynamic> formErrors;
  bool _isLoading = false;
  bool _isLoged;

  @override
  initState() {
    super.initState();
    _isLoged = widget._isLoged;
    formErrors = new Map<String,dynamic>();
  }

  sendData() async {
    String username = _userController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    _apiResponsePerfil = await perfilService.login(username, password);
    if(_apiResponsePerfil.data != null){
      _isLoged = true;
    }
    else{
      formErrors = json.decode(_apiResponsePerfil.errorMessage);
    }

    setState(() {
      _isLoading = false;
      widget._pageIdCallback(0);
      widget._loginCallback(_isLoged);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SafeArea(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.5),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Theme.of(context).accentColor.withOpacity(0.45),
                      BlendMode.dstATop),
                  image: AssetImage("assets/images/guacamole.jpg"),
                  fit: BoxFit.cover),
            ),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Eat',
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'App',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 42,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Center(
                    child: Text(
                  'Come Sano a Diario',
                  style: TextStyle(fontSize: 16.0),
                )),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Inicia Sesión',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      LoginFormField(userController: _userController, formErrors: formErrors),
                      SizedBox(
                        height: 20.0,
                      ),
                      PasswordFormField(
                          passwordController: _passwordController, formErrors: formErrors),
                      SizedBox(
                        height: 40.0,
                      ),
                      RaisedButton(
                        onPressed: sendData,
                        textColor: Colors.white,
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10.0),
                        child: Text('Entrar',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('¿Aún no estás registrado?'),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage(
                                        loged: _isLoged,
                                        loginCallback: widget._loginCallback,
                                        pageIdCallback: widget._pageIdCallback,
                                      )),
                            ).then((value) {
                              if (value == null) {
                                value = false;
                              }
                              setState(() {
                                _isLoged = value;
                                widget._pageIdCallback(0);
                                widget._loginCallback(_isLoged);
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                    content: Text(
                                        'Uruario Registrado Correctamente!', style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),));

                                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                Scaffold.of(context).showSnackBar(snackBar);
                              });
                            });
                          },
                          child: Text(
                            'Registrate Aquí.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class LoginFormField extends StatelessWidget {
  const LoginFormField({
    Key key,
    @required TextEditingController userController,
    @required Map<String, dynamic> formErrors,
  })  : _userController = userController,
        _formErrors = formErrors,
        super(key: key);

  final TextEditingController _userController;
  final Map<String,dynamic> _formErrors;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _userController,
      //textInputAction: TextInputAction.next,
      style: TextStyle(),
      decoration: InputDecoration(
        errorText: (_formErrors != null) ? (_formErrors["__all__"] != null) ? _formErrors["__all__"][0] : (_formErrors["username"]!= null) ? _formErrors["username"][0] : null : null,
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          hintText: "Nombre de Usuario",
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          border: new OutlineInputBorder(
            gapPadding: 0.0,
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          filled: true,
          fillColor: Colors.grey[300]),
    );
  }
}

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    Key key,
    @required TextEditingController passwordController,
    @required Map<String, dynamic> formErrors,
  })  : _passwordController = passwordController,
        _formErrors = formErrors,
        super(key: key);

  final TextEditingController _passwordController;
  final Map<String,dynamic> _formErrors;


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        errorText: (_formErrors != null) ? (_formErrors["__all__"] != null) ? _formErrors["__all__"][0] : (_formErrors["password"]!= null) ? _formErrors["password"][0] : null : null,
          hintText: "Contraseña",
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          border: new OutlineInputBorder(
            gapPadding: 0.0,
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          filled: true,
          fillColor: Colors.grey[300]),
    );
  }
}
