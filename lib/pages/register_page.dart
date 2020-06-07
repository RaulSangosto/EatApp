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
  String formErrors;
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
      formErrors = "";

      // if (username == null || username == "") {
      //   formErrors += "Debes indicar un Nombre de Usuario\n";
      // }
      // if (password == null ||
      //     password == "" ||
      //     password2 == null ||
      //     password2 == "") {
      //   formErrors += "Debes introducir una Contraseña\n";
      // } else if (password != password2) {
      //   formErrors += "Las Contraseñas debes ser Iguales\n";
      // }
      // if (nombre == null || nombre == "") {
      //   formErrors += "Debes indicar un Nombre\n";
      // }
      // if (email == null || email == "") {
      //   formErrors += "Debes indicar un Email\n";
      // }
      // if (kcal == null || kcal == "") {
      //   formErrors += "Debes indicar unas Kcal Diarias\n";
      // }
      // if (dieta == null || dieta == "") {
      //   formErrors += "Debes indicar una Dieta\n";
      // }
      // if (sexo == null || sexo == "") {
      //   formErrors += "Debes indicar un Sexo\n";
      // }
      // if (fechaNacimiento== null) {
      //   formErrors += "Debes indicar una Fecha de Nacimiento\n";
      // }
    });

    if (formErrors == "") {
      Perfil p = new Perfil(nombre: nombre, email: email, kcalDiarias: kcal);
      if(fechaNacimiento != null){
        p.fechaNac = fechaNacimiento;
      }
      if(sexo != null){
        p.sexo = sexo.code;
      }
      if(dieta != null){
        p.dieta = dieta.code;
      }
      APIResponse<Perfil> _apiResponsePerfil = await perfilService.register(perfil: p, username: username, password: password, password2: password2);
      if(_apiResponsePerfil.data != null){
        Perfil newPerfil = _apiResponsePerfil.data;
        formErrors = "";
      }
      else {
        formErrors = _apiResponsePerfil.errorMessage;
      }
    }

    setState(() {
      _isLoading = false;
      //print(loginResponse.data.nombre);
      // widget._pageIdCallback(0);
      // widget._loginCallback(_isLoged);
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
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        hintText: "Email", isDense: true),
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
                                        width:
                                            MediaQuery.of(context).size.width -
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
                                            height: 2,
                                            color:
                                                Theme.of(context).accentColor,
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
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  initialDate: DateTime(
                                                      DateTime.now().year - 18),
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
                                                  color: Colors.grey)),
                                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: (fechaNacimiento == null) ? 10.0 : 20.0),
                                          child: Text((fechaNacimiento == null)
                                              ? "Fecha de Nacimiento"
                                              : fechaNacimiento.day.toString() + "/" + fechaNacimiento.month.toString() + "/" + fechaNacimiento.year.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                        width:
                                            MediaQuery.of(context).size.width -
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
                                            height: 2,
                                            color:
                                                Theme.of(context).accentColor,
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
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextField(
                                    controller: _kcalDiariasController,
                                    maxLength: 4,
                                    decoration: InputDecoration(
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
                                        hintText: "Contraseña", isDense: true),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  TextField(
                                    controller: _password2Controller,
                                    obscureText: true,
                                    decoration: InputDecoration(
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
                                    child: Text(
                                      formErrors,
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class LoginFormField extends StatelessWidget {
  const LoginFormField({
    Key key,
    @required TextEditingController userController,
  })  : _userController = userController,
        super(key: key);

  final TextEditingController _userController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _userController,
      //textInputAction: TextInputAction.next,
      style: TextStyle(),
      decoration: InputDecoration(
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
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Password is required';
        }
        return value.trim();
      },
    );
  }
}

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    Key key,
    @required TextEditingController passwordController,
  })  : _passwordController = passwordController,
        super(key: key);

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
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
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Password is required';
        }
        return value.trim();
      },
    );
  }
}
