import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetPrematicula extends UseCase<GetPrematriculaResponse, GetPrematriculaParams>{

  UsuarioAndConfiguracionRepository repository;

  GetPrematicula(this.repository);

  @override
  Future<Stream<GetPrematriculaResponse>> buildUseCaseStream(GetPrematriculaParams? params) async{
    final controller = StreamController<GetPrematriculaResponse>();
    try {
     String titulo = await repository.gePrematricula();
      controller.add(GetPrematriculaResponse(titulo));
    logger.finest('GetHijo successful.');
    controller.close();
    } catch (e) {
    logger.severe('GetHijo unsuccessful: '+e.toString());
    // Trigger .onError
    controller.addError(e);

    }
    return controller.stream;
  }

}
class GetPrematriculaParams {



}

class GetPrematriculaResponse{
  String? titulo;

  GetPrematriculaResponse(this.titulo);
}