import 'package:moor_flutter/moor_flutter.dart';

class SessionUserHijoPrograma extends Table{

  IntColumn get prograAcademicoId => integer()();
  IntColumn get anioAcademicoId => integer()();
  IntColumn get hijoId => integer()();
  TextColumn get color => text().nullable()();
  BoolColumn get selected => boolean().nullable()();
  @override
  Set<Column> get primaryKey => {anioAcademicoId, prograAcademicoId, hijoId};
}