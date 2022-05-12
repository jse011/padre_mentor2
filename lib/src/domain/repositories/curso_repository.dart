import 'package:padre_mentor/src/domain/entities/asistencia_tipo_ui.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_ui.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/contacto_ui.dart';
import 'package:padre_mentor/src/domain/entities/contrato_ui_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_boleta_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';

abstract class CursoRepository{
  Future<List<CalendarioPeriodoUI>> getCalendarioPerios(int programaEducativoId, int alumnoId, int anioAcademicoId);
  Future<void> saveBoletaNotas(Map<String, dynamic> datosBoleta, int anioAcademicoId, int programaEducativoId, int periodoId, int seccionId, int calendarioPeridoId, int alumnoId, int georeferenciaId);
  Future<List<CursoBoletaUi>> getBoletaNotas(int alumnoId, int anioAcademicoId, int calendarioPeridoId, int programaEducativoId, int periodoId, int seccionId);
  Future<ContratoUi> getContratoUi(int anioAcademicoId, int alumnoId);
  Future<void> saveEvaluaciones(Map<String, dynamic> datosEvaluaciones, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<List<RubroEvaluacionUi>> getEvaluacionesPorCurso(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<void> saveTareaEvaluaciones(Map<String, dynamic> datosTareaEvalaucion, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<List<TareaEvaluacionCursoUi>> getTareaEvaluacionPorCurso(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<void> saveContactos(Map<String, dynamic> datosTareaEvalaucion);
  Future<List<ContactoUi>> getContactos(List<int> hijoIdList);
  Future<List<CursoUi>> getCursos(int programaAcademicoId, int alumnoId, int anioAcademico);
  Future<void> saveAsistencia(Map<String, dynamic> datosEvaluaciones, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<List<AsistenciaUi>> getAsistenciaAlumno(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<List<AsistenciaTipoUi>> getAsistenciaTipo(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<void> saveAsistenciaGeneral(Map<String, dynamic> datosEvaluaciones, int calendarioPeridoId, int alumnoId);
  Future<List<AsistenciaUi>> getAsistenciaGeneral(int calendarioPeridoId, int alumnoId);
  Future<List<AsistenciaTipoUi>> getAsistenciaTipoGeneral(int calendarioPeridoId, int alumnoId);
  void saveRubroInfo(Map<String, dynamic> mapRubro, String? ruboEvaluacionId, int? hijoPersonId);
  Future<RubroEvaluacionUi> getRubroInfo(String? ruboEvaluacionId, int? hijoPersonId);
  void saveInfoTarea(Map<String, dynamic> mapTarea, String? tareaId, String? evaluacionId, String? rubroEvaluacionId, int? hijoPersonId);
  Future<TareaEvaluacionCursoUi> getInfoTarea(String? tareaId, int? hijoPersonId);
}