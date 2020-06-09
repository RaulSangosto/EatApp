import 'dart:convert';
import 'package:eatapp/services_conf.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/receta.dart';
import 'models/api_response.dart';

class RecetasService {
  static const API = Configuration.API;

  Future<APIResponse<List<Receta>>> getRecetas(
      {Categoria categoria,String search ,@required List<Categoria> categorias}) {
    var uri;
    Map<String, String> headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    };
    Map<String, String> queryParameters = new Map<String, String>();
    if(categoria != null){
      queryParameters['categorias'] = categoria.id.toString();
    }
    if(search != null){
      queryParameters['search'] = search;
    }
    if (queryParameters.isEmpty) {
      uri =
          Uri.http(Configuration.localhost, Configuration.baseUrl + "recetas");
    } else {
      uri = Uri.http(Configuration.localhost, Configuration.baseUrl + "recetas",
          queryParameters);
    }
    return http.get(uri, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final recetas = <Receta>[];
        for (var item in jsonData) {
          recetas.add(Receta.fromJson(item, categorias: categorias));
        }
        return APIResponse<List<Receta>>(data: recetas);
      }
      return APIResponse<List<Receta>>(
          error: true,
          errorMessage: data.statusCode.toString() + ': An error occurred');
    }).catchError((_) => APIResponse<List<Receta>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Receta>>> getUltimasRecetas(
      {@required List<Categoria> categorias}) {
    var uri;
    Map<String, String> headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    };
    return http.get(API + "recetas/ultimas", headers: headers).then((data) {
      print("ultimas recetas: " + data.statusCode.toString());
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final recetas = <Receta>[];
        for (var item in jsonData) {
          recetas.add(Receta.fromJson(item, categorias: categorias));
        }
        return APIResponse<List<Receta>>(data: recetas);
      }
      return APIResponse<List<Receta>>(
          error: true,
          errorMessage: data.statusCode.toString() + ': An error occurred');
    }).catchError((_) => APIResponse<List<Receta>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Receta>> getRecetaDetalle(int recetaId, {categorias}) {
    return http.get(API + "recetas/" + recetaId.toString(), headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));

        final receta = Receta.fromJson(jsonData, categorias: categorias);
        return APIResponse<Receta>(data: receta);
      }
      return APIResponse<Receta>(
          error: true,
          errorMessage: data.statusCode.toString() + ': An error occurred');
    }).catchError((_) =>
        APIResponse<Receta>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Receta>> createReceta(Receta receta) {
    return http
        .post(API + "recetas",
            headers: {
              "Accept": "application/json; charset=UTF-8",
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(receta.toJson()))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 201) {
        return APIResponse<Receta>(
            data: Receta.fromJson(jsonDecode(utf8.decode(data.bodyBytes)),
                categoria: receta.categoria));
      }
      return APIResponse<Receta>(
          data: null,
          error: true,
          errorMessage:
              "ERROR " + data.statusCode.toString() + ': An error occurred');
    }).catchError((_) => APIResponse<Receta>(
            data: null, error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Receta>> updateReceta(Receta receta) {
    return http
        .patch(API + "recetas/" + receta.id.toString(),
            headers: {
              "Accept": "application/json; charset=UTF-8",
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(receta.toJson(patch: true)))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        return APIResponse<Receta>(data: Receta.fromJson(jsonDecode(utf8.decode(data.bodyBytes)),
                categoria: receta.categoria));
      }
      return APIResponse<Receta>(
          data: null,
          error: true,
          errorMessage:
              data.body);
    }).catchError((_) => APIResponse<Receta>(
            data: null, error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> deleteReceta(int recetaId) {
    return http.put(API + "recetas/" + recetaId.toString(), headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage:
              data.body);
    }).catchError((_) => APIResponse<bool>(
        data: false, error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Categoria>>> getCategorias() {
    return http.get(API + "categorias", headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final categorias = <Categoria>[];
        for (var item in jsonData) {
          categorias.add(Categoria.fromJson(item));
        }
        return APIResponse<List<Categoria>>(data: categorias);
      }
      return APIResponse<List<Categoria>>(
          error: true,
          errorMessage: data.body);
    }).catchError((_) => APIResponse<List<Categoria>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Categoria>> getCategoriaHoy(token) {
    return http.get(API + "categorias/categoria_hoy", headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "token " + token
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final Categoria categoria = Categoria.fromJson(jsonData);
        return APIResponse<Categoria>(data: categoria);
      }
      return APIResponse<Categoria>(
          error: true,
          errorMessage: data.body);
    }).catchError((_) =>
        APIResponse<Categoria>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Ingrediente>>> getIngredientes(
      List<Alergeno> _alergenos) {
    return http.get(API + "ingredientes", headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final ingredientes = <Ingrediente>[];
        for (var item in jsonData) {
          ingredientes.add(Ingrediente.fromJson(item, _alergenos));
        }
        return APIResponse<List<Ingrediente>>(data: ingredientes);
      }
      return APIResponse<List<Ingrediente>>(
          error: true,
          errorMessage: data.body);
    }).catchError((_) => APIResponse<List<Ingrediente>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Ingrediente>> createIngrediente(Ingrediente ingrediente, List<Alergeno> alergenos) {
    return http
        .post(API + "ingredientes",
            headers: {
              "Accept": "application/json; charset=UTF-8",
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(ingrediente.toJson()))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 201) {
        return APIResponse<Ingrediente>(
            data: Ingrediente.fromJson(jsonDecode(utf8.decode(data.bodyBytes)), alergenos));
      }
      return APIResponse<Ingrediente>(
          data: null,
          error: true,
          errorMessage:
              data.body);
    }).catchError((_) => APIResponse<Ingrediente>(
            data: null, error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Alergeno>>> getAlergenos() {
    return http.get(API + "alergenos", headers: {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final alergenos = <Alergeno>[];
        for (var item in jsonData) {
          alergenos.add(Alergeno.fromJson(item));
        }
        return APIResponse<List<Alergeno>>(data: alergenos);
      }
      return APIResponse<List<Alergeno>>(
          error: true,
          errorMessage: data.body);
    }).catchError((_) => APIResponse<List<Alergeno>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<List<Instruccion>>> getInstruccionesReceta(Receta receta, List<Ingrediente> ingredientes) {
    var uri;
    Map<String, String> headers = {
      "Accept": "application/json; charset=UTF-8",
      "Content-Type": "application/json; charset=UTF-8",
    };

    var queryParameters = {
      'receta': receta.id.toString(),
    };
    uri = Uri.http(Configuration.localhost, Configuration.baseUrl + "instrucciones",
        queryParameters);
    return http.get(uri, headers: headers).then((data) {
      if (data.statusCode == 200) {
        print(data.statusCode);
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        final instrucciones = <Instruccion>[];
        for (var item in jsonData) {
          instrucciones.add(Instruccion.fromJson(item, receta: receta, ingredientes: ingredientes));
        }
        return APIResponse<List<Instruccion>>(data: instrucciones);
      }
      return APIResponse<List<Instruccion>>(
          error: true,
          errorMessage: data.body);
    }).catchError((_) => APIResponse<List<Instruccion>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> createInstruccion(Instruccion instruccion) {
    return http
        .post(API + "instrucciones",
            headers: {
              "Accept": "application/json; charset=UTF-8",
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(instruccion.toJson()))
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage:
              data.body);
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occurred'));
  }
}
