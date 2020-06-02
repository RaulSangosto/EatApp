import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PerfilAvatar extends StatefulWidget {
  PerfilAvatar(this.radius, {this.color, this.selectedcolor});
  final double radius;
  final Color color;
  final Color selectedcolor;

  @override
  State<StatefulWidget> createState() {
    return _PerfilAvatar();
  }
}

class _PerfilAvatar extends State<PerfilAvatar> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  Perfil perfil;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchPerfil();
    super.initState();
  }

  _fetchPerfil() async {
    print("loading perfil");
    setState(() {
      _isLoading = true;
    });

    perfil = await perfilService.getPerfil();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            padding:
                EdgeInsets.all((widget.radius * 0.08) <= 2.0 ? 3.0 : (widget.radius * 0.08)),
            decoration: BoxDecoration(
              color: widget.color?? Colors.white, // border color
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage:perfil.avatarUrl == null ? null : NetworkImage(perfil.avatarUrl),
              backgroundColor: Colors.blueGrey,
              radius: widget.radius,
              child: Text(
                perfil.nombre.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: widget.radius / ~8),
              ),
            ),
          );
  }
}
