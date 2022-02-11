import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_tipo_ui.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetAsistenciaGeneral extends UseCase<GetAsistenciaGeneralResponse, GetAsistenciaGeneralParameters>{
  final HttpDatosRepository httprepository;
  final CursoRepository cursoRepository;
  final UsuarioAndConfiguracionRepository usuaConfRepository;


  GetAsistenciaGeneral(
      this.httprepository, this.cursoRepository, this.usuaConfRepository);

  @override
  Future<Stream<GetAsistenciaGeneralResponse>> buildUseCaseStream(GetAsistenciaGeneralParameters? params) async{
    final controller = StreamController<GetAsistenciaGeneralResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;

    try{
      String urlServidorLocal = await usuaConfRepository.getSessionUsuarioUrlServidor();
      Map<String, dynamic>? datosEvaluaciones = await httprepository.getEvaluacionGeneral(urlServidorLocal, params?.calendarioPeridoId??0, params?.alumnoId??0);
      errorServidor = datosEvaluaciones==null;
      if(!errorServidor){
        await cursoRepository.saveAsistenciaGeneral(datosEvaluaciones, params?.calendarioPeridoId??0, params?.alumnoId??0);
      }
    }catch(e){
      offlineServidor = true;
    }


    try {
      List<AsistenciaTipoUi> asistenciaTipoUiList = await cursoRepository.getAsistenciaTipoGeneral( params?.calendarioPeridoId??0, params?.alumnoId??0);
      List<AsistenciaUi> asistenciaAlumnoList = await cursoRepository.getAsistenciaGeneral(params?.calendarioPeridoId??0, params?.alumnoId??0);
      int porcentaje = 0;
      int cantidad = 0;
      for (AsistenciaTipoUi asistenciaTipoUi in asistenciaTipoUiList){
          porcentaje+=asistenciaTipoUi.porcentaje??0;
          cantidad += asistenciaTipoUi.cantidad??0;
      }

      controller.add(GetAsistenciaGeneralResponse(asistenciaAlumnoList, asistenciaTipoUiList, porcentaje, cantidad, offlineServidor, errorServidor));
      logger.finest('GetAsistenciaGeneral successful. size: '+asistenciaAlumnoList.length.toString());
      controller.close();
    } catch (e) {
      logger.severe('GetAsistenciaGeneral unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }

}

class GetAsistenciaGeneralResponse{
  List<AsistenciaTipoUi> asistenciaTipoList;
  int porcentaje = 0;
  int cantidad = 0;
  List<AsistenciaUi> asistenciaAlumnoList;
  bool offlineServidor;
  bool errorServidor;
  GetAsistenciaGeneralResponse(this.asistenciaAlumnoList, this.asistenciaTipoList, this.porcentaje, this.cantidad, this.offlineServidor, this.errorServidor);
}

class GetAsistenciaGeneralParameters{
  final int? calendarioPeridoId;
  final int? alumnoId;

  GetAsistenciaGeneralParameters(this.calendarioPeridoId, this.alumnoId);
}