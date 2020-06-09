import 'dart:convert';
import 'dart:io';

import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:eatapp/widgets/add_instruccion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../receta_services.dart';

class CrearPage extends StatefulWidget {
  const CrearPage(
      {Key key,
      bool loged,
      Function(bool) loginCallback,
      Function(int) pageIdCallback,
      Receta receta})
      : _isLoged = loged,
        _loginCallback = loginCallback,
        _pageIdCallback = pageIdCallback,
        _receta = receta,
        super(key: key);
  final bool _isLoged;
  final Function(bool) _loginCallback;
  final Function(int) _pageIdCallback;
  final Receta _receta;

  @override
  State<StatefulWidget> createState() {
    return _CrearState();
  }
}

class _CrearState extends State<CrearPage> {
  //bool get _isEditing => widget.recetaId != null;
  RecetasService get service => GetIt.I<RecetasService>();
  PerfilService get perfilService => GetIt.I<PerfilService>();
  bool get _isEditing => widget._receta != null;
  APIResponse<List<Ingrediente>> _apiResponse;
  APIResponse<List<Categoria>> _apiResponseCategoria;
  String errorMessage;
  Map<String, dynamic> formErrors;

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _prepController = TextEditingController();
  TextEditingController _personasController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();

  List<Ingrediente> _ingredientes;
  List<Instruccion> _instrucciones = [];
  List<Alergeno> _alergenos;
  List<Categoria> categorias;
  List<Choice> dietas = new List<Choice>();
  Choice dieta;
  Perfil perfil;
  Categoria categoriaSelected;
  Ingrediente ingredienteSelected;
  bool _isLoading = false;
  File _image;

  @override
  void initState() {
    _fetchDatos();
    dietas.add(Choice("Omnivora", "o"));
    dietas.add(Choice("Vegetariana", "v"));
    dietas.add(Choice("Vegana", "n"));
    _personasController.text = "1";
    formErrors = new Map<String, dynamic>();

    if (_isEditing) {
      _tituloController.text = widget._receta.titulo;
      _prepController.text = widget._receta.minutes.toString();
      _kcalController.text = widget._receta.kcal.toString();
      _descrController.text = widget._receta.descripcion;
      for (Choice d in dietas) {
        if (d.code == widget._receta.dieta) {
          dieta = d;
          break;
        }
      }
      categoriaSelected = widget._receta.categoria;
      _fetchIngredientes();
    }
    super.initState();
  }

  _fetchIngredientes() async {
    setState(() {
      _isLoading = true;
    });

    APIResponse<List<Instruccion>> _apiResponseInstrucciones;
    _apiResponseInstrucciones =
        await service.getInstruccionesReceta(widget._receta, _ingredientes);
    _instrucciones = _apiResponseInstrucciones.data;

    setState(() {
      _isLoading = false;
    });
  }

