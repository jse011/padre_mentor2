import 'package:moor_flutter/moor_flutter.dart';

class Evento extends Table{
   
    TextColumn get eventoId => text()();
    TextColumn get titulo => text().nullable()();
    TextColumn get descripcion => text().nullable()();
    TextColumn get calendarioId => text().nullable()();
    IntColumn get tipoEventoId => integer().nullable()();
    IntColumn get estadoId => integer().nullable()();
    BoolColumn get estadoPublicacion => boolean().nullable()();
    IntColumn get entidadId => integer().nullable()();
    IntColumn get georeferenciaId => integer().nullable()();
    TextColumn get fechaEvento  => text().nullable()();
    TextColumn get horaEvento => text().nullable()();

    TextColumn get pathImagen => text().nullable()();
    BoolColumn get envioPersonalizado => boolean().nullable()();
    TextColumn get tipoEventoNombre => text().nullable()();
    IntColumn get usuarioReceptorId => integer().nullable()();
    IntColumn get eventoHijoId => integer().nullable()();
    IntColumn get likeCount => integer().nullable()();

    TextColumn get nombreEntidad  => text().nullable()();
    TextColumn get fotoEntidad => text().nullable()();
    TextColumn get nombreEntidadSiglas => text().nullable()();

    DateTimeColumn get fechaEventoTime => dateTime().nullable()();
    @override
    Set<Column> get primaryKey => {eventoId};
}