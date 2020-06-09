import 'dart:convert';
import 'dart:io';

import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../perfil_services.dart';

class PerfilEditarPage extends StatefulWidget {
  const PerfilEditarPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<PerfilEditarPage> {
  PerfilService get service => GetIt.I<PerfilService>();
  Perfil perfil;
  bool _isLoading = false;
  String nombre, email, ubicacion, descripcion, kcalDiarias;
  String formErrors;
  List<Choice> dietas = new List<Choice>();
  Choice dieta;
  TextEditingController nombreController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController ubicacionController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController kcalDiariasController = new TextEditingController();
  File _imagePerfil;
  File _imageBg;

  @override
  initState() {
    super.initState();
    dietas.add(Choice("Omnivora", "o"));
    dietas.add(Choice("Vegetariana", "v"));
    dietas.add(Choice("Vegana", "n"));
    _fetchPerfil();
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });

    perfil = await service.getPerfil();

    nombre = perfil.nombre;
    email = perfil.email;
    ubicacion = perfil.ubicacion;
    descripcion = perfil.descripcion;

    for (Choice d in dietas) {
      if (d.code == perfil.dieta) {
        dieta = d;
      }
    }

    kcalDiarias = perfil.kcalDiarias;

    nombreController.text = nombre;
    emailController.text = email;
    ubicacionController.text = ubicacion;
    descripcionController.text = descripcion;
    kcalDiariasController.text = kcalDiarias;

    setState(() {
      _isLoading = false;
    });
  }

  Future cameraImageBg() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _imageBg = image;
    });
  }

  Future galleryImageBg() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageBg = image;
    });
  }

  Future cameraImagePerfil() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _imagePerfil = image;
    });
  }

  Future galleryImagePerfil() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imagePerfil = image;
    });
  }

  logout() async {
    print("logout");
    service.logout();
  }

  sendData() async {
    setState(() {
      _isLoading = true;
    });
    if (nombreController.text == null ||
        nombreController.text == "" ||
        emailController.text == null ||
        emailController.text == "") {
      formErrors = "Errores: ";
      if (nombreController.text == null || nombreController.text == "") {
        formErrors += "Debes Introducir un Nombre\n";
      }
      if (emailController.text == null || emailController.text == "") {
        formErrors += "Debes Indicar las Kilocalorías\n";
      }
    } else {
      formErrors = "";
      perfil.nombre = nombreController.text;
      perfil.email = emailController.text;
      perfil.ubicacion = ubicacionController.text;
      perfil.descripcion = descripcionController.text;
      perfil.kcalDiarias = kcalDiariasController.text;

      String _imgUrl = (_imagePerfil != null)
          ? 'data:image/png;base64,' +
              base64Encode(_imagePerfil.readAsBytesSync())
          : null;
      String _fondoUrl = (_imageBg != null)
          ? 'data:image/png;base64,' + base64Encode(_imageBg.readAsBytesSync())
          : null;

      perfil = await service.updatePerfil(
          imgUrl: _imgUrl,
          fondoUrl: _fondoUrl,
          nombre: perfil.nombre,
          ubicacion: perfil.ubicacion,
          descripcion: perfil.descripcion,
          kcal: perfil.kcalDiarias,
          dieta: dieta.code);

      if (perfil != null) {
        final titulo = "Se han modificado tus datos";
        final text = "Datos Actualizados correctamente.";

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(titulo),
                  content: Text(text),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"))
                  ],
                )).then((data) {
          Navigator.of(context).pop(perfil);
        });
      }
    }

    setState(() {
      print(perfil.fondoUrl);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading)
          ? Center(child: CircularProgressIndicator())
          : ListView(children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      blurRadius: 6.0, // has the effect of softening the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        3.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Stack(children: <Widget>[
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      image: (_imageBg != null)
                          ? new DecorationImage(
                              image: new FileImage(_imageBg),
                              fit: BoxFit.cover,
                            )
                          : (perfil.fondoUrl != null)
                              ? new DecorationImage(
                                  image: new NetworkImage(perfil.fondoUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          BackButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: cameraImageBg,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white70,
                                  size: 32.0,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              GestureDetector(
                                onTap: galleryImageBg,
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white70,
                                  size: 32.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Stack(
                              children: <Widget>[
                                new PerfilAvatar(40, file: _imagePerfil),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: cameraImagePerfil,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 170.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Nombre:",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: 200.0,
                                      height: 50.0,
                                      child: TextField(
                                        controller: nombreController,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                            hintText: "Nombre y Apellidos",
                                            isDense: true),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Email:",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextField(
                                              controller: emailController,
                                              maxLength: 100,
                                              decoration: InputDecoration(
                                                  hintText: "email@email.com",
                                                  isDense: true),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Ubicación:",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextField(
                                              controller: ubicacionController,
                                              maxLength: 100,
                                              decoration: InputDecoration(
                                                  hintText: "Región, País",
                                                  isDense: true),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  padding: EdgeInsets.only(
                                    bottom: 15.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Descripción:",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: descripcionController,
                                          maxLength: 500,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          minLines: 3,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText:
                                                "Añade una descripción...",
                                            hintStyle: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Dieta:",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 200.0,
                                            child: DropdownButton<Choice>(
                                              hint: Text("Dieta"),
                                              value: dieta,
                                              isExpanded: true,
                                              icon: Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              //style: TextStyle(color: Theme.of(context).accentColor),
                                              underline: Container(
                                                height: 2,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                              onChanged: (newValue) {
                                                setState(
                                                    () => dieta = newValue);
                                              },
                                              items: dietas.map<
                                                      DropdownMenuItem<Choice>>(
                                                  (Choice value) {
                                                return DropdownMenuItem<Choice>(
                                                  value: value,
                                                  child: Text(value.nombre),
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Kcal Diarías:",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 200.0,
                                            height: 50.0,
                                            child: TextField(
                                              controller: kcalDiariasController,
                                              maxLength: 100,
                                              decoration: InputDecoration(
                                                  hintText: "0000",
                                                  isDense: true),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Alergias",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 60.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          _CircleIcon(),
                                          _CircleIcon(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                formErrors == null || formErrors == ""
                                    ? SizedBox.shrink()
                                    : Text(formErrors,
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 30.0),
                                  child: RaisedButton(
                                    color: Theme.of(context).accentColor,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    onPressed: sendData,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Text(
                                        "Guardar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration:
            BoxDecoration(color: Color(0xffC5C5C5), shape: BoxShape.circle),
        child: Icon(
          Icons.fastfood,
          color: Colors.white,
          size: 15.0,
        ),
      ),
    );
  }
}
