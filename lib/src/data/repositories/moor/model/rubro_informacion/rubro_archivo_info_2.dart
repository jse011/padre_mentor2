import 'package:moor_flutter/moor_flutter.dart';

class RubroArchivoInfo2 extends Table {
 
  TextColumn get rubroEvalProcesoId => text().nullable()();
 
  TextColumn get evaluacionProcesoId => text().nullable()();
 
  TextColumn get archivoRubroId => text()();
 
  TextColumn get url => text().nullable()();
 
  IntColumn get alumnoId => integer().nullable()();

  IntColumn get fechaCreacion => integer().nullable()();

  IntColumn get tipoArchivoId => integer().nullable()();


  @override
  Set<Column> get primaryKey => {archivoRubroId};

}