  _fetchDatos() async {
    setState(() {
      _isLoading = true;
    });

    APIResponse<List<Alergeno>> _apiResponseAlergeno;
    _apiResponseAlergeno = await service.getAlergenos();
    _alergenos = _apiResponseAlergeno.data;
    _apiResponse = await service.getIngredientes(_alergenos);
    _ingredientes = _apiResponse.data;
    ingredienteSelected = _ingredientes[0];
    _apiResponseCategoria = await service.getCategorias();
    categorias = _apiResponseCategoria.data;

    setState(() {
      _isLoading = false;
    });
  }

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _image = image;
    });
  }

  Future galleryImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = image;
    });
  }

  sendData() async {
    setState(() {
      _isLoading = true;
    });
    formErrors = new Map<String,dynamic>();
    perfil = await perfilService.getPerfil();
    int minute, kcal;
    if (_prepController.text == "") {
      minute = null;
    } else {
      minute = int.tryParse(_prepController.text ?? "20");
    }
    if (_kcalController.text == "") {
      kcal = null;
    } else {
      kcal = int.tryParse(_kcalController.text ?? "120");
    }
    final receta = Receta(
      titulo: _tituloController.text ?? "titulo",
      imgUrl: _image != null
          ? 'data:image/png;base64,' + base64Encode(_image.readAsBytesSync())
          : '',
      minutes: minute,
      kcal: kcal,
      descripcion: _descrController.text ?? "descripcion",
      categoria: categoriaSelected,
      autor_id: perfil.id,
      dieta: (dieta != null) ? dieta.code : null,
    );

    final result = await service.createReceta(receta);

    if (result.data != null) {
      Receta _receta = result.data;
      for (var item in _instrucciones) {
        item.receta = _receta;
        await service.createInstruccion(item);
      }

      final titulo = "Crear Receta";
      final text = result.error
          ? (result.errorMessage ?? "Ha ocurrido un error")
          : "La Receta ha sido publicada correctamente.";

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
        widget._pageIdCallback(1);
      });
    } else {
      formErrors = json.decode(result.errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  _addInstruccionCallBack(Instruccion i) {
    setState(() {
      _instrucciones.add(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox.expand(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: _image != null
                          ? DecorationImage(
                              image: new FileImage(_image),
                              fit: BoxFit.cover,
                            )
                          : null),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onTap: galleryImage,
                          ),
                          SizedBox(width: 70.0),
                          GestureDetector(
                            child: Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onTap: cameraImage,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0.0, 1.0),
                        blurRadius: 4.0,
                        spreadRadius: 5.0)
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        BackButton(
                          onPressed: () {
                            setState(() {
                              widget._pageIdCallback(0);
                            });
                          },
                        ),
                        Text(
                          "Añadir Detalles",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                        ),
                        RaisedButton(
                          onPressed: sendData,
                          textColor: Colors.white,
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 14.0),
                          child: Text('Compartir',
                              style: TextStyle(fontSize: 16.0)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Categoria:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          Expanded(
                            child: DropdownButton<Categoria>(
                              value: categoriaSelected,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              //style: TextStyle(color: Theme.of(context).accentColor),
                              underline: Container(
                                height: (formErrors != null &&
                                        formErrors["categoria"] != null)
                                    ? 1
                                    : 2,
                                color: (formErrors != null &&
                                        formErrors["categoria"] != null)
                                    ? Theme.of(context).errorColor
                                    : Theme.of(context).accentColor,
                              ),
                              onChanged: (newValue) {
                                setState(() => categoriaSelected = newValue);
                              },
                              items: categorias
                                  .map<DropdownMenuItem<Categoria>>(
                                      (Categoria value) {
                                return DropdownMenuItem<Categoria>(
                                  value: value,
                                  child: Text(value.titulo),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      (formErrors != null && formErrors["categoria"] != null)
                          ? SizedBox(height: 5.0)
                          : SizedBox.shrink(),
                      (formErrors != null && formErrors["categoria"] != null)
                          ? Text(
                              formErrors["categoria"][0],
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _tituloController,
                        maxLength: 100,
                        decoration: InputDecoration(
                          errorText: (formErrors != null &&
                                  formErrors["titulo"] != null)
                              ? formErrors["titulo"][0]
                              : null,
                          hintText: "Nombre del Plato",
                          isDense: true,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 14.0),
                        controller: _descrController,
                        maxLength: 500,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          errorText: (formErrors != null &&
                                  formErrors["descripcion"] != null)
                              ? formErrors["descripcion"][0]
                              : null,
                          isDense: true,
                          hintText: "Añade una descripción...",
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Dieta:",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40.0,
                          ),
                          Expanded(
                            child: DropdownButton<Choice>(
                              hint: Text("Dieta"),
                              value: dieta,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              //style: TextStyle(color: Theme.of(context).accentColor),
                              underline: Container(
                                height: (formErrors != null &&
                                        formErrors["dieta"] != null)
                                    ? 1
                                    : 2,
                                color: (formErrors != null &&
                                        formErrors["dieta"] != null)
                                    ? Theme.of(context).errorColor
                                    : Theme.of(context).accentColor,
                              ),
                              onChanged: (newValue) {
                                setState(() => dieta = newValue);
                              },
                              items: dietas.map<DropdownMenuItem<Choice>>(
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
                      (formErrors != null && formErrors["dieta"] != null)
                          ? SizedBox(height: 5.0)
                          : SizedBox.shrink(),
                      (formErrors != null && formErrors["dieta"] != null)
                          ? Text(
                              formErrors["dieta"][0],
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Ingredientes",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 20.0,
                            child: TextField(
                              controller: _personasController,
                              maxLength: 2,
                              style: TextStyle(fontSize: 20.0),
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "persona.",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: _instrucciones.length <= 0
                            ? 50.0
                            : _instrucciones.length * 60.0,
                        child: _instrucciones.length <= 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                child: Text("Ningún ingrediente Seleccionado."),
                              )
                            : ListView(
                                //physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(10.0),
                                children: _instrucciones.reversed.map((data) {
                                  return Dismissible(
                                    key: Key(data.id.toString()),
                                    child: InstruccionItem(
                                        icono:
                                            data.ingrediente.alergeno.iconoUrl,
                                        texto: data.cantidad +
                                            " de " +
                                            data.ingrediente.nombre),
                                  );
                                }).toList(),
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return InstruccionDialog(
                                    _addInstruccionCallBack);
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Icon(Icons.add),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Añadir un ingrediente."),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30.0,
                                child: TextField(
                                  controller: _prepController,
                                  maxLength: 3,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered
                                  decoration: InputDecoration(
                                    errorText: (formErrors != null &&
                                            formErrors["minutos_preparacion"] !=
                                                null)
                                        ? formErrors["minutos_preparacion"][0]
                                        : null,
                                    hintText: "000",
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "minutos.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              SizedBox(
                                width: 40.0,
                                child: TextField(
                                  controller: _kcalController,
                                  maxLength: 4,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered
                                  decoration: InputDecoration(
                                    errorText: (formErrors != null &&
                                            formErrors["kcal"] != null)
                                        ? formErrors["kcal"][0]
                                        : null,
                                    hintText: "0000",
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Kilocalorías.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}