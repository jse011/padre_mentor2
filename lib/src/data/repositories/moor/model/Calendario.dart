import 'package:moor_flutter/moor_flutter.dart';

class Calendario extends Table{
  TextColumn get calendarioId => text()();
  TextColumn get nombre => text().nullable()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get estado => integer().nullable()();
// int usuarioId;
  IntColumn get entidadId => integer().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
//string fechaAccion;
//string fechaCrecion;
  TextColumn get nUsuario => text().nullable()();
  TextColumn get cargo => text().nullable()();
  IntColumn get usuarioId => integer().nullable()();

  IntColumn get cargaAcademicaId => integer().nullable()();
  IntColumn get cargaCursoId => integer().nullable()();
  IntColumn get estadoPublicacionCal => integer().nullable()();
  IntColumn get rolId => integer().nullable()();

  DateTimeColumn get fechaCreacion => dateTime().nullable()();
  IntColumn get usuarioAccionId => integer().nullable()();
  DateTimeColumn get fechaAccion => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {calendarioId};

}