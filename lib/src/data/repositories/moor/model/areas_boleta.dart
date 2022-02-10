import 'package:moor_flutter/moor_flutter.dart';

class AreasBoleta extends Table{
 
  IntColumn get rubroEvalResultadoId => integer()();
  TextColumn get nombre => text().nullable()();
  IntColumn get tipoConceptoId => integer().nullable()();
  IntColumn get totalHt => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  TextColumn get competencia => text().nullable()();
  IntColumn get tipoNotaId => integer().nullable()();//TipoNotaId
  IntColumn get tipoFormulaId => integer().nullable()();
  IntColumn get competenciaId => integer().nullable()();
  IntColumn get tipoCompetenciaId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  IntColumn get anioAcademicoId => integer().nullable()();
  IntColumn get programaEducativoId => integer().nullable()();
  IntColumn get periodoId => integer().nullable()();
  IntColumn get seccionId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {rubroEvalResultadoId};

}