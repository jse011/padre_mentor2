import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';

class CursoBoletaUi {
  
  int? rubroEvalResultadoId;
  String? nombre;
  String? competencia;
  TipoNotaEnumUi? tipoNotaEnum = TipoNotaEnumUi.VALOR_NUMERICO;
  int? competenciaId;
  List<CursoBoletaUi>?  cursoBoletaUiList = [];
  int? silaboEventoId;
  String? nota;
  String? color;
  String? colorCurso;
  bool? tranversal;
  String? colorCurso2;
  String? colorCurso3;
  int? tipoConceptoId;
  int? totalHt;
  bool? padre;

  CursoBoletaUi(
  {this.rubroEvalResultadoId,
      this.nombre,
      this.competencia,
      this.tipoNotaEnum,
      this.competenciaId,
      this.cursoBoletaUiList,
      this.silaboEventoId,
      this.nota,
      this.color,
      this.colorCurso,
      this.tranversal,
      this.colorCurso2,
      this.colorCurso3,
      this.tipoConceptoId,
      this.totalHt,
      this.padre});

}