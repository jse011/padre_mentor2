import 'package:flutter/cupertino.dart';
import 'package:flutter_app_name/context.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_view.dart';
import 'package:padre_mentor/src/app/page/evaluacion_informacion/evaluacion_informacion_view.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/evaluacion_rubro_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';

class EvaluacionInformacionRouter {
  static void createRoute(BuildContext context, CursoUi? cursoUi, String? rubroEvaluacionId, int? alumnoId) {

    Navigator.of(context).push( PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EvaluacionInformacionView(cursoUi, rubroEvaluacionId, alumnoId),
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
    ));

  }
}