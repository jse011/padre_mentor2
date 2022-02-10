import 'package:moor_flutter/moor_flutter.dart';

class Contrato extends Table{
  
   IntColumn get idContrato => integer()();
   IntColumn get personaId => integer().nullable()();
   IntColumn get idAnioAcademico => integer().nullable()();
   IntColumn get nroHno => integer().nullable()();
   IntColumn get nivelAcaId => integer().nullable()();
   IntColumn get seccionId => integer().nullable()();
   IntColumn get periodoId => integer().nullable()();
   IntColumn get vigente => integer().nullable()();
   IntColumn get estadoId => integer().nullable()();
   IntColumn get apoderadoId => integer().nullable()();

   @override
   Set<Column> get primaryKey => {idContrato};
}