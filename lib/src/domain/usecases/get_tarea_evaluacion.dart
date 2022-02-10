import 'dart:async';
import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

import 'get_boleta_nota.dart';

class GetTareaEvaluacion extends UseCase<GetTareaEvaluacionCaseResponse, GetTareaEvaluacionCaseParams>{

  final HttpDatosRepository httprepository;
  final CursoRepository repository;
  final UsuarioAndConfiguracionRepository usuaConfRepository;
  GetTareaEvaluacion(this.httprepository, this.repository, this.usuaConfRepository);

  @override
  Future<Stream<GetTareaEvaluacionCaseResponse>> buildUseCaseStream(GetTareaEvaluacionCaseParams? params) async{
    final controller = StreamController<GetTareaEvaluacionCaseResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;
    try{
      String urlServidorLocal = await usuaConfRepository.getSessionUsuarioUrlServidor();
      Map<String, dynamic>? datosTareas = await httprepository.getTareaPorCurso(urlServidorLocal, params?.anioAcademicoId??0, params?.programaId??0, params?.calendarioPeridoId??0, params?.alumnoId??0);
      errorServidor = datosTareas==null;
      if(!errorServidor){
        await repository.saveTareaEvaluaciones(datosTareas, params?.anioAcademicoId??0, params?.programaId??0, params?.calendarioPeridoId??0, params?.alumnoId??0);
      }
    }catch(e){
      offlineServidor = true;
    }

    try {
      List<dynamic> lista = [];
      List<TareaEvaluacionCursoUi> tareaEvalList = await repository.getTareaEvaluacionPorCurso(params?.anioAcademicoId??0, params?.programaId??0, params?.calendarioPeridoId??0, params?.alumnoId??0);
      var vobj_days = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
      var vobj_Meses = ["Ene.", "Feb.", "Mar.", "Abr.", "May.", "Jun.", "Jul.", "Ago.", "Sep.", "Oct.", "Nov.", "Dic."];
      int calificado = 0;
      int sinCalificar = 0;
      for(TareaEvaluacionCursoUi tareaItem in tareaEvalList){
        CursoUi? cursoUi = tareaItem.cursoUi;
        CursoUi search = lista.firstWhere((element)=> element is CursoUi? element.silaboEventoId==cursoUi?.silaboEventoId :false, orElse: () => null);
        if(search == null){
          lista.add(cursoUi);
        }
        lista.add(tareaItem);

        DateTime? fechaIncio =  tareaItem.fechaInicio;
        DateTime? fechaEntrega = tareaItem.fechaEntrega;
        if(fechaIncio!=null && fechaIncio.millisecondsSinceEpoch>912402000000){
          tareaItem.incioMes = vobj_Meses[fechaIncio.month-1];
          tareaItem.incioDia = fechaIncio.day.toString();
          tareaItem.incioDiaSemana = vobj_days[fechaIncio.weekday-1];
        }
        if(fechaEntrega!=null && fechaEntrega.millisecondsSinceEpoch>912402000000){
          tareaItem.finMes = vobj_Meses[fechaEntrega.month-1];
          tareaItem.finDia = fechaEntrega.day.toString();
          tareaItem.finDiaSemana = vobj_days[fechaEntrega.weekday-1];
        }

        tareaItem.evalEstado = TareaEvalEstadoEnumUi.HA_ENTREGAR;
        if(tareaItem.rubroEvaluacionId!=null&&(tareaItem.rubroEvaluacionId??"").length > 0){
          tareaItem.evalEstado = TareaEvalEstadoEnumUi.ENTREGADO;
          //countCalificadas++;
          calificado++;
        }else{
          sinCalificar++;
          if(fechaEntrega==null||(fechaEntrega!=null&&fechaEntrega.millisecondsSinceEpoch<=912402000000)){
            tareaItem.evalEstado = TareaEvalEstadoEnumUi.SINFECHA;
            //countHaEntregar++;
          }else {
            var fechaActual =  DateTime.now();
            fechaActual = new DateTime(fechaActual.year, fechaActual.month, fechaActual.day, fechaActual.hour, fechaActual.minute, 0,0, 0);
            fechaEntrega = DateTime(fechaEntrega.year, fechaEntrega.month, fechaEntrega.day, fechaEntrega.hour, fechaEntrega.minute, 0,0, 0);

            var isMayor = fechaActual.compareTo(fechaEntrega) > 0;

            if(isMayor){
              tareaItem.evalEstado = TareaEvalEstadoEnumUi.HA_ENTREGAR_RETRAZO;

            }else {
              tareaItem.evalEstado = TareaEvalEstadoEnumUi.HA_ENTREGAR;
              //countHaEntregar++;
            }

          }
        }

      }
      controller.add(GetTareaEvaluacionCaseResponse(lista, calificado, sinCalificar, offlineServidor, errorServidor));
    logger.finest('GetTareaEvaluacion successful.');
    controller.close();
    } catch (e) {
    logger.severe('GetTareaEvaluacion unsuccessful: '+e.toString());
    // Trigger .onError
    controller.addError(e);

    }
    return controller.stream;
  }

}
/// Wrapping params inside an object makes it easier to change later
class GetTareaEvaluacionCaseParams {
  final int anioAcademicoId;
  final int programaId;
  final int calendarioPeridoId;
  final int alumnoId;

  GetTareaEvaluacionCaseParams(this.anioAcademicoId, this.programaId,
      this.calendarioPeridoId, this.alumnoId);
}

/// Wrapping response inside an object makes it easier to change later
class GetTareaEvaluacionCaseResponse {
    List<dynamic> rubroEvaluacionList;
    int cantCalificado;
    int cantSinCalifacar;
    bool offlineServidor;
    bool errorServidor;

    GetTareaEvaluacionCaseResponse(
      this.rubroEvaluacionList, this.cantCalificado, this.cantSinCalifacar, this.offlineServidor, this.errorServidor);
}