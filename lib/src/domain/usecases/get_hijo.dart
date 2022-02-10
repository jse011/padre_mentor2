import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetHijo extends UseCase<GetHijoCaseResponse, GetHijoCaseParams>{
  UsuarioAndConfiguracionRepository repository;

  GetHijo(this.repository);

  @override
  Future<Stream<GetHijoCaseResponse>> buildUseCaseStream(GetHijoCaseParams? params) async{
    final controller = StreamController<GetHijoCaseResponse>();
    try {
      controller.add(GetHijoCaseResponse(await repository.getHijo(params?.alumnoId??0)));
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
/// Wrapping params inside an object makes it easier to change later
class GetHijoCaseParams {
  final int? alumnoId;

  GetHijoCaseParams(this.alumnoId);
}

/// Wrapping response inside an object makes it easier to change later
class GetHijoCaseResponse {
  HijosUi hijosUi;

  GetHijoCaseResponse(this.hijosUi);
}