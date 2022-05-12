import 'package:moor_flutter/moor_flutter.dart';

class TareaAlumno extends Table{
  TextColumn get tareaId => text()();
  IntColumn get alumnoId => integer()();
  BoolColumn get entregado => boolean().nullable()();
  IntColumn get fechaEntrega => integer().nullable()();
  TextColumn get valorTipoNotaId => text().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  IntColumn get fechaServidor => integer().nullable()();

  @override
  Set<Column> get primaryKey => {tareaId, alumnoId};
}