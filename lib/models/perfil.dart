import 'package:eatapp/models/receta.dart';

class Perfil {
  int id;
  String nombre, email, ubicacion, descripcion;
  String dieta, kcal_diarias, avatarUrl;
  DateTime fechaNac;
  String sexo;
  List<Receta> favoritos;

  Perfil(
      {this.id,
      this.nombre,
      this.email,
      this.ubicacion,
      this.descripcion,
      this.dieta,
      this.kcal_diarias,
      this.avatarUrl,
      this.fechaNac,
      this.sexo,
      this.favoritos,});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    List<dynamic> favoritos_json = json['favoritos'];
    List<Receta> favoritos = new List<Receta>();

    for (var fav in favoritos_json) {
      //categorias.add(Categoria.fromJson(cat));
      favoritos.add(new Receta(id: fav, titulo: "titulo", imgUrl: "", minutes: 0, kcal: 0, descripcion: "descripcion"));
    }

    return Perfil(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      dieta: json['dieta'],
      kcal_diarias: json['kcal_diarias'].toString(),
      avatarUrl: json['avatar'],
      fechaNac: DateTime.now(),//json['fecha_nacimiento'],
      sexo: json['sexo'],
      favoritos: favoritos,
    );
  }

  Map<String, dynamic> toJson() {
    List<int> favoritos_id = new List<int>();

    favoritos_id.add(1);
    // for (var cat in categorias) {
    //   categorias_id.add(cat.id);
    // }
    // for (var ing in ingredientes) {
    //   ingredientes_id.add(ing.id);
    // }
    return {
      "nombre": nombre,
      "email": email,
      "ubicacion": ubicacion,
      "descripcion": descripcion,
      "dieta": dieta,
      "kcal_diarias": kcal_diarias,
      "foto": avatarUrl,
      "fecha_nacimiento": fechaNac,
      "sexo": sexo,
      "favoritos": favoritos_id,
    };
  }
}