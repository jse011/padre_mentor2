import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class GetIconoPadre extends UseCase<GetIconoPadreResponse, GetIconoPadreParams>{
  UsuarioAndConfiguracionRepository usuarioAndConfiguracionRepository;

  GetIconoPadre(this.usuarioAndConfiguracionRepository);

  @override
  Future<Stream<GetIconoPadreResponse>> buildUseCaseStream(GetIconoPadreParams? params)async {
    final controller = StreamController<GetIconoPadreResponse>();
    try {
      controller.add(GetIconoPadreResponse(await usuarioAndConfiguracionRepository.getIconoPadre()));
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
class GetIconoPadreParams{

}

class GetIconoPadreResponse{
  String? logo;

  GetIconoPadreResponse(this.logo);
}