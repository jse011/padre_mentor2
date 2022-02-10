import 'package:moor_flutter/moor_flutter.dart';

class TareaCurso extends Table{
  TextColumn get tareaId => text()();
  TextColumn get tareaTitulo => text().nullable()();
  TextColumn get tareaInstrucciones => text().nullable()();
  DateTimeColumn get tareafechaCreacion => dateTime().nullable()();
  TextColumn get tareaEstadoId => text().nullable()();
  IntColumn get unidadAprendizajeId => integer().nullable()();
  IntColumn get sesionAprendizajeId => integer().nullable()();
  TextColumn get tareaFechaEntrega => text().nullable()();
  TextColumn get tareaHoraEntrega => text().nullable()();
  IntColumn get gradoId => integer().nullable()();
  TextColumn get grado => text().nullable()();
  IntColumn get seccionId => integer().nullable()();
  TextColumn get seccion => text().nullable()();
  DateTimeColumn get fechaEvaluacion => dateTime().nullable()();
  TextColumn get tituloEvaluacion => text().nullable()();
  TextColumn get formaEvaluacion => text().nullable()();
  IntColumn get tipoRubroEvalId => integer().nullable()();
  IntColumn get cargaCursoId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  IntColumn get anioAcademicoId => integer().nullable()();
  IntColumn get programaAcadId => integer().nullable()();
  TextColumn get rubroEvalProcesoId => text().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  IntColumn get parametroDesenioId => integer().nullable()();
  TextColumn get iconoNivelLogro => text().nullable()();
  TextColumn get tituloNivelLogro => text().nullable()();
  TextColumn get descripcionNivelLogro => text().nullable()();
  IntColumn get tipoIdNivelLogro => integer().nullable()();
  RealColumn get notaEvalaucion => real().nullable()();
  TextColumn get evaluacionProcesoId => text().nullable()();
  TextColumn get nombreCurso => text().nullable()();

  TextColumn get docenteApellMat => text().nullable()();
  TextColumn get docenteApellPat => text().nullable()();
  TextColumn get docenteNombre => text().nullable()();
  @override
  Set<Column> get primaryKey => {tareaId};
}