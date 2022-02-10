import 'package:flutter/cupertino.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_view.dart';

class EstadoCuentaRouter {
  static Route createRouteEstadoCuenta({@required fotoAlumno, @required  alumnoId}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EstadoCuentaView(alumnoId: alumnoId, fotoAlumno: fotoAlumno),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}