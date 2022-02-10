import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/usecases/get_cursos.dart';

class CursoPresenter extends Presenter{
  GetCursos _getCursos;
  Function getCursosOnComple, getCursosOnError, getCursosOnNext;
  CursoPresenter(cursoRepo):this._getCursos=GetCursos(cursoRepo);

  void getCursos(alumnoId, programaAcademicoId, anioAcademicoId){
    _getCursos.execute(_GetCursoCaseState(this), GetCursosParams(alumnoId: alumnoId, programaAcademicoId: programaAcademicoId, anioAcademico: anioAcademicoId));
  }

  @override
  void dispose() {
    _getCursos.dispose();
  }

}

class _GetCursoCaseState extends Observer<GetCursosResponse>{
  CursoPresenter presenter;


  _GetCursoCaseState(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getCursosOnComple != null);
    presenter.getCursosOnComple();
  }

  @override
  void onError(e) {
    assert(presenter.getCursosOnError != null);
    presenter.getCursosOnError(e);
  }

  @override
  void onNext(GetCursosResponse response) {
    assert(presenter.getCursosOnNext != null);
    presenter.getCursosOnNext(response.cursoUiList);
  }

}