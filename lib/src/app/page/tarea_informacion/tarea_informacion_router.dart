import 'package:flutter/cupertino.dart';
import 'package:padre_mentor/src/app/page/tarea_informacion/portal_tarea_view.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';

class TareaInformacionRouter {
  static void createRoute(BuildContext context, TareaEvaluacionCursoUi? tareaEvaluacionCursoUi, String? fotoAlumno, int? alumnoId) {

    Navigator.of(context).push( PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PortalTareaView(tareaEvaluacionCursoUi, fotoAlumno, alumnoId),
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