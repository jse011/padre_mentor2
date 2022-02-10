import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_boleta_ui.dart';
import 'package:padre_mentor/src/domain/usecases/get_boleta_nota.dart';
import 'package:padre_mentor/src/domain/usecases/get_calendario_periodo.dart';

class BoletaNotasPresenter extends Presenter{

  final int programaAcademicoId;
  final int alumnoId;
  final int anioAcademicoId;
  GetCalendarioPerido _getCalendarioPerido;
  Function getCalendarioPeridoOnNext, getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  GetBoletaNota _getBoletaNota;
  Function getBoletaNotaOnNext, getBoletaNotaOnComplete, getBoletaNotaOnError;


  BoletaNotasPresenter(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, usuarioConfigRepo, cursoRepo, httpRepo):_getCalendarioPerido = GetCalendarioPerido(cursoRepo), _getBoletaNota = GetBoletaNota(httpRepo, cursoRepo, usuarioConfigRepo);

  @override
  void dispose() {
    _getCalendarioPerido.dispose();
    _getBoletaNota.dispose();
  }

  void getCalendarioPerido(){
    _getCalendarioPerido.execute(_GetCalendarioPeridoCase(this),GetCalendarioPeridoParams(alumnoId: alumnoId, anioAcademico: anioAcademicoId, programaAcademicoId: programaAcademicoId));
  }

  void getBoletaNota(CalendarioPeriodoUI calendarioPeriodoUI){
    _getBoletaNota.execute(_GetBoletaNotaCase(this),GetBoletaNotaParams(alumnoId: alumnoId, anioAcademicoId: anioAcademicoId, programaId: programaAcademicoId, calendarioPeridoId: calendarioPeriodoUI==null?0:calendarioPeriodoUI.id, georeferenciaId: 0));
  }

}

class _GetCalendarioPeridoCase extends Observer<GetCalendarioPeridoResponse>{
  final BoletaNotasPresenter presenter;

  _GetCalendarioPeridoCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getCalendarioPeridoOnComplete != null);
    presenter.getCalendarioPeridoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getCalendarioPeridoOnError != null);
    presenter.getCalendarioPeridoOnError(e);
  }

  @override
  void onNext(GetCalendarioPeridoResponse response) {
    assert(presenter.getCalendarioPeridoOnNext != null);
    presenter.getCalendarioPeridoOnNext(response.calendarioPeriodoList, response.calendarioPeriodoUI);
  }

}

class _GetBoletaNotaCase extends Observer<GetBoletaNotaResponse>{
  final BoletaNotasPresenter presenter;

  _GetBoletaNotaCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getBoletaNotaOnComplete != null);
    presenter.getBoletaNotaOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getBoletaNotaOnError != null);
    presenter.getBoletaNotaOnError(e);
  }

  @override
  void onNext(GetBoletaNotaResponse response) {
    assert(presenter.getBoletaNotaOnNext != null);
    List<CursoBoletaUi> cursoBoletaUiList = [];
    for(var parent in response.cursoBoletaUiList){
      parent.padre = true;
      cursoBoletaUiList.add(parent);
      if(parent.cursoBoletaUiList!=null){
        for(var hijo in parent.cursoBoletaUiList){
          hijo.padre = false;
          cursoBoletaUiList.add(hijo);
        }
      }
    }
    presenter.getBoletaNotaOnNext(cursoBoletaUiList, response.errorServidor, response.offlineServidor);
  }

}