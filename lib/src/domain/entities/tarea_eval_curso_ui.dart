import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_archivo_ui.dart';
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
    double? nota;
    String? iconoNota;
    String? descNota;
    String? tituloNota;
    String? rubroEvaluacionId;
    TareaEvalEstadoEnumUi? evalEstado;
    bool? tareaFinal;
    bool? tareaIncial;
    int? position;
    String? tareaDescripcion;
    TareaEstadoEntregado? estadoEntregado;
    List<TareaAlumnoArchivoUi>? alumnoArchivoUiList;
    int? fechaServidor;
    List<TareaArchivoUi>? recursoArchivoUiList;
    int? fechaEntregaAlumno;
    int? unidadAprendizajeId;
    int? sesionAprendizajeId;
    String? evaluacionProcesoId;
}

enum TareaEvalEstadoEnumUi{
    SINFECHA, HA_ENTREGAR, HA_ENTREGAR_RETRAZO, ENTREGADO
}

enum TareaEstadoEntregado{CARGANDO, SIN_ENTREGAR, ENTREGADO, ENTREGADO_RETRASO,}