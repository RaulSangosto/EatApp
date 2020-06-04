import 'package:flutter/cupertino.dart';

class Receta {
  int id;
  int autor_id;
  String titulo;
  String imgUrl;
  int minutes;
  int kcal;
  String descripcion;
  String dieta;
  Categoria categoria;
  bool favorito = false;

  Receta(
      {this.id,
      this.autor_id,
      this.titulo,
      this.imgUrl,
      this.minutes,
      this.kcal,
      this.descripcion,
      this.dieta,
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
      autor_id: json['autor'],
      titulo: json['titulo'],
      imgUrl: json['imagen'],
      minutes: json['minutos_preparacion'],
      kcal: json['kcal'],
      descripcion: json['descripcion'],
      dieta: json['dieta'],
      categoria: _categoria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "autor": autor_id,
      "imagen": imgUrl,
      "minutos_preparacion": minutes,
      "kcal": kcal,
      "descripcion": descripcion,
      "dieta": dieta,
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

  factory Instruccion.fromJson(Map<String, dynamic> json, {@required Receta receta, @required List<Ingrediente> ingredientes}) {
    int _ingredienteID = json['ingrediente'];
    Ingrediente ingrediente;
    for(Ingrediente i in ingredientes){
      if(i.id == _ingredienteID){
        ingrediente = i;
      }
    }
    print(receta);
    Instruccion i = new Instruccion(
      id: json['id'],
      ingrediente: ingrediente,
      cantidad: json['cantidad'],
      receta: receta,
    );
    print(i);
    return i;
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
