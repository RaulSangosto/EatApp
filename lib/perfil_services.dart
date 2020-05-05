import 'dart:convert';
import 'package:eatapp/services_conf.dart';
import 'package:http/http.dart' as http;
import 'models/perfil.dart';
import 'models/api_response.dart';

class PerfilService {
  static const API = Configuration.API;

  Future<APIResponse<Perfil>> getPerfil() {
    return http.get(API + "perfil/me",
        headers: {"Accept": "application/json"}).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        print("getPerfil data " + data.body);
        Perfil perfil;
        perfil = Perfil.fromJson(json.decode(data.body));
        return APIResponse<Perfil>(data: perfil);
      }
      return APIResponse<Perfil>(
          error: true,
          errorMessage: data.statusCode.toString() + ': An error occurred');
    }).catchError((_) =>
        APIResponse<Perfil>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Perfil>> login(String username, String password) {
    return http
        .post(API + "perfil/login",
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({"username": username, "password": password}))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        final perfil = Perfil.fromJson(json.decode(data.body));
        print("login nombre" + perfil.nombre);
        return APIResponse<Perfil>(data: perfil);
      }
      return APIResponse<Perfil>(
          error: true,
          errorMessage:
              "ERROR " + data.statusCode.toString() + ': An error occurred');
    }).catchError((_) => APIResponse<Perfil>(
            error: true, errorMessage: 'An error occurred'));
  }
}
