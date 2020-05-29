import 'dart:convert';
import 'package:eatapp/services_conf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/perfil.dart';

class PerfilService {
  static const API = Configuration.API;
  String token = "";
  Perfil perfil;
  SharedPreferences prefs;

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<Perfil> getPerfil() async {
    //print("getPerfil!");
    if (perfil != null) {
      return perfil;
    }

    if (token == null || token == "") {
      await getSharedPrefs();
      if (prefs.containsKey("token")) {
        token = prefs.getString("token");
      } else {
        return null;
      }
    }
    var headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "token " + token
    };
    await http.get(API + "perfil/me", headers: headers).then((data) {
      if (data.statusCode == 200) {
        perfil = Perfil.fromJson(json.decode(utf8.decode(data.bodyBytes)));
      } else {}
    });
    return perfil;
  }

  Future<Perfil> updatePerfil({String nombre, String ubicacion, String descripcion, String kcal}) async {

    if (token == null){
      await getSharedPrefs();
      token = prefs.getString("token");
    }

    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "token " + token
    };

    perfil.nombre = nombre?? perfil.nombre;
    perfil.ubicacion = ubicacion?? perfil.ubicacion;
    perfil.descripcion = descripcion?? perfil.descripcion;
    perfil.kcalDiarias = kcal?? perfil.kcalDiarias;

    print("update: token " + token);
    

    await http.post(API + "perfil/me", 
      headers: headers,
      body: utf8.encode(jsonEncode(perfil.toJson())),
      encoding: Encoding.getByName("utf-8"))
      .then((data){
      print(data.statusCode);
      print(data.body);
      if (data.statusCode == 200) {
        perfil = Perfil.fromJson(json.decode(utf8.decode(data.bodyBytes)));
        print("update: user " + perfil.toJson().toString());
      } else {}
    });
    return perfil;
  }

  Future<bool> login(String username, String password) async {
    bool login;
    login = await http
        .post(API + "perfil/login",
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode({"username": username, "password": password}))
        .then((data) async {
      if (data.statusCode == 200) {
        String _token = json.decode(data.body)['token'];
        if (_token != null) {
          await getSharedPrefs();
          prefs.setString("token", _token);
          token = _token;
          print(token);
          return true;
        }
      }
      return false;
    });
    return login;
  }

  void logout() {
    http.post(
      API + "perfil/logout",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
    );
    getSharedPrefs();
    prefs.remove("token");
    perfil = null;
  }
}
