import 'package:moor_flutter/moor_flutter.dart';

class TareaAlumnoArchivo extends Table{
  TextColumn get id => text()();
  TextColumn get tareaId => text().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  BoolColumn get repositorio => boolean().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get path => text().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  IntColumn get unidadAprendizajeId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};

}