import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/evaluacion_rubro_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';

class RubroEvaluacionUi{
  String? rubroEvalId;
  String? fecha;
  String? titulo;
  String? tipo;
  String? iconoNota;
  String? nota;
  String? tituloNota;
  String? descNota;
  List<EvaluacionRubroUi>? evaluacionRubroList;
  TipoNotaEnumUi? tipoNotaEnum;
  CursoUi? cursoUi;

}