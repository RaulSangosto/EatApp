import 'dart:convert';
import 'package:eatapp/services_conf.dart';
import 'package:http/http.dart' as http;
import 'models/perfil.dart';
import 'models/api_response.dart';

class PerfilService {
  static const API = Configuration.API;
  static var Token = "";

  Future<APIResponse<Perfil>> getPerfil({token}) {  
    var headers = {"Accept": "application/json"};
    if(token != null && token != ""){
      Token = token;
    }
    if(Token != null && Token != ""){
      headers["Authorization"] = "Token " + Token;
      print(headers.toString());
    }
    return http.get(API + "perfil/me", headers: headers).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        Token = json.decode(data.body)['token'];
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


  Future<APIResponse<String>> login(String username, String password) {
    return http
        .post(API + "perfil/login",
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({"username": username, "password": password}))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        String token = json.decode(data.body)['token'];
        Token = token;
        return APIResponse<String>(data: token);
      }
      return APIResponse<String>(
          error: true,
          errorMessage:
              "ERROR " + data.statusCode.toString() + ': An error occurred');
    }).catchError((_) => APIResponse<String>(
            error: true, errorMessage: 'An error occurred'));
  }
  

  void logout() {
    http.post(API + "perfil/logout",
            headers: {
              "Content-Type": "application/json",
            },);
  }
}


