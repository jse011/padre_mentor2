import 'package:padre_mentor/src/domain/entities/evento_adjunto_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';

class EventoUi{
  String? id;
  String? nombreEmisor;
  String? rolEmisor;
  String? fotoEntidad;
  String? nombreEntidad;
  DateTime? fecha;//Fecha con hora
  DateTime? fechaEvento;//Fecha sin hora
  String? nombreFecha;
  String? titulo;

  String? descripcion;
  String? foto;
  TipoEventoUi? tipoEventoUi;
  int? cantLike;
  bool? externo;
  List<EventoAdjuntoUi>? eventoAdjuntoUiList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiEncuestaList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiDownloadList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiPreviewList;
  String? nombreFechaPublicacion;
  DateTime? fechaPublicacion;
  bool? publicado;
  String? horaEvento;
  DateTime? fecaCreacion;
  int? estadoId;
  String? nombreCalendario;
  int? cargaCursoId;
  int? cargaAcademicaId;
  DateTime getFecha() {
    return this.fecha??DateTime(1900);
  }
}