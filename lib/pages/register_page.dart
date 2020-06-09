import 'dart:convert';

import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(
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
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  SharedPreferences prefs;
  APIResponse<String> loginResponse;
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _kcalDiariasController = new TextEditingController();
  List<Choice> dietas = new List<Choice>();
  List<Choice> sexos = new List<Choice>();
  Choice dieta, sexo;
  DateTime fechaNacimiento;
  Map<String, dynamic> formErrors;
  bool _isLoading = false;
  bool _isLoged;
  Perfil newPerfil;

  @override
  initState() {
    super.initState();
    dietas.add(Choice("Omnivora", "o"));
    dietas.add(Choice("Vegetariana", "v"));
    dietas.add(Choice("Vegana", "n"));
    sexos.add(Choice("Hombre", "h"));
    sexos.add(Choice("Mujer", "m"));
    sexos.add(Choice("Otros", "o"));
    _isLoged = widget._isLoged;
  }

  sendData() async {
    String username = _userController.text.trim();
    String password = _passwordController.text.trim();
    String password2 = _password2Controller.text.trim();
    String nombre = _nombreController.text.trim();
    String email = _emailController.text.trim();
    String kcal = _kcalDiariasController.text.trim();

    setState(() {
      _isLoading = true;
      formErrors = new Map<String, dynamic>();
    });

    if (formErrors.isEmpty) {
      Perfil p = new Perfil(nombre: nombre, email: email, kcalDiarias: kcal);
      if (fechaNacimiento != null) {
        p.fechaNac = fechaNacimiento;
      }
      if (sexo != null) {
        p.sexo = sexo.code;
      }
      if (dieta != null) {
        p.dieta = dieta.code;
      }
      APIResponse<Perfil> _apiResponsePerfil = await perfilService.register(
          perfil: p,
          username: username,
          password: password,
          password2: password2);
      if (_apiResponsePerfil.data != null) {
        Perfil newPerfil = _apiResponsePerfil.data;
        formErrors = new Map<String, dynamic>();
        setState(() {
          // widget._loginCallback(true);
          // widget._pageIdCallback(0);
        });
        Navigator.of(context).pop(true);
      } else {
        formErrors = json.decode(_apiResponsePerfil.errorMessage);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: (_isLoading)
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
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
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: Colors.white),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BackButton(),
                                  Text(
                                    'Regístrate',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 32.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _nombreController,
                                      maxLength: 100,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["nombre"] != null)
                                              ? formErrors["nombre"][0]
                                              : null,
                                          hintText: "Nombre y Apellidos",
                                          isDense: true),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: _emailController,
                                      maxLength: 100,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["email"] != null)
                                              ? formErrors["email"][0]
                                              : null,
                                          hintText: "Email",
                                          isDense: true),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Sexo:",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: DropdownButton<Choice>(
                                            hint: Text("Sexo"),
                                            isExpanded: true,
                                            value: sexo,
                                            icon: Icon(Icons.arrow_downward),
                                            iconSize: 24,
                                            elevation: 16,
                                            //style: TextStyle(color: Theme.of(context).accentColor),
                                            underline: Container(
                                              height: (formErrors != null &&
                                                      formErrors["sexo"] !=
                                                          null)
                                                  ? 1
                                                  : 2,
                                              color: (formErrors != null &&
                                                      formErrors["sexo"] !=
                                                          null)
                                                  ? Theme.of(context).errorColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                            ),
                                            onChanged: (newValue) {
                                              setState(() => sexo = newValue);
                                            },
                                            items: sexos
                                                .map<DropdownMenuItem<Choice>>(
                                                    (Choice value) {
                                              return DropdownMenuItem<Choice>(
                                                value: value,
                                                child: Text(value.nombre),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    (formErrors != null &&
                                            formErrors["sexo"] != null)
                                        ? Text(
                                            formErrors["sexo"][0],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "F. Nacimiento",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    errorInvalidText: (formErrors !=
                                                                null &&
                                                            formErrors[
                                                                    "fecha_nacimiento"] !=
                                                                null)
                                                        ? formErrors[
                                                                "fecha_nacimiento"]
                                                            [0]
                                                        : null,
                                                    initialDate: DateTime(
                                                        DateTime.now().year -
                                                            18),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now())
                                                .then((date) {
                                              setState(() {
                                                fechaNacimiento = date;
                                              });
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: (formErrors !=
                                                                null &&
                                                            formErrors[
                                                                    "fecha_nacimiento"] !=
                                                                null)
                                                        ? Theme.of(context)
                                                            .errorColor
                                                        : Colors.grey)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal:
                                                    (fechaNacimiento == null)
                                                        ? 10.0
                                                        : 20.0),
                                            child: Text(
                                                (fechaNacimiento == null)
                                                    ? "Fecha de Nacimiento"
                                                    : fechaNacimiento.day
                                                            .toString() +
                                                        "/" +
                                                        fechaNacimiento.month
                                                            .toString() +
                                                        "/" +
                                                        fechaNacimiento.year
                                                            .toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    (formErrors != null &&
                                            formErrors["fecha_nacimiento"] !=
                                                null)
                                        ? SizedBox(
                                            height: 5.0,
                                          )
                                        : SizedBox.shrink(),
                                    (formErrors != null &&
                                            formErrors["fecha_nacimiento"] !=
                                                null)
                                        ? Text(
                                            formErrors["fecha_nacimiento"][0],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : SizedBox.shrink(),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 30.0),
                                      width: double.infinity,
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Dieta:",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: DropdownButton<Choice>(
                                            hint: Text("Dieta"),
                                            isExpanded: true,
                                            value: dieta,
                                            icon: Icon(Icons.arrow_downward),
                                            iconSize: 24,
                                            elevation: 16,
                                            //style: TextStyle(color: Theme.of(context).accentColor),
                                            underline: Container(
                                              height: (formErrors != null &&
                                                      formErrors["dieta"] !=
                                                          null)
                                                  ? 1
                                                  : 2,
                                              color: (formErrors != null &&
                                                      formErrors["dieta"] !=
                                                          null)
                                                  ? Theme.of(context).errorColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                            ),
                                            onChanged: (newValue) {
                                              setState(() => dieta = newValue);
                                            },
                                            items: dietas
                                                .map<DropdownMenuItem<Choice>>(
                                                    (Choice value) {
                                              return DropdownMenuItem<Choice>(
                                                value: value,
                                                child: Text(value.nombre),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    (formErrors != null &&
                                            formErrors["dieta"] != null)
                                        ? Text(
                                            formErrors["dieta"][0],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: _kcalDiariasController,
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["kcal_diarias"] !=
                                                      null)
                                              ? formErrors["kcal_diarias"][0]
                                              : null,
                                          hintText: "kCal Diarias",
                                          isDense: true),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 30.0),
                                      width: double.infinity,
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                    TextField(
                                      controller: _userController,
                                      maxLength: 100,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["username"] !=
                                                      null)
                                              ? formErrors["username"][0]
                                              : null,
                                          hintText: "Nombre de Usuario",
                                          isDense: true),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["password"] !=
                                                      null)
                                              ? formErrors["password"][0]
                                              : null,
                                          hintText: "Contraseña",
                                          isDense: true),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextField(
                                      controller: _password2Controller,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          errorText: (formErrors != null &&
                                                  formErrors["password2"] !=
                                                      null)
                                              ? formErrors["password2"][0]
                                              : null,
                                          hintText: "Repita Contraseña",
                                          isDense: true),
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                              (formErrors == null)
                                  ? SizedBox.shrink()
                                  : Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
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
                                child: Text('Enviar',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
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
