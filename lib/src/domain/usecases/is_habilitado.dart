import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class IsHabilitado extends UseCase<IsHabilitadoResponse, IsHabilitadoParams>{

  UsuarioAndConfiguracionRepository repository;
  HttpDatosRepository httpDatosRepository;

  IsHabilitado(this.repository, this.httpDatosRepository);

  @override
  Future<Stream<IsHabilitadoResponse>> buildUseCaseStream(IsHabilitadoParams? params) async{
    final controller = StreamController<IsHabilitadoResponse>();
    try {
      String url = await repository.getSessionUsuarioUrlServidor();
      controller.add(IsHabilitadoResponse(await httpDatosRepository.isHabilitadoUsuario(url, params?.hijoPersonId??0)));
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

}
class IsHabilitadoParams {

 int? hijoPersonId;

 IsHabilitadoParams(this.hijoPersonId);


}

class IsHabilitadoResponse{
  bool? habilitarAcceso;

  IsHabilitadoResponse(this.habilitarAcceso);
}