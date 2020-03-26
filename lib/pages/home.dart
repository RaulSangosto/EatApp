import 'package:eatapp/widgets/profile_avatar.dart';
import 'package:eatapp/widgets/recetas_list.dart';
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
    int _selectedIndex = 0;
    int _numSugerencias = 5;

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
                              child: RecetaList(_numSugerencias),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Dot(0, _selectedIndex),
                                      Dot(1, _selectedIndex),
                                      Dot(2, _selectedIndex),
                                      Dot(3, _selectedIndex),
                                      Dot(4, _selectedIndex),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 70.0),
                                    child: OutlineButton(
                                      
                                      borderSide: BorderSide(

                                      ),
                                      onPressed: _onPressed,
                                      child: Text("Ver todas"),
                                    ),
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

class Dot extends StatelessWidget {
  Dot(this._index, this.selectedIndex);

  int selectedIndex;
  final int _index;

  bool isSelected(){
    return (_index == selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: isSelected() ? 10.0 : 7.0,),
      width: isSelected() ? 13.0 : 10.0,
      height: isSelected() ? 13.0 : 10.0,
      decoration: BoxDecoration(
        color: isSelected() ? Color(0xff363B4B) : Color(0xffC5C5C5),
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          colors: [Color(0xff000048), const Color.fromARGB(0, 0, 0, 0)], // whitish to gray
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
                PerfilAvatar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
