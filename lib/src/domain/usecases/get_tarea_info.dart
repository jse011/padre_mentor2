import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:collection/collection.dart';
import 'package:padre_mentor/src/data/repositories/moor/database/app_database.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetTareaInfo extends UseCase<GetTareaInfoResponse, GetTareaInfoParms>{

  HttpDatosRepository httpDatosRepository;
  CursoRepository cursoRepository;
  UsuarioAndConfiguracionRepository configuracionRepository;


  GetTareaInfo(this.httpDatosRepository, this.cursoRepository,
      this.configuracionRepository);

  @override
  Future<Stream<GetTareaInfoResponse?>> buildUseCaseStream(GetTareaInfoParms? params) async{
    final controller = StreamController<GetTareaInfoResponse>();
    bool errorServidor = false;
    bool offlineServidor = false;

    try{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      Map<String, dynamic>? mapTarea = await httpDatosRepository.getInfoTarea(urlServidorLocal, params?.tareaEvaluacionCursoUi?.tareaId, params?.tareaEvaluacionCursoUi?.evaluacionProcesoId, params?.tareaEvaluacionCursoUi?.rubroEvaluacionId, params?.hijoPersonId, params?.tareaEvaluacionCursoUi?.unidadAprendizajeId, params?.tareaEvaluacionCursoUi?.cursoUi?.silaboEventoId);
      errorServidor = mapTarea==null;
      if(!errorServidor){
        cursoRepository.saveInfoTarea(mapTarea, params?.tareaEvaluacionCursoUi?.tareaId, params?.tareaEvaluacionCursoUi?.evaluacionProcesoId, params?.tareaEvaluacionCursoUi?.rubroEvaluacionId, params?.hijoPersonId);
      }
      //String? tareaId, int? evaluacionId, String? rubroEvaluacionId, int alumnoId, int? unidadEventoId, int? silaboEventoId
    } catch (e) {
      offlineServidor = true;
    }
    TareaEvaluacionCursoUi? tareaEvaluacionCursoUi = params?.tareaEvaluacionCursoUi;
    TareaEvaluacionCursoUi? tareaEvaluacionCursoUiInfo = await cursoRepository.getInfoTarea(params?.tareaEvaluacionCursoUi?.tareaId, params?.hijoPersonId);
    tareaEvaluacionCursoUi?.estadoEntregado = tareaEvaluacionCursoUiInfo.estadoEntregado;
    if( tareaEvaluacionCursoUi?.estadoEntregado == TareaEstadoEntregado.ENTREGADO){
      DateTime? alumno = DateTime.fromMillisecondsSinceEpoch(tareaEvaluacionCursoUiInfo.fechaEntregaAlumno??0);
      bool? isbefore = tareaEvaluacionCursoUi?.fechaEntrega?.isBefore(alumno);//Validar si la tarea se entrego antes
      tareaEvaluacionCursoUi?.estadoEntregado = (isbefore??false)?TareaEstadoEntregado.ENTREGADO_RETRASO : TareaEstadoEntregado.ENTREGADO;
    }else if(tareaEvaluacionCursoUi?.estadoEntregado == TareaEstadoEntregado.SIN_ENTREGAR){
      if((tareaEvaluacionCursoUiInfo.tareaId??"").isEmpty){
        tareaEvaluacionCursoUi?.estadoEntregado = errorServidor||offlineServidor? TareaEstadoEntregado.CARGANDO:TareaEstadoEntregado.SIN_ENTREGAR;
      }else {
        tareaEvaluacionCursoUi?.estadoEntregado = TareaEstadoEntregado.SIN_ENTREGAR;
      }

    }


    for (TareaAlumnoArchivoUi tareaAlumnoArchivoUi in tareaEvaluacionCursoUiInfo.alumnoArchivoUiList??[]){
      tareaAlumnoArchivoUi.unidadAprendizajeId = tareaEvaluacionCursoUi?.unidadAprendizajeId;
      tareaAlumnoArchivoUi.entregado = tareaEvaluacionCursoUiInfo.estadoEntregado == TareaEstadoEntregado.ENTREGADO_RETRASO||
          tareaEvaluacionCursoUiInfo.estadoEntregado == TareaEstadoEntregado.ENTREGADO;

    }
    tareaEvaluacionCursoUi?.alumnoArchivoUiList = tareaEvaluacionCursoUiInfo.alumnoArchivoUiList;
    tareaEvaluacionCursoUi?.recursoArchivoUiList = tareaEvaluacionCursoUiInfo.recursoArchivoUiList;

    controller.add(GetTareaInfoResponse(tareaEvaluacionCursoUi, offlineServidor, errorServidor));
    controller.close();

    return controller.stream;
  }
}

class GetTareaInfoParms{
  TareaEvaluacionCursoUi? tareaEvaluacionCursoUi;
  int? hijoPersonId;

  GetTareaInfoParms(
      this.tareaEvaluacionCursoUi, this.hijoPersonId);
}

class GetTareaInfoResponse{
  TareaEvaluacionCursoUi? tareaEvaluacionCursoUi;
  bool? offlineServidor;
  bool? errorServidor;

  GetTareaInfoResponse(this.tareaEvaluacionCursoUi, this.offlineServidor, this.errorServidor);
}