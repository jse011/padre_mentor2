import 'package:moor_flutter/moor_flutter.dart';

class AsistenciaGeneral extends Table{
  IntColumn get controlAsistenciaId => integer()();
  IntColumn get alumnoId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  IntColumn get grupoId => integer().nullable()();
  IntColumn get periodoId => integer().nullable()();
  IntColumn get programaEducativoId => integer().nullable()();
  IntColumn get docenteId => integer().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
  TextColumn get fechaAsistencia => text().nullable()();
  TextColumn get horaIngreso => text().nullable()();
  TextColumn get horaSalida => text().nullable()();
  IntColumn get estadoIngresoId => integer().nullable()();
  TextColumn get estadosIngresoNombre => text().nullable()();
  IntColumn get estadoSalidaId => integer().nullable()();
  TextColumn get estadosSalidaNombre => text().nullable()();
  TextColumn get observaciones => text().nullable()();

  @override
  Set<Column> get primaryKey => {controlAsistenciaId};
}