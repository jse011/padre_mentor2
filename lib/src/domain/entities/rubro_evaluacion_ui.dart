import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/evaluacion_rubro_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_comentario_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:padre_mentor/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:padre_mentor/src/domain/usecases/competencia_tipo.dart';

class RubroEvaluacionUi{
  String? rubroEvalId;
  String? fecha;
  String? titulo;
  String? tipo;
  String? iconoNota;
  double? nota;
  String? tituloNota;
  String? descNota;
  List<EvaluacionRubroUi>? evaluacionRubroList;
  TipoNotaEnumUi? tipoNotaEnum;
  CursoUi? cursoUi;
  bool? intervalo;
  int? valorMaximo;
  int? valorMinimo;
  CompetenciaTipo? tipoCompetencia;
  List<ValorTipoNotaUi>? valorTipoNotas;
  String? puntos;
  String? desempenio;
  List<RubroEvaluacionUi>? rubroEvaluacionUiList;
  List<RubroComentarioUi>? comentarioList;
  List<RubroArchivoUi>? archivoList;
  bool? evaluacionIncial;
  bool? evaluacionFinal;

}
