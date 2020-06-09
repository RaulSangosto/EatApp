import 'dart:convert';
import 'dart:io';

import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../receta_services.dart';

class RecetaPage extends StatefulWidget {
  const RecetaPage({Key key, int recetaId, Function pageIdCallback})
      : _recetaId = recetaId,
        _pageIdCallback = pageIdCallback,
        super(key: key);

  final int _recetaId;
  final Function _pageIdCallback;

  @override
  State<StatefulWidget> createState() {
    return _RecetaState();
  }
}

class _RecetaState extends State<RecetaPage> {
  RecetasService get service => GetIt.I<RecetasService>();
  PerfilService get perfilService => GetIt.I<PerfilService>();

  APIResponse<Receta> _apiResponseReceta;
  APIResponse<List<Ingrediente>> _apiResponse;
  APIResponse<List<Categoria>> _apiResponseCategoria;
  APIResponse<List<Instruccion>> _apiResponseInstrucciones;
  String errorMessage;
  String formErrors;

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _prepController = TextEditingController();
  TextEditingController _personasController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();

  List<Ingrediente> _ingredientes;
  List<Instruccion> _instrucciones = [];
  List<Instruccion> _originalInstrucciones = [];
  List<Alergeno> _alergenos;
  List<Categoria> categorias;
  List<Choice> dietas = new List<Choice>();
  Choice dieta;
  File _image;
  Categoria categoriaSelected;
  Ingrediente ingredienteSelected;
  Receta receta;
  Perfil perfil;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _favorito;

