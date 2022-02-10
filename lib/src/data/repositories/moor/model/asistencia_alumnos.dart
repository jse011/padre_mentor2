import 'package:moor_flutter/moor_flutter.dart';

class AsistenciaAlumnos extends Table{
  TextColumn get asistenciaSesionId => text()();
  TextColumn get fechaAsistenciaN => text().nullable()();
  TextColumn get hora => text().nullable()();
  IntColumn get  georeferenciaId => integer().nullable()();
  IntColumn get  alumnoId => integer().nullable()();
  IntColumn get  sesionAprendizajeId => integer().nullable()();
  IntColumn get  calendarioPeriodoId => integer().nullable()();
  IntColumn get  cargaCursoId => integer().nullable()();
  TextColumn get valorTipoNotaId => text().nullable()();
  IntColumn get  asistenciaSesionIdAndroid => integer().nullable()();
  IntColumn get  periodoId => integer().nullable()();
  IntColumn get  docenteId => integer().nullable()();
  IntColumn get  grupoId => integer().nullable()();
  TextColumn get fechaAsistenciaS => text().nullable()();
  TextColumn get nombreCurso => text().nullable()();
 IntColumn get  gradoId => integer().nullable()();
  TextColumn get grado => text().nullable()();
 IntColumn get  seccionId => integer().nullable()();
  TextColumn get seccion => text().nullable()();
 IntColumn get  silaboEventoId => integer().nullable()();
 IntColumn get  parametroDesenioId => integer().nullable()();
  TextColumn get correoDocente => text().nullable()();
  TextColumn get celularDocente => text().nullable()();
  TextColumn get telefonoDocente => text().nullable()();
  TextColumn get fotoDocente => text().nullable()();
  TextColumn get nombreDocente => text().nullable()();
 IntColumn get  personaIdDocente => integer().nullable()();
  IntColumn get anioAcademicoId => integer().nullable()();
  IntColumn get programaAcadId => integer().nullable()();
  DateTimeColumn get fechaAsistenciaTime => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {asistenciaSesionId};
}
class AsistenciaJustificacion extends Table{
  TextColumn get justificacionId => text()();
  TextColumn get asistenciaId => text().nullable()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get  tipoJustificacionId => integer().nullable()();
  IntColumn get  tipoIngresoId => integer().nullable()();
  TextColumn get asistenciaSesionId => text().nullable()();
  TextColumn get asistenciaDocenteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {justificacionId};
}
class AsistecniaArchivo extends Table{
 TextColumn get archivoAsistenciaId => text()();
 TextColumn get path => text().nullable()();
 TextColumn get nombre => text().nullable()();
 IntColumn get  tipoId => integer().nullable()();
 TextColumn get justificacionId => text().nullable()();
 TextColumn get pathLectura => text().nullable()();

 @override
 Set<Column> get primaryKey => {archivoAsistenciaId};
}
class AsistenciaTipoNota extends Table{
  TextColumn get tipoNotaId => text()();
  TextColumn get nombre => text().nullable()();
  IntColumn get  tipoId => integer().nullable()();
  TextColumn get valorDefecto => text().nullable()();
  IntColumn get  valorMaximo => integer().nullable()();
  IntColumn get  valorMinino => integer().nullable()();
  RealColumn get longitudPaso => real().nullable()();
  BoolColumn get intervalo => boolean().nullable()();
  BoolColumn get estatico => boolean().nullable()();
  IntColumn get  entidadId => integer().nullable()();
  IntColumn get  georeferenciaId => integer().nullable()();
  IntColumn get  organigramaId => integer().nullable()();
  IntColumn get  estadoId => integer().nullable()();
  IntColumn get  tipoFuenteId => integer().nullable()();
  IntColumn get  escalaEvaluacionId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {tipoNotaId};
}
class AsistenciaValorTipoNota extends Table{
  TextColumn get valorTipoNotaId => text()();
  TextColumn get tipoNotaId => text().nullable()();
  TextColumn get titulo => text().nullable()();
  TextColumn get tipoNotaAlias => text().nullable()();
  RealColumn get limiteInferior => real().nullable()();
  RealColumn get limiteSuperior => real().nullable()();
  RealColumn get valorNumerico => real().nullable()();
  TextColumn get icono => text().nullable()();
  IntColumn get  estadoId => integer().nullable()();
  BoolColumn get incluidoLInferior => boolean().nullable()();
  BoolColumn get incluidoLSuperior => boolean().nullable()();
  IntColumn get  tipoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {valorTipoNotaId};
}
class AsistenciaRelProgramaTipoNota extends Table{
  IntColumn get  programaEducativoId => integer()();
  TextColumn get tipoNotaId => text().nullable()();
  BoolColumn get estado => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {programaEducativoId};
}