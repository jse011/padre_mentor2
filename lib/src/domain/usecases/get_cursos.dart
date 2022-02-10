import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';

class GetCursos extends UseCase<GetCursosResponse, GetCursosParams>{
  final CursoRepository repository;

  GetCursos(this.repository);

  @override
  Future<Stream<GetCursosResponse>> buildUseCaseStream(GetCursosParams? params) async{
    final controller = StreamController<GetCursosResponse>();
    try {

      final List<CursoUi> cursosUiList = await repository.getCursos(params?.programaAcademicoId??0, params?.alumnoId??0, params?.anioAcademico??0);

      controller.add(GetCursosResponse(cursosUiList));
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

class GetCursosResponse{
  List<CursoUi> cursoUiList;

  GetCursosResponse(this.cursoUiList);
}
class GetCursosParams{
  int? programaAcademicoId;
  int? alumnoId;
  int? anioAcademico;

  GetCursosParams({this.programaAcademicoId, this.alumnoId, this.anioAcademico});

}