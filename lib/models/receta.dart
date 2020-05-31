import 'package:flutter/cupertino.dart';

class Receta {
  int id;
  String titulo;
  String imgUrl;
  int minutes;
  int kcal;
  String descripcion;
  Categoria categoria;
  bool favorito = false;

  Receta(
      {this.id,
      this.titulo,
      this.imgUrl,
      this.minutes,
      this.kcal,
      this.descripcion,
      this.categoria});

  factory Receta.fromJson(Map<String, dynamic> json, {Categoria categoria, List<Categoria> categorias}) {
    int categoriaJson = json['categoria'];
    Categoria _categoria;
    List<Ingrediente> ingredientes = new List<Ingrediente>();

    if (categoria != null) {
      _categoria =categoria;
    } else {
        for(var c in categorias){
          if(categoriaJson == c.id){
            _categoria =c;
          }
        }
    }

    return Receta(
      id: json['id'],
      titulo: json['titulo'],
      imgUrl: json['imagen'],
      minutes: json['minutos_preparacion'],
      kcal: json['kcal'],
      descripcion: json['descripcion'],
      categoria: _categoria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "imagen": imgUrl,
      "minutes": minutes,
      "kcal": kcal,
      "descripcion": descripcion,
      "categoria": categoria.id,
    };
  }
}

class Instruccion {
  int id;
  Ingrediente ingrediente;
  String cantidad;
  Receta receta;

  Instruccion({this.id, this.ingrediente, this.cantidad, this.receta});

  factory Instruccion.fromJson(Map<String, dynamic> json) {
    return Instruccion(
      id: json['id'],
      ingrediente: json['ingrediente'],
      cantidad: json['cantidad'],
      receta: json['receta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ingrediente": ingrediente.id,
      "cantidad": cantidad,
      "receta": receta.id,
    };
  }
}

class Categoria {
  int id;
  String titulo;
  String imgUrl;
  String descripcion;

  Categoria({this.id, this.titulo, this.imgUrl, this.descripcion});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      titulo: json['titulo'],
      imgUrl: json['imagen'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "imagen": null,
      "descripcion": descripcion,
    };
  }
}

class Ingrediente {
  int id;
  String nombre;
  Alergeno alergeno;

  Ingrediente({this.id, this.nombre, this.alergeno});

  factory Ingrediente.fromJson(
      Map<String, dynamic> json, List<Alergeno> _alergenos) {
    Alergeno _alergeno;
    for (var al in _alergenos) {
      if (al.id == json['alergeno']) {
        _alergeno = al;
      }
    }

    return Ingrediente(
      id: json['id'],
      nombre: json['nombre'],
      alergeno: _alergeno,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "alergeno": alergeno.id,
    };
  }
}

class Alergeno {
  int id;
  String nombre;
  String iconoUrl;

  Alergeno({this.id, this.nombre, this.iconoUrl});

  factory Alergeno.fromJson(Map<String, dynamic> json) {
    return Alergeno(
      id: json['id'],
      nombre: json['nombre'],
      iconoUrl: json['icono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "icono": null,
    };
  }
}
