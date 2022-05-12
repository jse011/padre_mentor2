import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:collection/collection.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetRubroInfo extends UseCase<GetRubroInfoResponse, GetRubroInfoParms>{

  HttpDatosRepository httpDatosRepository;
  CursoRepository cursoRepository;
  UsuarioAndConfiguracionRepository configuracionRepository;


  GetRubroInfo(this.httpDatosRepository, this.cursoRepository,
      this.configuracionRepository);

  @override
  Future<Stream<GetRubroInfoResponse?>> buildUseCaseStream(GetRubroInfoParms? params) async{
    final controller = StreamController<GetRubroInfoResponse>();
    bool errorServidor = false;
    bool offlineServidor = false;

    try{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      Map<String, dynamic>? mapRubro = await httpDatosRepository.getRubroInfo(urlServidorLocal, params?.rubroEvaluacionId, params?.hijoPersonId);
      errorServidor = mapRubro==null;
      if(!errorServidor){
        cursoRepository.saveRubroInfo(mapRubro, params?.rubroEvaluacionId, params?.hijoPersonId);
      }

    } catch (e) {
      logger.severe('GetRubroEvaluacion unsuccessful: '+e.toString());
      offlineServidor = true;
    }

    RubroEvaluacionUi? rubroEvaluacionUi = await cursoRepository.getRubroInfo(params?.rubroEvaluacionId, params?.hijoPersonId);

    controller.add(GetRubroInfoResponse(rubroEvaluacionUi, offlineServidor, errorServidor));
    controller.close();

    return controller.stream;
  }
}

class GetRubroInfoParms{
  String? rubroEvaluacionId;
  int? hijoPersonId;

  GetRubroInfoParms(this.rubroEvaluacionId, this.hijoPersonId);
}

class GetRubroInfoResponse{
  RubroEvaluacionUi? rubroEvaluacionUi;
  bool? offlineServidor;
  bool? errorServidor;

  GetRubroInfoResponse(this.rubroEvaluacionUi, this.offlineServidor, this.errorServidor);
}