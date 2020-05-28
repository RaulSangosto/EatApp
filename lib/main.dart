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
import 'package:shared_preferences/shared_preferences.dart';
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
          bodyText2: TextStyle(fontSize: 14.0, color: Color(0xff363B4B)),
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
  SharedPreferences prefs;
  int _selectedIndex = 0;
  Perfil perfil;
  bool _isLoading = false;
  bool _isLoged = false;

  HomePage hPage;
  DescubrirPage dPage;
  CrearPage cPage;
  PerfilPage pPage;
  List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void loginCallback(bool _loged) {
    setState(() {
      _isLoged = _loged;
    });
  }

  void pageIdCallback(int _page) {
    setState(() {
      _selectedIndex = _page;
    });
  }

  @override
  void initState() {
    _fetchPerfil();

    hPage = HomePage(
        loged: _isLoged,
        loginCallback: loginCallback,
        pageIdCallback: pageIdCallback);
    dPage = DescubrirPage(
        loged: _isLoged,
        loginCallback: loginCallback,
        pageIdCallback: pageIdCallback);
    cPage = CrearPage(
        loged: _isLoged,
        loginCallback: loginCallback,
        pageIdCallback: pageIdCallback);
    pPage = PerfilPage(
        loged: _isLoged,
        loginCallback: loginCallback,
        pageIdCallback: pageIdCallback);
    _pages = [
      hPage,
      dPage,
      cPage,
      pPage,
    ];

    super.initState();
  }

  _fetchPerfil() async {
    setState(() {
      _isLoading = true;
    });

    perfil = await perfilService.getPerfil();

    if (perfil != null) {
      loginCallback(true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          (_isLoged) ? Color(0xffECECEC) : Theme.of(context).accentColor,
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return SplashPage();
          } else if (!_isLoading && !_isLoged) {
            return LoginPage(
                loged: _isLoged,
                loginCallback: loginCallback,
                pageIdCallback: pageIdCallback);
          } else {}
          return _pages[_selectedIndex];
        },
      ),
      bottomNavigationBar: (!_isLoged)
          ? null
          : BottomNavigationBar(
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
