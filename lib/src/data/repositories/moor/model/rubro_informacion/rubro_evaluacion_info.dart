
import 'package:moor_flutter/moor_flutter.dart';

class RubroEvaluacionInfo extends Table{
  
  TextColumn get evaluacionProcesoId => text()();
 
  TextColumn get rubroEvalProcesoId  => text().nullable()();
 
  TextColumn get parentId  => text().nullable()();
 
  TextColumn get titulo  => text().nullable()();
 
  RealColumn get nota  => real().nullable()();
 
  TextColumn get tipoNotaId  => text().nullable()();
 
  IntColumn get tipoId  => integer().nullable()();
 
  TextColumn get tipoNotaNombre  => text().nullable()();

  IntColumn get escalaEvaluacionId  => integer().nullable()();

  IntColumn get valorMaximo  => integer().nullable()();

  IntColumn get valorMinimo  => integer().nullable()();
 
  TextColumn get rubroDetalleTipoNotaId  => text().nullable()();

  IntColumn get tipoCompetenciaId  => integer().nullable()();

  IntColumn get calendarioPeriodoId  => integer().nullable()();

  BoolColumn get msje  => boolean().nullable()();
 
  TextColumn get valorTipoNotaId  => text().nullable()();

  IntColumn get alumnoId  => integer().nullable()();

  IntColumn get intervalo  => integer().nullable()();

  @override
  Set<Column> get primaryKey => {evaluacionProcesoId};
}