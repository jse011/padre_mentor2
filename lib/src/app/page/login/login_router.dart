import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/page/boleta_notas/boleta_notas_view.dart';
import 'package:padre_mentor/src/app/page/login/login_view.dart';

class LoginRouter{

  static Route createRouteLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    //Navigator.of(context).pushReplacementNamed('/login');
    //Navigator.of(context).pushReplacement();


    /*return new MaterialPageRoute(
      builder: (BuildContext context) => new LoginView(),
    );*/
  }

}