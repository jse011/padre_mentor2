import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetUrlServidor extends UseCase<GetUrlServidorResponse, GetUrlServidorParams>{

  UsuarioAndConfiguracionRepository repository;

  GetUrlServidor(this.repository);

  @override
  Future<Stream<GetUrlServidorResponse>> buildUseCaseStream(GetUrlServidorParams? params) async{
    final controller = StreamController<GetUrlServidorResponse>();
    try {
      String url = await repository.getSessionUsuarioUrlServidor();
      controller.add(GetUrlServidorResponse(url));
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

}
class GetUrlServidorParams {



}

class GetUrlServidorResponse{
  String url;

  GetUrlServidorResponse(this.url);
}