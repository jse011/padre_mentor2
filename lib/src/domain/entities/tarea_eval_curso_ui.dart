import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';

class TareaEvaluacionCursoUi {
    CursoUi? cursoUi;
    String? tareaId;
    String? tituloTarea;
    String? nombreDocente;
    DateTime? fechaInicio;
    DateTime? fechaEntrega;
    String? incioDia;
    String? incioDiaSemana;
    String? incioMes;
    String? finDia;
    String? finDiaSemana;
    String? finMes;
    TipoNotaEnumUi? tipoNotaEnum;
    String? nota;
    String? iconoNota;
    String? descNota;
    String? tituloNota;
    String? rubroEvaluacionId;
    TareaEvalEstadoEnumUi? evalEstado;
}

enum TareaEvalEstadoEnumUi{
    SINFECHA, HA_ENTREGAR, HA_ENTREGAR_RETRAZO, ENTREGADO
}