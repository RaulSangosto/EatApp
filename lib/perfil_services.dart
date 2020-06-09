import 'dart:convert';
import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/services_conf.dart';
import 'package:flutter/material.dart';
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
        if (perfil.avatarUrl != null) {
          String url = "http://" + Configuration.localhost + perfil.avatarUrl;
          perfil.avatarUrl = url;
        }
        if (perfil.fondoUrl != null) {
          String url = "http://" + Configuration.localhost + perfil.fondoUrl;
          perfil.fondoUrl = url;
        }
      } else {}
    });
    return perfil;
  }

  Future<Perfil> updatePerfil(
      {String nombre,
      String ubicacion,
      String descripcion,
      String kcal,
      String dieta,
      String imgUrl,
      String fondoUrl}) async {
    if (token == null) {
      await getSharedPrefs();
      token = prefs.getString("token");
    }

    var headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "token " + token
    };
    Perfil newP = new Perfil(
        nombre: nombre,
        ubicacion: ubicacion,
        descripcion: descripcion,
        kcalDiarias: kcal,
        dieta: dieta,
        avatarUrl: imgUrl,
        fondoUrl: fondoUrl);

    await http
        .patch(API + "perfil/me",
            headers: headers, body: jsonEncode(newP.toJson(patch: true)))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        perfil = Perfil.fromJson(json.decode(utf8.decode(data.bodyBytes)));
        if (perfil.avatarUrl != null) {
          String url = "http://" + Configuration.localhost + perfil.avatarUrl;
          perfil.avatarUrl = url;
        }
        if (perfil.fondoUrl != null) {
          String url = "http://" + Configuration.localhost + perfil.fondoUrl;
          perfil.fondoUrl = url;
        }
      } else {
        print(data.body);
      }
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
          return true;
        }
      }
      return false;
    });
    return login;
  }

  Future<APIResponse<Perfil>> register(
      {@required Perfil perfil,
      @required String username,
      @required String password,
      @required String password2}) async {
    print("register");
    Map<String, dynamic> body = perfil.toJson();
    Map<String, dynamic> extra = {
      "username": username,
      "password": password,
      "password2": password2
    };
    body.addAll(extra);
    return await http
        .post(
      API + "perfil/register",
      headers: {
        "Accept": "application/json; charset=UTF-8",
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(body),
    )
        .then((data) async {
      print(data.statusCode);
      if (data.statusCode == 200) {
        String _token = json.decode(data.body)['token'];
        if (_token != null) {
          await getSharedPrefs();
          prefs.setString("token", _token);
          token = _token;
        }
        return APIResponse<Perfil>(
            data: Perfil.fromJson(json.decode(utf8.decode(data.bodyBytes))));
      }
      return APIResponse<Perfil>(
          data: null, error: true, errorMessage: data.body);
    }).catchError((_) => APIResponse<Perfil>(
            data: null, error: true, errorMessage: 'An error occurred'));
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
