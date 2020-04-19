import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/receta.dart';
import 'models/api_response.dart';

class RecetasService {
  static const port = '8000';
  static const localhost = '10.0.2.2:' + port;
  static const API = 'http://' + localhost + '/api/v1/';

  Future<APIResponse<List<Receta>>> getRecetas(){
    return http.get(API + "recetas", headers: {"Accept": "application/json"})
    .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final recetas = <Receta>[];
        for(var item in jsonData){
          recetas.add(Receta.fromJson(item));
        }
        return APIResponse<List<Receta>>(data: recetas);
      }
      return APIResponse<List<Receta>>(error: true, errorMessage: data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<List<Receta>>(error: true, errorMessage: 'An error occurred'));

  }

  Future<APIResponse<Receta>> getRecetaDetalle(int recetaId) {
    return http.get(API + "notas/" + recetaId.toString(), headers: {"Accept": "application/json"})
    .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);

          final receta = Receta.fromJson(jsonData);
        return APIResponse<Receta>(data: receta);
      }
      return APIResponse<Receta>(error: true, errorMessage: data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<Receta>(error: true, errorMessage: 'An error occurred'));

  }

  Future<APIResponse<bool>> createReceta(Receta receta) {
    return http.post(API + "recetas", headers: {"Content-Type": "application/json",}, body: jsonEncode(receta.toJson()))
    .then((data) {
      print(data.statusCode);
      if(data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false, error: true, errorMessage: "ERROR " + data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<bool>(data: false, error: true, errorMessage: 'An error occurred'));

  }

  Future<APIResponse<bool>> updateReceta(Receta receta) {
    return http.put(API + "notas/" + receta.id.toString(), headers: {"Content-Type": "application/json",}, body: jsonEncode(receta.toJson()))
    .then((data) {
      print(data.statusCode);
      if(data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false, error: true, errorMessage: "ERROR " + data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<bool>(data: false, error: true, errorMessage: 'An error occurred'));

  }

  Future<APIResponse<bool>> deleteReceta(int recetaId) {
    return http.put(API + "notas/" + recetaId.toString(), headers: {"Content-Type": "application/json",})
    .then((data) {
      print(data.statusCode);
      if(data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false, error: true, errorMessage: "ERROR " + data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<bool>(data: false, error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Categoria>>> getCategorias(){
    return http.get(API + "categorias", headers: {"Accept": "application/json"})
    .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final categorias = <Categoria>[];
        for(var item in jsonData){
          categorias.add(Categoria.fromJson(item));
        }
        return APIResponse<List<Categoria>>(data: categorias);
      }
      return APIResponse<List<Categoria>>(error: true, errorMessage: data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<List<Categoria>>(error: true, errorMessage: 'An error occurred'));
  }
}