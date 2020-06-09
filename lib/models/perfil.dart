import 'package:eatapp/models/receta.dart';

class Choice {
  String nombre;
  String code;

  Choice(this.nombre, this.code);
}

class Perfil {
  int id;
  String nombre, email, ubicacion, descripcion;
  String dieta, kcalDiarias, avatarUrl, fondoUrl;
  DateTime fechaNac;
  String sexo;
  List<int> favoritos;
  int user;

  Perfil(
      {this.id,
      this.nombre,
      this.email,
      this.ubicacion,
      this.descripcion,
      this.dieta,
      this.kcalDiarias,
      this.avatarUrl,
      this.fondoUrl,
      this.fechaNac,
      this.sexo,
      this.favoritos,
      this.user});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    List<dynamic> favoritosJson = json['favoritos'];
    List<int> _favoritos = new List<int>();
    DateTime _fechaNac = DateTime.parse(json['fecha_nacimiento']);

    for (var fav in favoritosJson) {
      //categorias.add(Categoria.fromJson(cat));
      _favoritos.add(fav);
    }

    Perfil p = new Perfil(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      dieta: json['dieta'],
      kcalDiarias: json['kcal_diarias'].toString(),
      avatarUrl: json['foto'],
      fondoUrl: json['fotoBg'],
      fechaNac: DateTime(_fechaNac.year, _fechaNac.month, _fechaNac.day),
      sexo: json['sexo'],
      user: json['user'],
      favoritos: _favoritos,
    );
    return p;
  }

  Map<String, dynamic> toJson({patch=false}) {

    String fecha;
    if(fechaNac!=null){
      fecha = fechaNac.year.toString() + "-" + fechaNac.month.toString() + "-" + fechaNac.day.toString();
    }
    if (patch) {
      Map <String, dynamic> response = new Map<String, dynamic>();

      if(nombre != null){
        response["nombre"] = nombre;
      }
      if(email != null){
        response["email"] = email;
      }
      if(user != null){
        response["user"] = user;
      }
      if(ubicacion != null){
        response["ubicacion"] = ubicacion;
      }
      if(descripcion != null){
        response["descripcion"] = descripcion;
      }
      if(dieta != null){
        response["dieta"] = dieta;
      }
      if(kcalDiarias != null){
        response["kcal_diarias"] = kcalDiarias;
      }
      if(fecha != null){
        response["fecha_nacimiento"] = fecha;
      }
      if(sexo != null){
        response["sexo"] = sexo;
      }
      if(favoritos != null){
        response["favoritos"] = favoritos;
      }
      if(avatarUrl != null){
        response["foto"] = avatarUrl;
      }
      if(fondoUrl != null){
        response["fotoBg"] = fondoUrl;
      }

      return response;
    }

    return {
      "nombre": nombre,
      "email": email,
      "user": user,
      "ubicacion": ubicacion,
      "descripcion": descripcion,
      "dieta": dieta,
      "kcal_diarias": kcalDiarias,
      "fecha_nacimiento": fecha,
      "sexo": sexo,
      "favoritos": favoritos,
      "foto": avatarUrl,
      "fotoBg": fondoUrl,
    };
  }
}