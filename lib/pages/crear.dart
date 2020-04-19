import 'dart:convert';
import 'dart:io';

import 'package:eatapp/models/receta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../receta_services.dart';

class Crear extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CrearState();
  }
}

class _CrearState extends State<Crear> {
  //bool get _isEditing => widget.recetaId != null;
  RecetasService get recetasService => GetIt.I<RecetasService>();
  String errorMessage;

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _prepController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  bool _isLoading = false;
  File _image;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _isLoading = true;
    // });
    //_fetchCategorias();
  }

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      //maxHeight: 240.0,
      //maxWidth: 240.0,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 30.0,
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Crear",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                        Text("Recetas"),
                      ]),
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 30.0,
                    child: Text(
                      "R",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  hintText: "Titulo",
                ),
              ),
              TextField(
                controller: _prepController,
                decoration: InputDecoration(
                  hintText: "Tiempo de preparación",
                ),
              ),
              TextField(
                controller: _kcalController,
                decoration: InputDecoration(
                  hintText: "KiloCalorias",
                ),
              ),
              TextField(
                controller: _descrController,
                decoration: InputDecoration(
                  hintText: "Descripción",
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.image),
                  GestureDetector(
                    child: Text(_image != null
                        ? "imagen seleccionada"
                        : "selecciona una imagen"),
                    onTap: cameraImage,
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 35.0,
                child: RaisedButton(
                  onPressed: () async {
                    //Navigator.of(cont      });ext).pop();
                    setState(() {
                      _isLoading = true;
                    });
                    final receta = Receta(
                      titulo: _tituloController.text ?? "titulo",
                      imgUrl: _image != null
                          ? 'data:image/png;base64,' +
                              base64Encode(_image.readAsBytesSync())
                          : '',
                      minutes: int.parse(_prepController.text ?? "20"),
                      kcal: int.parse(_kcalController.text ?? "120"),
                      descripcion: _descrController.text ?? "descripcion",
                      categorias: null,
                      ingredientes: null,
                    );
                    final result = await recetasService.createReceta(receta);

                    setState(() {
                      _isLoading = false;
                    });

                    final titulo = "Done";
                    final text = result.error
                        ? (result.errorMessage ?? "An error ocurred")
                        : "Your note was created";

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
                      // if (result.data) {
                      //   Navigator.of(context).pop();
                      // }
                    });
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(
                          "Enviar",
                          style: TextStyle(color: Colors.white),
                        ),
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
