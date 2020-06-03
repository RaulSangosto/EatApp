import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/receta_services.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

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
  RecetasService get service => GetIt.I<RecetasService>();
  APIResponse<List<Receta>> _apiResponse;
  APIResponse<List<Categoria>> _apiResponseCategorias;
  ScrollController gridScrollController;
  List<Categoria> categorias;
  List<Receta> recetas;
  bool _isLoading = false;
  bool _filterOpen = false;

  _scrollListener() {
    if (gridScrollController.offset <= 80) {
      _fetchRecetas();
      gridScrollController.animateTo(150,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  _openTopCardCallBack(bool open) {
    setState(() {
      _filterOpen = open;
    });
  }

  @override
  void initState() {
    _fetchRecetas();
    super.initState();
    gridScrollController =
        new ScrollController(initialScrollOffset: 150, keepScrollOffset: true);
    gridScrollController.addListener(_scrollListener);
  }

  _fetchRecetas() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponseCategorias = await service.getCategorias();
    categorias = _apiResponseCategorias.data;
    _apiResponse = await service.getRecetas(categorias: categorias);
    recetas = _apiResponse.data;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              (_isLoading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: _filterOpen ? 60.0 : 0.0),
                        child: SizedBox(
                          height: 472.0,
                          child: _RecetasGrid(
                              recetas: recetas,
                              controller: gridScrollController),
                        ),
                      ),
                    ),
            ],
          ),
          new TopCard(
            openCallBack: _openTopCardCallBack,
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
  TopCard({this.openCallBack, this.categorias});
  Function openCallBack;
  List<Categoria> categorias;
  

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  bool open = false;
  int selectedIndex;

  @override
  void initState() {
    print(widget.categorias.length);
    selectedIndex = -1;
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
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30.0)),
                color: Colors.grey,
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
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.categorias.length,
                  itemBuilder: (BuildContext context, int index) {
                    Categoria categoria = widget.categorias[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex =index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 90.0, left: 10.0, right: 10.0),
                        child: Text(
                          categoria.titulo,
                          style: TextStyle(color: (index == selectedIndex) ? Theme.of(context).accentColor : Colors.white),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Explorar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                          Text("Por Platos y Lugares"),
                        ]),
                    SizedBox(
                      width: 70.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 28.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                open = !open;
                                widget.openCallBack(open);
                              });
                            },
                            child: Icon(
                              open ? Icons.close : Icons.filter_list,
                              size: 28.0,
                            ),
                          ),
                        ],
                      ),
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

  _RecetasGrid({this.recetas, this.controller});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return GridView.builder(
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
        return RecetaTile(receta, h / 3, (w - 40) / 2);
      },
    );
  }
}
