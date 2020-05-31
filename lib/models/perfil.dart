import 'package:eatapp/models/receta.dart';

class Choice {
  String nombre;
  String code;

  Choice(this.nombre, this.code);
}

class Perfil {
  int id;
  String nombre, email, ubicacion, descripcion;
  String dieta, kcalDiarias, avatarUrl;
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

    return Perfil(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      dieta: json['dieta'],
      kcalDiarias: json['kcal_diarias'].toString(),
      avatarUrl: json['foto'],
      fechaNac: DateTime(_fechaNac.year, _fechaNac.month, _fechaNac.day),
      sexo: json['sexo'],
      user: json['user'],
      favoritos: _favoritos,
    );
  }

  Map<String, dynamic> toJson() {
    String fecha = fechaNac.year.toString() + "-" + fechaNac.month.toString() + "-" + fechaNac.day.toString();
    var response = {
      "nombre": nombre,
      "email": email,
      "user": user,
      "ubicacion": ubicacion,
      "descripcion": descripcion,
      "dieta": dieta,
      "kcalDiarias": kcalDiarias,
      "fecha_nacimiento": fecha,
      "sexo": sexo,
      "favoritos": favoritos,
    };

    if(avatarUrl != null){
      response["foto"] = avatarUrl;
    }

    return response;
  }
}