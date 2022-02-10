import 'package:moor_flutter/moor_flutter.dart';

class SessionUser extends Table{
  IntColumn get userId  => integer()();
  IntColumn get hijoIdSelect => integer().nullable()();
  TextColumn get urlServerLocal => text().nullable()();
  BoolColumn get complete => boolean().nullable()();
  @override
  Set<Column> get primaryKey => {userId};
}