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

  Future<APIResponse<Receta>> createReceta(Receta receta) {
    return http.post(API + "recetas", headers: {"Content-Type": "application/json",}, body: jsonEncode(receta.toJson()))
    .then((data) {
      print(data.statusCode);
      if(data.statusCode == 201) {
        return APIResponse<Receta>(data: Receta.fromJson(jsonDecode(data.body)));
      }
      return APIResponse<Receta>(data: null, error: true, errorMessage: "ERROR " + data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<Receta>(data: null, error: true, errorMessage: 'An error occurred'));

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

  Future<APIResponse<List<Ingrediente>>> getIngredientes(List<Alergeno> _alergenos){
    return http.get(API + "ingredientes", headers: {"Accept": "application/json"})
    .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final ingredientes = <Ingrediente>[];
        for(var item in jsonData) {
          ingredientes.add(Ingrediente.fromJson(item, _alergenos));
        }
        return APIResponse<List<Ingrediente>>(data: ingredientes);
      }
      return APIResponse<List<Ingrediente>>(error: true, errorMessage: data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<List<Ingrediente>>(error: true, errorMessage: 'An error occurred'));

  }

  Future<APIResponse<List<Alergeno>>> getAlergenos(){
    return http.get(API + "alergenos", headers: {"Accept": "application/json"})
    .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final alergenos = <Alergeno>[];
        for(var item in jsonData){
          alergenos.add(Alergeno.fromJson(item));
        }
        return APIResponse<List<Alergeno>>(data: alergenos);
      }
      return APIResponse<List<Alergeno>>(error: true, errorMessage: data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<List<Alergeno>>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> createInstruccion(Instruccion instruccion) {
    return http.post(API + "instrucciones", headers: {"Content-Type": "application/json",}, body: jsonEncode(instruccion.toJson()))
    .then((data) {
      print(data.statusCode);
      if(data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false, error: true, errorMessage: "ERROR " + data.statusCode.toString() + ': An error occurred');
    })
    .catchError((_) => APIResponse<bool>(data: false, error: true, errorMessage: 'An error occurred'));

  }
}