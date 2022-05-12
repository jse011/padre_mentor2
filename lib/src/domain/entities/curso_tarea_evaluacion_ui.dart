import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';

class CursoTareaEvaluacionUi {
  CursoUi? cursoUi;
  bool? toogle;
  List<TareaEvaluacionCursoUi>? tareaEvaluacionUiList;
  CursoTareaEvaluacionUi({
    this.cursoUi,
    this.tareaEvaluacionUiList});
}