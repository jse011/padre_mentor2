import 'package:moor_flutter/moor_flutter.dart';

class DetalleContratoAcad extends Table{
  
   IntColumn get idContratoDetAcad => integer()();
   IntColumn get idContrato => integer().nullable()();
   IntColumn get cargaCursoId => integer().nullable()();
   IntColumn get cargaAcademicaId => integer().nullable()();
   TextColumn get notaPromedio => text().nullable()();
   TextColumn get escala => text().nullable()();
   IntColumn get anioAcademicoId => integer().nullable()();
   IntColumn get idNivelAcademico => integer().nullable()();
   IntColumn get cursoId => integer().nullable()();
   IntColumn get grupoId => integer().nullable()();
   IntColumn get aulaId => integer().nullable()();

   @override
   Set<Column> get primaryKey => {idContratoDetAcad};

}