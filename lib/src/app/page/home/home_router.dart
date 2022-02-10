import 'package:flutter/material.dart';

class HomeRouter{

  static Route createRouteHomeRemoveAll(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    //Navigator.of(context).pushReplacementNamed('/home');
    //Navigator.of(context).pushReplacement();


    /*return new MaterialPageRoute(
      builder: (BuildContext context) => new LoginView(),
    );*/
  }

}