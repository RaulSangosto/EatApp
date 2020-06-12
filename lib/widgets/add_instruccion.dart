import 'dart:convert';

import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/receta_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  Map<String, dynamic> formErrors;
  bool _isLoading = false;
  bool addIngrediente = false;

  @override
  void initState() {
    _fetchIngredientes();
    formErrors = new Map<String, dynamic>();
    super.initState();
  }

  _isSelected(int index) {
    if (ingredienteSelected == null) {
      return false;
    }
    return ingredienteSelected.id == _filteredIngredientes[index].id;
  }

  _searchFilter(data) {
    setState(() {
      if (data != null) {
        _filteredIngredientes = _ingredientes
            .where((i) => i.nombre
                .toLowerCase()
                .contains(_filterController.text.toLowerCase()))
            .toList();
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
      _isLoading = true;
    });
    formErrors = new Map<String, dynamic>();
    if (alergenoSelected == null) {
      formErrors["alergeno"] = ["Debes seleccionar un alergeno."];
    }
    if (_nombreIngredienteController.text == null ||
        _nombreIngredienteController.text == "") {
      formErrors["nombre"] = ["Debes indicar un nombre para el ingrediente."];
    }
    if (formErrors.isEmpty) {
      newIngrediente = new Ingrediente(
          alergeno: alergenoSelected,
          nombre: _nombreIngredienteController.text);
      APIResponse<Ingrediente> _apiResponseNewIngrediente =
          await service.createIngrediente(newIngrediente, _alergenos);
      if (_apiResponseNewIngrediente.data != null) {
        newIngrediente = _apiResponseNewIngrediente.data;
      } else {
        formErrors = json.decode(_apiResponseNewIngrediente.errorMessage);
      }
    }

    setState(() {
      if (newIngrediente != null) {
        ingredienteSelected = newIngrediente;
        _fetchIngredientes();
        addIngrediente = false;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Text(addIngrediente
                ? "Crear un Nuevo Ingrediente"
                : "Añadir Instrucción"),
            content: Container(
              width: double.maxFinite,
              child: addIngrediente
                  ? Column(
                      children: <Widget>[
                        DropdownButton<Alergeno>(
                          hint: Text("Alergeno..."),
                          isExpanded: true,
                          value: alergenoSelected,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          //style: TextStyle(color: Theme.of(context).accentColor),
                          underline: Container(
                            height: (formErrors != null &&
                                    formErrors["alergeno"] != null)
                                ? 1
                                : 2,
                            color: (formErrors != null &&
                                    formErrors["alergeno"] != null)
                                ? Theme.of(context).errorColor
                                : Theme.of(context).accentColor,
                          ),
                          onChanged: (Alergeno newValue) {
                            setState(() {
                              alergenoSelected = newValue;
                            });
                          },
                          items: _alergenos.map<DropdownMenuItem<Alergeno>>(
                              (Alergeno value) {
                            return DropdownMenuItem<Alergeno>(
                              key: UniqueKey(),
                              value: value,
                              child: Text(value.nombre),
                            );
                          }).toList(),
                        ),
                        (formErrors != null && formErrors["alergeno"] != null)
                            ? SizedBox(height: 5.0)
                            : SizedBox.shrink(),
                        (formErrors != null && formErrors["alergeno"] != null)
                            ? Row(
                                children: [
                                  Text(
                                    formErrors["alergeno"][0],
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          controller: _nombreIngredienteController,
                          decoration: InputDecoration(
                            hintText: "Nombre Ingrediente",
                            errorText: (formErrors != null &&
                                    formErrors["nombre"] != null)
                                ? formErrors["nombre"][0]
                                : null,
                          ),
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
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _cantidadController,
                            maxLength: 100,
                            decoration: InputDecoration(
                              errorText: (formErrors != null &&
                                      formErrors["cantidad"] != null)
                                  ? formErrors["cantidad"][0]
                                  : null,
                              hintText: "Cantidad",
                              isDense: true,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            actions: <Widget>[
              addIngrediente
                  ? FlatButton(
                      onPressed: _addIngrediente,
                      child: Text('Crear Ingrediente'),
                    )
                  : FlatButton(
                      child: Text("Añadir"),
                      onPressed: () {
                        formErrors = new Map<String, dynamic>();
                        if (ingredienteSelected == null) {
                          formErrors["ingrediente"] = [
                            "Debes seleccionar un Ingrediente"
                          ];
                        }
                        if (_cantidadController.text == null ||
                            _cantidadController.text == "") {
                          formErrors["cantidad"] = [
                            "Debes indicar una cantidad"
                          ];
                        }
                        if (formErrors.isEmpty) {
                          _instruccion = new Instruccion(
                              ingrediente: ingredienteSelected,
                              cantidad: _cantidadController.text);
                          setState(() {
                            widget.addInstruccionCallBack(_instruccion);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                    ),
            ],
          );
  }
}
