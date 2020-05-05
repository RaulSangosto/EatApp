import 'package:eatapp/models/api_response.dart';
import 'package:eatapp/models/perfil.dart';
import 'package:eatapp/perfil_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PerfilAvatar extends StatefulWidget {
  PerfilAvatar(this.radius);
  final double radius;
  Perfil perfil;

  @override
  State<StatefulWidget> createState() {
    return _PerfilAvatar(radius);
  }
}

class _PerfilAvatar extends State<PerfilAvatar> {
  PerfilService get perfilService => GetIt.I<PerfilService>();
  _PerfilAvatar(this.radius);

  final double radius;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchNotas();
    super.initState();
  }

  _fetchNotas() async {
    print("loading perfil");
    setState(() {
      _isLoading = true;
    });

    APIResponse<Perfil> _apiResponse = await perfilService.getPerfil();
    widget.perfil = _apiResponse.data;
    print("perfilResponse data " + _apiResponse.data.toString());
    print("perfilResponse error " + _apiResponse.errorMessage.toString());
    print("perfilAvatar " + widget.perfil.toString());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: radius * 2,
            height: radius * 2,
            padding:
                EdgeInsets.all((radius * 0.08) <= 2.0 ? 2.0 : (radius * 0.08)),
            decoration: BoxDecoration(
              color: Colors.white, // border color
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage:widget.perfil.avatarUrl == null ? null : NetworkImage(widget.perfil.avatarUrl),
              backgroundColor: Colors.blueGrey,
              radius: radius,
              child: Text(
                widget.perfil.nombre.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: radius / ~8),
              ),
            ),
          );
  }
}
