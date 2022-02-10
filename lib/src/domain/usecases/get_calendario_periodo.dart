import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';

class GetCalendarioPerido extends UseCase<GetCalendarioPeridoResponse, GetCalendarioPeridoParams>{

  final CursoRepository repository;

  GetCalendarioPerido(this.repository);

  @override
  Future<Stream<GetCalendarioPeridoResponse>> buildUseCaseStream(GetCalendarioPeridoParams? params) async{
    final controller = StreamController<GetCalendarioPeridoResponse>();
    try {

      CalendarioPeriodoUI? calendarioPeriodoUI = null;
      // get user
      final List<CalendarioPeriodoUI> calendarioPeriodoList = await repository.getCalendarioPerios(params?.programaAcademicoId??0, params?.alumnoId??0, params?.anioAcademico??0);


      for(CalendarioPeriodoUI item in calendarioPeriodoList){
          if(item.selected??false){
              calendarioPeriodoUI = item;
          }
      }

      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetCalendarioPeridoResponse(calendarioPeriodoList, calendarioPeriodoUI));
      logger.finest('GetUserUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetUserUseCase unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }

}
class GetCalendarioPeridoResponse{
  List<CalendarioPeriodoUI> calendarioPeriodoList;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  GetCalendarioPeridoResponse(
      this.calendarioPeriodoList, this.calendarioPeriodoUI);
}
class GetCalendarioPeridoParams{
  int? programaAcademicoId;
  int? alumnoId;
  int? anioAcademico;

  GetCalendarioPeridoParams({this.programaAcademicoId, this.alumnoId, this.anioAcademico});

}