import 'package:moor_flutter/moor_flutter.dart';

class RubroValorTipoNotaInfo extends Table {
  
  TextColumn get rubroEvalProcesoId => text().nullable()();
  //@PrimaryKey
  TextColumn get evaluacionProcesoId => text()();
  //@PrimaryKey
  TextColumn get valorTipoNotaId => text()();
  
  TextColumn get tipoNotaId => text().nullable()();
  
  TextColumn get tituloNivelLogro => text().nullable()();
  
  TextColumn get aliasNivelLogro => text().nullable()();
  
  TextColumn get iconoNivelLogro => text().nullable()();
  
  RealColumn get valorNumericoNivelLogro => real().nullable()();
  
  BoolColumn get  incluidoLInferior => boolean().nullable()();
  
  BoolColumn get  incluidoLSuperior => boolean().nullable()();
  
  RealColumn get limiteInferior => real().nullable()();
  
  RealColumn get limiteSuperior => real().nullable()();
  
  IntColumn get alumnoId => integer().nullable()();
  
  TextColumn get rubroEvalProParentId => text().nullable()();

  @override
  Set<Column> get primaryKey => {evaluacionProcesoId, valorTipoNotaId};
 
}