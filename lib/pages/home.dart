import 'package:eatapp/models/receta.dart';
import 'package:eatapp/test/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  void _onPressed(){
    print("pressed!!");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(children: <Widget>[
                    _TopCard(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: 0.65,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                                blurRadius: 6.0, // has the effect of softening the shadow
                                offset: Offset(
                                  0.0, // horizontal, move right 10
                                  -3.0, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.4),
                      child: SizedBox(
                        height: 338.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 250.0,
                              child: _RecetasList(),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Row(),
                                  OutlineButton(
                                    borderSide: BorderSide(

                                    ),
                                    onPressed: _onPressed,
                                    child: Text("Ver todas"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ],
                  ),
                )
            ],),
          ),
        ],
      ),
    );
  }
}



class _TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new ExactAssetImage("assets/images/guacamole.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment(0, -1.3),
          end: Alignment(0, 0),
          colors: [Colors.deepPurple, const Color.fromARGB(0, 0, 0, 0)], // whitish to gray
        ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:10.0,vertical: 20.0,),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Para hoy",
                      style: TextStyle(
                        color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    Text("Pasta Fresca", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,),
                      textAlign: TextAlign.left,
                      ),
                  ]
                ),
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 30.0,
                  child: Text("R",
                  style: TextStyle(
                        fontSize: 20
                      ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecetasList extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        Receta receta = recetas[index % recetas.length];
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(left: 70.0),
            child: _RecetasTile(receta));
        }
        return _RecetasTile(receta);
      }
    );
  }
}

class _RecetasTile extends StatelessWidget {
  _RecetasTile(this.receta);

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 250.0,
        width: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.blueGrey,
          image: new DecorationImage(
            image: new ExactAssetImage(receta.imgUrl),
            fit: BoxFit.cover,
          ),
        ),
        child:Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.favorite, color: Colors.redAccent),
              Text(receta.titulo, style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