  @override
  void initState() {
    dietas.add(Choice("Omnivora", "o"));
    dietas.add(Choice("Vegetariana", "v"));
    dietas.add(Choice("Vegana", "n"));
    _fetchDatos();
    _personasController.text = "1";
    super.initState();
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

  _addInstruccionCallBack(Instruccion i) {
    setState(() {
      _instrucciones.add(i);
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

    _apiResponseReceta = await service.getRecetaDetalle(widget._recetaId,
        categorias: categorias);
    receta = _apiResponseReceta.data;

    _tituloController.text = receta.titulo;
    _descrController.text = receta.descripcion;
    _prepController.text = receta.minutes.toString();
    _kcalController.text = receta.kcal.toString();
    categoriaSelected = receta.categoria;
    perfil = await perfilService.getPerfil();
    _apiResponseInstrucciones =
        await service.getInstruccionesReceta(receta, _ingredientes);
    _originalInstrucciones = _apiResponseInstrucciones.data;
    _instrucciones.clear();
    for (Instruccion i in _originalInstrucciones){
      _instrucciones.add(i);
    }

    _favorito = false;
    for (int f in perfil.favoritos) {
      if (f == receta.id) {
        _favorito = true;
      }
    }

    for (Choice d in dietas) {
      if (d.code == receta.dieta) {
        dieta = d;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  sendData() async {
    print("sendData");

    setState(() {
      _isLoading = true;
    });
    if (categoriaSelected == null ||
        _prepController.text == null ||
        _prepController.text == "" ||
        _kcalController.text == null ||
        _kcalController.text == "" ||
        _tituloController.text == null ||
        _tituloController.text == "" ||
        _descrController.text == null ||
        _descrController.text == "" ||
        dieta == null ||
        _instrucciones.length <= 0) {
      formErrors = "Errores: ";
      if (categoriaSelected == null) {
        formErrors += "Debes Seleccionar una Categoria\n";
      }
      if (_prepController.text == null || _prepController.text == "") {
        formErrors += "Debes Indicar un Tiempo de Preparacion\n";
      }
      if (_kcalController.text == null || _kcalController.text == "") {
        formErrors += "Debes Indicar las Kilocalorías\n";
      }
      if (_tituloController.text == null || _tituloController.text == "") {
        formErrors += "Debes Indicar un Título\n";
      }
      if (_descrController.text == null || _descrController.text == "") {
        formErrors += "Debes Indicar una Descripción\n";
      }
      if (dieta == null) {
        formErrors += "Debes seleccionar una Dieta\n";
      }
      if (_instrucciones.length <= 0) {
        formErrors += "Debes Añadir algún Ingrediente\n";
      }
    } else {
      if(_image!=null){
        print('data:image/png;base64,' + base64Encode(_image.readAsBytesSync()));
      }
      formErrors = "";
      final _receta = Receta(
        titulo: _tituloController.text ?? "titulo",
        imgUrl: _image != null
            ? 'data:image/png;base64,' + base64Encode(_image.readAsBytesSync())
            : null,
        minutes: int.parse(_prepController.text ?? "20"),
        kcal: int.parse(_kcalController.text ?? "120"),
        descripcion: _descrController.text ?? "descripcion",
        categoria: categoriaSelected,
        autor_id: perfil.id,
        dieta: dieta.code,
        id: widget._recetaId,
      );

      final result = await service.updateReceta(_receta);

      if (result.data != null) {
        Receta _newReceta = result.data;

        for (var item in _instrucciones) {
          bool exist = false;
          for (var oitem in _originalInstrucciones){
            if (item.id == oitem.id) {
              exist = true;
            }
          }
          if(!exist){
            item.receta = _newReceta;
          print(item.receta);
          await service.createInstruccion(item);
          }
        }

        final titulo = "Modificar Receta";
        final text = result.error
            ? (result.errorMessage ?? "Ha ocurrido un error")
            : "la Receta se ha modificado correctamente";

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
          setState(() {
            _isEditing = false;
            _fetchDatos();
          });
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
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
                          image: receta.imgUrl != null
                              ? DecorationImage(
                                  image: (_isEditing && _image != null)
                                      ? new FileImage(_image)
                                      : new NetworkImage(receta.imgUrl),
                                  fit: BoxFit.cover,
                                )
                              : null),
                      child: _isEditing
                          ? Container(
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
                            )
                          : null,
                    ),
                    Container(
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0,
                            spreadRadius: 5.0)
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            BackButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                _isEditing ? "Modificar Receta" : receta.titulo,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            (receta.autor_id == perfil.id)
                                ? _isEditing
                                    ? RaisedButton(
                                        onPressed: sendData,
                                        textColor: Colors.white,
                                        color: Theme.of(context).accentColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 14.0),
                                        child: Text('Guardar Cambios',
                                            style: TextStyle(fontSize: 16.0)),
                                      )
                                    : OutlineButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color(0xff48A299),
                                        ),
                                        onPressed: () {
                                          print(perfil.id);
                                          setState(() {
                                            _isEditing = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 0),
                                          child: Text(
                                            "Editar",
                                            style: TextStyle(
                                                color: Color(0xff48A299)),
                                          ),
                                        ),
                                      )
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        if (_favorito) {
                                          _favorito = false;
                                          perfil.favoritos.remove(receta.id);
                                        } else {
                                          _favorito = true;
                                          perfil.favoritos.add(receta.id);
                                        }
                                        receta.favorito = _favorito;
                                      });
                                      perfil =
                                          await perfilService.updatePerfil();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                          _favorito
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: _favorito
                                              ? Colors.redAccent
                                              : Colors.grey,
                                          size: 32.0),
                                    ),
                                  )
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                width: _isEditing ? 40.0 : 10.0,
                              ),
                              _isEditing
                                  ? Expanded(
                                      child: DropdownButton<Categoria>(
                                        value: categoriaSelected,
                                        icon: Icon(Icons.arrow_downward),
                                        isExpanded: true,
                                        iconSize: 24,
                                        elevation: 16,
                                        //style: TextStyle(color: Theme.of(context).accentColor),
                                        underline: Container(
                                          height: 2,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() =>
                                              categoriaSelected = newValue);
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
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      child: Text(
                                        receta.categoria.titulo,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          _isEditing
                              ? TextField(
                                  controller: _tituloController,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    hintText: "Nombre del Plato",
                                    isDense: true,
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _isEditing
                              ? TextField(
                                  style: TextStyle(fontSize: 14.0),
                                  controller: _descrController,
                                  maxLength: 500,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 3,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Añade una descripción...",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                )
                              : ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    minHeight: 50.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          receta.descripcion,
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Dieta",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: _isEditing ? 40.0 : 5.0,
                              ),
                              _isEditing
                                  ? Expanded(
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
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() => dieta = newValue);
                                        },
                                        items: dietas
                                            .map<DropdownMenuItem<Choice>>(
                                                (Choice value) {
                                          return DropdownMenuItem<Choice>(
                                            value: value,
                                            child: Text(value.nombre),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Text((dieta != null)
                                      ? dieta.nombre
                                      : "No Disponible"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Ingredientes",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
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
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
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
                                    child: Text(
                                        "Ningún ingrediente Seleccionado."),
                                  )
                                : ListView(
                                    //physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(10.0),
                                    children:
                                        _instrucciones.reversed.map((data) {
                                      return InstruccionItem(
                                          icono: data
                                              .ingrediente.alergeno.iconoUrl,
                                          texto: data.cantidad +
                                              " de " +
                                              data.ingrediente.nombre);
                                    }).toList(),
                                  ),
                          ),
                          _isEditing
                              ? GestureDetector(
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
                                            borderRadius:
                                                BorderRadius.circular(25.0),
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
                                )
                              : SizedBox.shrink(),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 30.0,
                                    child: TextField(
                                      controller: _prepController,
                                      maxLength: 3,
                                      readOnly: !_isEditing,
                                      decoration: InputDecoration(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                    child: TextField(
                                      controller: _kcalController,
                                      maxLength: 4,
                                      readOnly: !_isEditing,
                                      decoration: InputDecoration(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
              ),
      ),
    );
  }
}

class InstruccionItem extends StatelessWidget {
  final String icono;
  final String texto;

  const InstruccionItem({Key key, this.icono, this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.network(icono),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(texto),
        ],
      ),
    );
  }
}

class InstruccionDialog extends StatefulWidget {
  InstruccionDialog(this.addInstruccionCallBack, {Key key}) : super(key: key);
  final Function addInstruccionCallBack;

  @override
  _InstruccionDialogState createState() => _InstruccionDialogState();
}

class _InstruccionDialogState extends State<InstruccionDialog> {
  RecetasService get service => GetIt.I<RecetasService>();
  APIResponse<List<Ingrediente>> _apiResponse;
  Instruccion _instruccion;
  List<Instruccion> _instrucciones = [];
  List<Alergeno> _alergenos;
  Alergeno alergenoSelected;
  Ingrediente ingredienteSelected;
  List<Ingrediente> _ingredientes;
  List<Ingrediente> _filteredIngredientes;
  TextEditingController _cantidadController = TextEditingController();
  TextEditingController _filterController = TextEditingController();
  TextEditingController _nombreIngredienteController = TextEditingController();
  String contentText = "Añadir Instrucción";
  String formErrors = "";
  bool _isLoading = false;
  bool addIngrediente = false;

  @override
  void initState() {
    _fetchIngredientes();
    super.initState();
  }

  _isSelected(int index) {
    if (ingredienteSelected == null) {
      return false;
    }
    return ingredienteSelected.id == _filteredIngredientes[index].id;
  }

  _searchFilter(data) {
    print("filter: " + data);
    setState(() {
      if (data != null) {
        _filteredIngredientes = _ingredientes
            .where((i) => i.nombre
                .toLowerCase()
                .contains(_filterController.text.toLowerCase()))
            .toList();
        print(_filteredIngredientes.length);
      } else {
        _filteredIngredientes = _ingredientes;
      }
    });
  }

  _fetchIngredientes() async {
    setState(() {
      _isLoading = true;
    });

    APIResponse<List<Alergeno>> _apiResponseAlergeno;
    _apiResponseAlergeno = await service.getAlergenos();
    _alergenos = _apiResponseAlergeno.data;
    _apiResponse = await service.getIngredientes(_alergenos);
    _ingredientes = _apiResponse.data;
    _filteredIngredientes = _ingredientes;

    setState(() {
      _isLoading = false;
    });
  }

  _addIngrediente() async {
    Ingrediente newIngrediente;
    setState(() {
      formErrors = "";
      if (alergenoSelected == null) {
        formErrors += "Debes seleccionar un Alergeno.";
      }
      if (_nombreIngredienteController.text == "" ||
          _nombreIngredienteController.text == null) {
        formErrors += "Debes indicar un Nombre.";
      }
    });
    if (formErrors == "") {
      _isLoading = true;
      newIngrediente = new Ingrediente(
          alergeno: alergenoSelected,
          nombre: _nombreIngredienteController.text);
      APIResponse<Ingrediente> _apiResponseNewIngrediente =
          await service.createIngrediente(newIngrediente, _alergenos);
      newIngrediente == _apiResponseNewIngrediente.data;
    }
    setState(() {
      if (newIngrediente != null) {
        ingredienteSelected = newIngrediente;
      }
      _isLoading = false;
      _fetchIngredientes();
      addIngrediente = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Text(contentText),
            content: Container(
              width: double.maxFinite,
              child: addIngrediente
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("Crear un Nuevo Ingrediente."),
                        SizedBox(
                          height: 30.0,
                        ),
                        DropdownButton<Alergeno>(
                          hint: Text("Alergeno..."),
                          isExpanded: true,
                          value: alergenoSelected,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          //style: TextStyle(color: Theme.of(context).accentColor),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).accentColor,
                          ),
                          onChanged: (Alergeno newValue) {
                            setState(() {
                              alergenoSelected = newValue;
                            });
                          },
                          items: _alergenos.map<DropdownMenuItem<Alergeno>>(
                              (Alergeno value) {
                            return DropdownMenuItem<Alergeno>(
                              value: value,
                              child: Text(value.nombre),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          controller: _nombreIngredienteController,
                          decoration:
                              InputDecoration(hintText: "Nombre Ingrediente"),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        RaisedButton(
                          onPressed: _addIngrediente,
                          textColor: Colors.white,
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 14.0),
                          child: Text('Crear Ingrediente',
                              style: TextStyle(fontSize: 16.0)),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: _filterController,
                          onChanged: (data) {
                            _searchFilter(data);
                          },
                          decoration: InputDecoration(
                              hintText: "Nombre de Ingrediente..."),
                        ),
                        (_filteredIngredientes.length > 0)
                            ? SizedBox.shrink()
                            : Expanded(
                                child: Text(
                                    "No se han encontrado Ingredientes. Puedes añadir un nuevo Ingrediente")),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredIngredientes.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= _filteredIngredientes.length) {
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    "Añadir Nuevo Ingrediente",
                                  ),
                                  leading: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      //Crear Ingrediente;
                                      addIngrediente = true;
                                    });
                                  },
                                );
                              }
                              return ListTile(
                                dense: true,
                                title: Text(_filteredIngredientes[index].nombre,
                                    style: TextStyle(
                                        fontWeight: (_isSelected(index))
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: _isSelected(index)
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .color)),
                                onTap: () {
                                  setState(() {
                                    ingredienteSelected =
                                        _filteredIngredientes[index];
                                    _filterController.text =
                                        ingredienteSelected.nombre;
                                    _searchFilter(ingredienteSelected.nombre);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        // DropdownButton<Ingrediente>(
                        //   isExpanded: true,
                        //   value: ingredienteSelected,
                        //   icon: Icon(Icons.arrow_downward),
                        //   iconSize: 24,
                        //   elevation: 16,
                        //   //style: TextStyle(color: Theme.of(context).accentColor),
                        //   underline: Container(
                        //     height: 2,
                        //     color: Theme.of(context).accentColor,
                        //   ),
                        //   onChanged: (Ingrediente newValue) {
                        //     setState(() {
                        //       ingredienteSelected = newValue;
                        //     });
                        //   },
                        //   items: _ingredientes.map<DropdownMenuItem<Ingrediente>>(
                        //       (Ingrediente value) {
                        //     return DropdownMenuItem<Ingrediente>(
                        //       value: value,
                        //       child: Text(value.nombre),
                        //     );
                        //   }).toList(),
                        // ),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _cantidadController,
                            maxLength: 100,
                            decoration: InputDecoration(
                              hintText: "Cantidad",
                              isDense: true,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Añadir"),
                onPressed: () {
                  _instruccion = new Instruccion(
                      ingrediente: ingredienteSelected,
                      cantidad: _cantidadController.text);
                  setState(() {
                    widget.addInstruccionCallBack(_instruccion);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}
