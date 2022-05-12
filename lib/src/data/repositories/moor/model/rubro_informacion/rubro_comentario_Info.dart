import 'package:moor_flutter/moor_flutter.dart';

class RubroComentarioInfo extends Table {

  TextColumn get rubroEvalProcesoId => text().nullable()();

  TextColumn get evaluacionProcesoId => text().nullable()();

  TextColumn get evaluacionProcesoComentarioId => text()();

  TextColumn get descripcion => text().nullable()();

  IntColumn get alumnoId => integer().nullable()();

  IntColumn get fechaCreacion => integer().nullable()();

  IntColumn get usuarioCreadorId => integer().nullable()();

  TextColumn get nombres => text()();

  TextColumn get foto => text()();

  @override
  Set<Column> get primaryKey => {evaluacionProcesoComentarioId};
}