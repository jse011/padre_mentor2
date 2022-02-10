import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class CerrarCesion extends UseCase<CerrarCesionCaseResponse, CerrarCesionCaseParams>{
  UsuarioAndConfiguracionRepository repository;

  CerrarCesion(this.repository);

  @override
  Future<Stream<CerrarCesionCaseResponse>> buildUseCaseStream(CerrarCesionCaseParams? params) async{
    final controller = StreamController<CerrarCesionCaseResponse>();
    try {
      bool success = await repository.cerrarCesion();
      controller.add(CerrarCesionCaseResponse(success));
      logger.finest('CerrarCesion successful.');
      controller.close();
    } catch (e) {
      logger.severe('CerrarCesion unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }

}

/// Wrapping params inside an object makes it easier to change later
class CerrarCesionCaseParams {



}

/// Wrapping response inside an object makes it easier to change later
class CerrarCesionCaseResponse {
  bool? success;
  CerrarCesionCaseResponse(this.success);
}