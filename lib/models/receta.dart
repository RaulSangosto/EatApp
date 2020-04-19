class Receta {
  int id;
  String titulo;
  String imgUrl;
  int minutes;
  int kcal;
  String descripcion;
  List<Categoria> categorias;
  List<Ingrediente> ingredientes;

  Receta(
      {this.id,
      this.titulo,
      this.imgUrl,
      this.minutes,
      this.kcal,
      this.descripcion,
      this.categorias,
      this.ingredientes});

  factory Receta.fromJson(Map<String, dynamic> json) {
    List<dynamic> categorias_json = json['categorias'];
    List<dynamic> ingredientes_json = json['ingredientes'];
    List<Categoria> categorias = new List<Categoria>();
    List<Ingrediente> ingredientes = new List<Ingrediente>();

    for (var cat in categorias_json) {
      //categorias.add(Categoria.fromJson(cat));
      categorias.add(new Categoria(id: cat, titulo: "titulo", imgUrl: "", descripcion: "descripcion"));
    }

    for (var ing in ingredientes_json) {
      //ingredientes.add(Ingrediente.fromJson(ing));
      ingredientes.add(new Ingrediente(id: ing, nombre: "nombre", alergeno: new Alergeno(id: 0, nombre: "nombre", iconoUrl: "")));
    }

    return Receta(
      id: json['id'],
      titulo: json['titulo'],
      imgUrl: json['imagen'],
      minutes: json['minutos_preparacion'],
      kcal: json['kcal'],
      descripcion: json['descripcion'],
      categorias: categorias,
      ingredientes: ingredientes,
    );
  }

  Map<String, dynamic> toJson() {
    List<int> categorias_id = new List<int>();
    List<int> ingredientes_id = new List<int>();

    categorias_id.add(1);
    ingredientes_id.add(1);
    // for (var cat in categorias) {
    //   categorias_id.add(cat.id);
    // }
    // for (var ing in ingredientes) {
    //   ingredientes_id.add(ing.id);
    // }
    return {
      "titulo": titulo,
      "imagen": imgUrl,
      "minutes": minutes,
      "kcal": kcal,
      "descripcion": descripcion,
      "categorias": categorias_id,
      "ingredientes": ingredientes_id,
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

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      id: json['id'],
      nombre: json['nombre'],
      alergeno: Alergeno.fromJson(json['alergeno']),
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
