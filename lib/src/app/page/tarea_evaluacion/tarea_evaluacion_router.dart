import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/page/tarea_evaluacion/tarea_evaluacion_view.dart';

class TareaEvaluacionRouter {
  static Route createRouteEvaluacion({required programaAcademicoId, required  alumnoId, required anioAcademico, String? fotoAlumno}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TareaEvaluacionView(alumnoId: alumnoId, programaAcademicoId: programaAcademicoId, anioAcademicoId: anioAcademico, fotoAlumno: fotoAlumno),
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