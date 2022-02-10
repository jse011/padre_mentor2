import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';

class CursoEvaluacionUi {
  CursoUi? cursoUi;
  bool? toogle;
  List<RubroEvaluacionUi>? evaluacionUiList;
  CursoEvaluacionUi({
    this.cursoUi,
    this.evaluacionUiList});
}