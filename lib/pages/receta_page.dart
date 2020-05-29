import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../receta_services.dart';

class RecetaPage extends StatefulWidget {
  const RecetaPage({Key key, int recetaId})
      : _recetaId = recetaId,
        super(key: key);
  final int _recetaId;

  @override
  State<StatefulWidget> createState() {
    return _RecetaState();
  }
}

class _RecetaState extends State<RecetaPage> {
  //bool get _isEditing => widget.recetaId != null;
  RecetasService get service => GetIt.I<RecetasService>();
  PerfilService get perfilService => GetIt.I<PerfilService>();

  APIResponse<Receta> _apiResponseReceta;
  APIResponse<List<Ingrediente>> _apiResponse;
  APIResponse<List<Categoria>> _apiResponseCategoria;
  String errorMessage;
  String formErrors;

  //TextEditingController _tituloController = TextEditingController();
  TextEditingController _prepController = TextEditingController();
  TextEditingController _personasController = TextEditingController();
  TextEditingController _kcalController = TextEditingController();
  TextEditingController _descrController = TextEditingController();
  //TextEditingController _cantidadController = TextEditingController();

  List<Ingrediente> _ingredientes;
  List<Instruccion> _instrucciones = [];
  List<Alergeno> _alergenos;
  List<Categoria> categorias;
  Categoria categoriaSelected;
  Ingrediente ingredienteSelected;
  Receta receta;
  Perfil perfil;
  bool _isLoading = false;
  bool _favorito;

  @override
  void initState() {
    _fetchDatos();
    _personasController.text = "1";
    super.initState();
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

    _apiResponseReceta = await service.getRecetaDetalle(widget._recetaId);
    receta = _apiResponseReceta.data;

    _descrController.text = receta.descripcion;
    _prepController.text = receta.minutes.toString();
    _kcalController.text = receta.kcal.toString();
    perfil = await perfilService.getPerfil();

    _favorito = false;
    for(int f in perfil.favoritos){
      if(f == receta.id){
        _favorito = true;
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
                                  image: new NetworkImage(receta.imgUrl),
                                  fit: BoxFit.cover,
                                )
                              : null),
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
                                receta.titulo,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  if(_favorito){
                                    _favorito = false;
                                    perfil.favoritos.remove(receta.id);
                                  }
                                  else {
                                    _favorito = true;
                                    perfil.favoritos.add(receta.id);
                                  }
                                  receta.favorito = _favorito;
                                });
                                perfil = await perfilService.updatePerfil();
                              },
                              child: Icon(
                                  _favorito
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _favorito
                                      ? Colors.redAccent
                                      : Colors.grey,
                                  size: 32.0),
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
                                width: 10.0,
                              ),
                              GestureDetector(
                                  child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                child: Text(
                                  receta.categorias.first.titulo,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 50.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 30.0,
                                    child: TextField(
                                      controller: _prepController,
                                      maxLength: 3,
                                      readOnly: true,
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
                                      readOnly: true,
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
