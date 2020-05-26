import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/receta.dart';
import 'package:eatapp/receta_services.dart';
import 'package:eatapp/widgets/receta_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

class Descubrir_Page extends StatefulWidget {
  const Descubrir_Page({Key key, bool loged, Function(bool) login_callback, Function(int) pageId_callback})
      : _isLoged = loged,
        _login_callback = login_callback,
        _pageId_callback = pageId_callback,
        super(key: key);
  final bool _isLoged;
  final Function(bool) _login_callback;
  final Function(int) _pageId_callback;

  @override
  State<StatefulWidget> createState() {
    return _DescubrirState();
  }
}

class _DescubrirState extends State<Descubrir_Page> {
  RecetasService get service => GetIt.I<RecetasService>();
  APIResponse<List<Receta>> _apiResponse;
  List<Receta> recetas;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchRecetas();
    super.initState();
  }

  _fetchRecetas() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getRecetas();
    recetas = _apiResponse.data;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (_) {
        if (_isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (_apiResponse.error) {
          return Center(child: Text(_apiResponse.errorMessage));
        }

        return Stack(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 472.0,
                    child: _RecetasGrid(recetas: recetas),
                  ),
                ),
              ],
            ),
            _TopCard(),
          ],
        );
      }),
    );
  }
}

class _TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
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
                    Icon(
                      Icons.list,
                      size: 28.0,
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

class _RecetasGrid extends StatelessWidget {
  List<Receta> recetas;

  _RecetasGrid({this.recetas});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: recetas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (2 / 3),
      ),
      itemBuilder: (BuildContext context, int index) {
        Receta receta = recetas[index];
        return RecetaTile(receta, h / 3, (w - 40) / 2);
      },
    );
  }
}

// class _RecetasTile extends StatelessWidget {
//   _RecetasTile(this.receta);

//   final Receta receta;

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     return Container(
//       height: h / 3,
//       width: (w - 40) / 2,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         color: Colors.blueGrey,
//         image: new DecorationImage(
//           image: new NetworkImage(receta.imgUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Icon(Icons.favorite, color: Colors.redAccent),
//             Text(
//               receta.titulo,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _RecetasGrid extends StatelessWidget {
//    @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: new StaggeredGridView.countBuilder(
//         scrollDirection: Axis.vertical,
//         crossAxisCount: 4,
//         itemCount: 20,
//         itemBuilder: (BuildContext context, int index) => new Container(
//             color: Colors.green,
//             child: new Center(
//               child: new CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: new Text('$index'),
//               ),
//             )),
//         staggeredTileBuilder: (int index) =>
//             new StaggeredTile.count(2, index.isEven ? 2 : 1),
//         mainAxisSpacing: 10.0,
//         crossAxisSpacing: 10.0,
//       ),
//     );
//   }
// }
