import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/informacion/evento_info_complejo_view.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/informacion/evento_info_simple_view.dart';
import 'package:padre_mentor/src/domain/entities/evento_adjunto_ui.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';

class EventoInfoRouter{

  static Route createRouteInfoEventoSimple({EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EventoInfoSimpleView(eventoUi, eventoAdjuntoUi),
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

  static Route createRouteInfoEventoComplejo({EventoUi? eventoUi}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EventoInfoComplejoView(eventoUi),
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