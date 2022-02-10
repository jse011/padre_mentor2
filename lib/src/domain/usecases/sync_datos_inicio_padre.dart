import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class SyncDatosInicioPadre extends UseCase<SyncDatosInicioPadreResponse,SyncDatosInicioPadreParams>{
  final HttpDatosRepository repository;
  final UsuarioAndConfiguracionRepository datosrepository;

  SyncDatosInicioPadre(this.repository, this.datosrepository);

  @override
  Future<Stream<SyncDatosInicioPadreResponse>> buildUseCaseStream(SyncDatosInicioPadreParams? params) async{
    final controller = StreamController<SyncDatosInicioPadreResponse>();
    try {
      int usuarioId = await datosrepository.getSessionUsuarioId();
      String urlServidorLocal = await datosrepository.getSessionUsuarioUrlServidor();
      await datosrepository.saveDatosGlobales(await repository.getDatosInicioPadre(urlServidorLocal, usuarioId));
      controller.add(SyncDatosInicioPadreResponse());
      logger.finest('SyncDatosInicioPadre successful.');
      controller.close();
    } catch (e) {
      logger.severe('SyncDatosInicioPadre unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;

  }

}

class SyncDatosInicioPadreResponse {

}

class SyncDatosInicioPadreParams {
  SyncDatosInicioPadreParams();

}


