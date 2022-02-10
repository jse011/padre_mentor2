import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/repositories/check_conex_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';

class GetEventoActuales extends UseCase<GetEventoActualesResponse, GetEventoActualesParams>{
  UsuarioAndConfiguracionRepository repository;
  HttpDatosRepository httpRepository;
  CheckConexRepository checkConexRepository;
  GetEventoActuales(this.checkConexRepository, this.repository, this.httpRepository);

  @override
  Future<Stream<GetEventoActualesResponse>> buildUseCaseStream(GetEventoActualesParams? params) async{
    final controller = StreamController<GetEventoActualesResponse>();
    logger.finest('Hola Jse');
    try {

      List<EventoUi> eventoUIList = await repository.getTopEventosAgenda(params?.usuarioId??0, params?.tipoEventoId??0, params?.hijoIdList??[]);
      eventoSuccess(eventoUIList);
      controller.add(GetEventoActualesResponse( eventoUIList, false, true));

      Future<String?> executeServidor() async{
        String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();
        Map<String, dynamic>? eventoAgenda = await httpRepository.getEventoAgenda(urlServidorLocal,params?.usuarioId??0, params?.tipoEventoId??0);
        bool errorServidor = eventoAgenda==null;
        if(!errorServidor){
          await repository.saveEventoAgenda(eventoAgenda, params?.usuarioId??0, params?.tipoEventoId??0, params?.hijoIdList??[]);
        }
        eventoUIList = await repository.getTopEventosAgenda(params?.usuarioId??0, params?.tipoEventoId??0, params?.hijoIdList??[]);
        controller.add(GetEventoActualesResponse(eventoUIList, errorServidor, false));
        logger.finest('EventoAgenda successful.');
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
      }).timeout(const Duration (seconds:60),onTimeout : () {
        controller.addError(throw Exception("GetEventoAgenda timeout 60 seconds"));
      });


    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }

  void eventoSuccess(List<EventoUi> eventoUIList){
    for(var eventosUi in eventoUIList){
      DateTime? fechaEntrega =  eventosUi.fecha;
      if(fechaEntrega!=null && fechaEntrega.millisecondsSinceEpoch>912402000000){
        switch (eventosUi.tipoEventoUi?.tipo){
          case EventoIconoEnumUI.EVENTO:
          //tipo += eventosUi.getFechaEvento() > 0 ?" " + :"";
            eventosUi.nombreFecha = AppTools.tiempoFechaCreacion(eventosUi.fecha);
            break;
          case EventoIconoEnumUI.NOTICIA:
            eventosUi.nombreFecha = AppTools.getFechaDiaMesAnho(eventosUi.fecha);
            break;
          default:
            eventosUi.nombreFecha = AppTools.tiempoFechaCreacion(eventosUi.fecha);
            break;
        }
      }else{
        eventosUi.nombreFecha = "";
      }
    }
  }
}

class GetEventoActualesParams {
  int usuarioId;
  int tipoEventoId;
  List<int> hijoIdList;

  GetEventoActualesParams(this.usuarioId, this.tipoEventoId, this.hijoIdList);

}

class GetEventoActualesResponse {
  List<EventoUi> eventoUiList;
  bool errorServidor;
  bool datosOffline;

  GetEventoActualesResponse(this.eventoUiList, this.errorServidor, this.datosOffline);
}