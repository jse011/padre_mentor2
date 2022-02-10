import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';

class EventoUi{
  String? id;
  String? nombreEmisor;
  String? rolEmisor;
  String? fotoEntidad;
  String? nombreEntidad;
  DateTime? fecha;
  String? nombreFecha;
  String? titulo;

  String? descripcion;
  String? foto;
  TipoEventoUi? tipoEventoUi;
  int? cantLike;

  DateTime? getFecha(){
    return this.fecha == null?DateTime(1900):this.fecha;
  }
}