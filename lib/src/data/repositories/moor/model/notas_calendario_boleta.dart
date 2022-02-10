import 'package:moor_flutter/moor_flutter.dart';

class NotasCalendarioBoleta extends Table{
 
  IntColumn get evaluacionResultadoId => integer()();
  IntColumn get rubroEvalResultadoId => integer().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  TextColumn get nota => text().nullable()();
  RealColumn get peso => real().nullable()();
  TextColumn get valorTipoNotaId => text().nullable()();
  TextColumn get tituloNota => text().nullable()();
  IntColumn get tipoNotaId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  TextColumn get color => text().nullable()();

  @override
  Set<Column> get primaryKey => {evaluacionResultadoId};
}