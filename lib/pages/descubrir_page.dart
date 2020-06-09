import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/receta_services.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../perfil_services.dart';

class DescubrirPage extends StatefulWidget {
  const DescubrirPage(
      {Key key,
      bool loged,
      Function(bool) loginCallback,
      Function(int) pageIdCallback})
      : _isLoged = loged,
        _loginCallback = loginCallback,
        _pageIdCallback = pageIdCallback,
        super(key: key);
  final bool _isLoged;
  final Function(bool) _loginCallback;
  final Function(int) _pageIdCallback;

  @override
  State<StatefulWidget> createState() {
    return _DescubrirState();
  }
}

class _DescubrirState extends State<DescubrirPage> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  RecetasService get service => GetIt.I<RecetasService>();
  APIResponse<List<Receta>> _apiResponse;
  APIResponse<List<Categoria>> _apiResponseCategorias;
  ScrollController gridScrollController;
  List<Categoria> categorias;
  List<Receta> recetas;
  Categoria searchCategoria;
  String searchParams;
  bool _isLoading = false;
  bool _filterOpen = false;
  Perfil perfil;

  _scrollListener() {
    if (recetas.length <= 2) {
    } else {
      if (gridScrollController.offset <= 30) {
        _fetchRecetas();
        gridScrollController.animateTo(150,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
  }

  _openTopCardCallBack(bool open) {
    setState(() {
      _filterOpen = open;
    });
  }

  _setCategoriaCallback(Categoria categoria) {
    setState(() {
      searchCategoria = categoria;
      _fetchRecetas();
    });
  }

  _searchCallback(String params) async {
    searchParams = params;
    _apiResponse = await service.getRecetas(
        categorias: categorias,
        categoria: searchCategoria,
        search: searchParams);
    setState(() {
      recetas = _apiResponse.data;
      gridScrollController.animateTo(150,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  @override
  void initState() {
    _fetchRecetas();
    _fetchPerfil();
    super.initState();
    gridScrollController =
        new ScrollController(initialScrollOffset: 150, keepScrollOffset: true);
    gridScrollController.addListener(_scrollListener);
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });
    Perfil getperfil = await perfilService.getPerfil();
    setState(() {
      perfil = getperfil;
      _isLoading = false;
    });
  }

  _updatePerfilCallback() async {
    setState(() {
      _isLoading = true;
    });
    Perfil getperfil = await perfilService.updatePerfil();
    setState(() {
      perfil = getperfil;
      _isLoading = false;
    });
  }

  _fetchRecetas() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponseCategorias = await service.getCategorias();
    categorias = _apiResponseCategorias.data;
    _apiResponse = await service.getRecetas(
        categorias: categorias,
        categoria: searchCategoria,
        search: searchParams);
    recetas = _apiResponse.data;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    (_isLoading)
                        ? Expanded(
                            child: Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              width: double.maxFinite,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: _filterOpen ? 60.0 : 0.0),
                                child: Expanded(
                                  child: _RecetasGrid(
                                    recetas: recetas,
                                    controller: gridScrollController,
                                    refreshDataCallback: _fetchRecetas,
                                    perfil: perfil,
                                    updatePerfilCallback: _updatePerfilCallback,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                new TopCard(
                  openCallBack: _openTopCardCallBack,
                  setCategoriaCallBack: _setCategoriaCallback,
                  searchCallBack: _searchCallback,
                  categorias: categorias,
                ),
              ],
            ),
      //}
    );
    //);
  }
}

class TopCard extends StatefulWidget {
  TopCard(
      {this.openCallBack,
      this.setCategoriaCallBack,
      this.searchCallBack,
      this.categorias});
  final Function openCallBack;
  final Function setCategoriaCallBack;
  final Function searchCallBack;
  final List<Categoria> categorias;

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  bool open = false;
  bool search = false;
  int selectedIndex;
  TextEditingController _searchController;

  @override
  void initState() {
    selectedIndex = -1;
    _searchController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: open ? 180 : 115.0,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned.fill(
            child: Container(
              height: 100.0,
              padding: EdgeInsets.only(top: 50.0),
              alignment: Alignment.bottomCenter,
              color: Color(0xffECECEC),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.categorias.length,
                  itemBuilder: (BuildContext context, int index) {
                    Categoria categoria = widget.categorias[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 75.0,
                          bottom: 10.0,
                          left: (index == 0) ? 30.0 : 10.0,
                          right: (index == widget.categorias.length - 1)
                              ? 30.0
                              : 10.0),
                      child: OutlineButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        borderSide: BorderSide(
                          color: (index == selectedIndex)
                              ? Color(0xff48A299)
                              : Colors.grey,
                          width: (index == selectedIndex) ? 2.0 : 1.0,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                            widget
                                .setCategoriaCallBack(widget.categorias[index]);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          child: Text(
                            categoria.titulo,
                            style: TextStyle(
                                color: (index == selectedIndex)
                                    ? Color(0xff48A299)
                                    : Colors.grey,
                                fontWeight: (index == selectedIndex)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize:
                                    (index == selectedIndex) ? 16.0 : 14.0),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Container(
            height: 115.0,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30.0)),
              color: Colors.white,
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: (search)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (search)
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                                Text(
                                  "Explorar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40),
                                ),
                                Text("Por Platos y Lugares"),
                              ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (search) {
                                search = false;
                                widget.searchCallBack(null);
                                _searchController.text = null;
                              } else {
                                search = true;
                              }
                            });
                          },
                          child: Icon(
                            (search) ? Icons.close : Icons.search,
                            size: 28.0,
                          ),
                        ),
                        SizedBox(
                          width: (search) ? 10.0 : 5.0,
                        ),
                        (search)
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width - 120,
                                child: TextField(
                                  onChanged: (data) {
                                    widget.searchCallBack(data);
                                  },
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 30.0),
                                      hintText: "Buscar... ",
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(50.0),
                                        ),
                                      ),
                                      border: new OutlineInputBorder(
                                        gapPadding: 0.0,
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(50.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[300]),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          width: (search) ? 10.0 : 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (open) {
                              setState(() {
                                open = false;
                                widget.openCallBack(open);
                                widget.setCategoriaCallBack(null);
                                selectedIndex = -1;
                              });
                            } else {
                              setState(() {
                                open = true;
                                widget.openCallBack(open);
                              });
                            }
                          },
                          child: Icon(
                            open ? Icons.close : Icons.filter_list,
                            size: 28.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecetasGrid extends StatelessWidget {
  final List<Receta> recetas;
  final ScrollController controller;
  final Perfil perfil;
  final Function refreshDataCallback;
  final Function updatePerfilCallback;

  _RecetasGrid(
      {this.recetas,
      this.controller,
      this.refreshDataCallback,
      this.perfil,
      this.updatePerfilCallback});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.idle) {
          if (controller.offset < 150) {
            controller.animateTo(150,
                duration: Duration(milliseconds: 500), curve: Curves.linear);
          }
        }
      },
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        controller: controller,
        itemCount: recetas.length + 2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (3 / 4),
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index < 2) {
            return Container(
              height: 30,
              width: 30,
            );
          }
          Receta receta = recetas[index - 2];
          return RecetaTile(
            receta,
            h / 3,
            (w - 40) / 2,
            perfil,
            refreshDataCallback: refreshDataCallback,
          );
        },
      ),
    );
  }
}
