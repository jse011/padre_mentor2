import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/update_session_usuario.dart';

class ValidarUsuario extends UseCase<ValidarUsuarioCaseResponse, ValidarUsuarioCaseParams>{
  UsuarioAndConfiguracionRepository repository;

  ValidarUsuario(this.repository);

  @override
  Future<Stream<ValidarUsuarioCaseResponse>> buildUseCaseStream(ValidarUsuarioCaseParams? params) async{
    final controller = StreamController<ValidarUsuarioCaseResponse>();

    try {
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      if(!await this.repository.validarUsuario())throw Exception("Error validar el usuario");

        controller.add(ValidarUsuarioCaseResponse());
      controller.close();
    } catch (e) {
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}

/// Wrapping params inside an object makes it easier to change later
class ValidarUsuarioCaseParams {
  ValidarUsuarioCaseParams();

}

/// Wrapping response inside an object makes it easier to change later
class ValidarUsuarioCaseResponse {

}