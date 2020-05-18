import 'package:eatapp/pages/home_page.dart';
import 'package:eatapp/pages/descubrir_page.dart';
import 'package:eatapp/pages/crear_page.dart';
import 'package:eatapp/pages/login_page.dart';
import 'package:eatapp/pages/perfil_page.dart';
import 'package:eatapp/pages/splash_page.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:eatapp/receta_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'models/api_response.dart';
import 'models/perfil.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => RecetasService());
  GetIt.I.registerLazySingleton(() => PerfilService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatApp',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Color(0xff62CAE5),
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 14.0, color: Color(0xff363B4B)),
        ),
      ),
      home: MyHomePage(title: 'EatApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  int _selectedIndex = 0;
  Perfil perfil;
  bool _isLoading = false;
  bool _isLoged = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void callback(bool _loged) {
    setState(() {
      _isLoged = _loged;
    });
  }

  void pageId_callback(int _page) {
    setState(() {
      _selectedIndex = _page;
    });
  }

  List<Widget> _pages = [
    new Home_Page(),
    Descubrir_Page(),
    Crear_Page(),
    Perfil_Page(),
  ];

  @override
  void initState() {
    _fetchPerfil();
    super.initState();
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });

    APIResponse<Perfil> _apiResponse = await perfilService.getPerfil();
    perfil = _apiResponse.data;

    setState(() {
      _isLoading = false;
      if (perfil != null) {
        callback(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECECEC),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Splash_Page();
          } else if (!_isLoading && !_isLoged) {
            return Login_Page(loged: _isLoged, callback: callback);
          } else {}
          return _pages[_selectedIndex];
        },
      ),
      bottomNavigationBar: (!_isLoged) ? null : BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 32,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
