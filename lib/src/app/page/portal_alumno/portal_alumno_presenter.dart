import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/programa_educativo_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/usecases/get_eventos_top.dart';
import 'package:padre_mentor/src/domain/usecases/get_prematricula.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/is_habilitado.dart';
import 'package:padre_mentor/src/domain/usecases/update_session_usuario.dart';

class PortalAlumnoPresenter extends Presenter{
  GetSessionUsuarioCase getSessionUsuarioCase;
  late Function getSesionUsuarioOnNext;
  late Function getSesionUsuarioOnComplete;
  late Function getSesionUsuarioOnError;
  UpdateSession updateSession;
  GetPrematicula getPrematicula;
  late Function getPrematiculaOnNext, getPrematiculaOnComplete, getPrematiculaOnError;

  GetEventoActuales _getEventoActuales;
  late Function getEventoActualesOnNext, getEventoActualesOnComplete, getEventoActualesOnError;
  final IsHabilitado _isHabilitado;
  late Function isHabilitadoOnError, isHabilitadoOnComplete;

  PortalAlumnoPresenter(checkConexRepo, httpRepository, usuarioConfiRepo ):getSessionUsuarioCase = GetSessionUsuarioCase(usuarioConfiRepo), updateSession = UpdateSession(usuarioConfiRepo), _getEventoActuales = GetEventoActuales(checkConexRepo, usuarioConfiRepo, httpRepository), getPrematicula = GetPrematicula(usuarioConfiRepo), _isHabilitado = IsHabilitado(usuarioConfiRepo, httpRepository);

  @override
  void dispose() {
    getPrematicula.dispose();
    getSessionUsuarioCase.dispose();
    updateSession.dispose();
    _getEventoActuales.dispose();
    _isHabilitado.dispose();
  }



  void getDatosGenerales(){
    getSessionUsuarioCase.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  void getEventoActuales(int? usuarioId, int tipoEventoId, List<int> hijoIdList){
    //if(_getEventoActuales!=null)_getEventoActuales.dispose();
    _getEventoActuales.execute(_GetEventoActualesCase(this), GetEventoActualesParams(usuarioId, tipoEventoId, hijoIdList));
  }

  void onInitState() {
    getPrematicula.execute(_GetPrematriculaCase(this),GetPrematriculaParams());
    getDatosGenerales();
  }

  void onSaveProgramaUsuario(ProgramaEducativoUi? programaEducativoSelected) {
    if(programaEducativoSelected!=null){
      updateSession.execute(_UpdateSessionCase(this), UpdateSessionParams(programaAcademicoId: programaEducativoSelected.programaId, anioAcademicoId: programaEducativoSelected.anioAcademicoId, hijoSelectedId: programaEducativoSelected.hijoId));
    }
  }

  void isHabilitado(int? hijoPersonaId){
    _isHabilitado.execute(_IsHabilitadoUseCase(this), IsHabilitadoParams(hijoPersonaId));
  }

  void onChangeUsuario(UsuarioUi? usuarioUi, selectedTipoEventoUi) {
    if(usuarioUi==null)return;
    List<int> hijosIdList = [];
    for(var hijo in usuarioUi.hijos??[]){
      hijosIdList.add(hijo.personaId);
    }
    /*if(usuarioUi.hijoSelected!=null){
      hijosIdList.add(usuarioUi.hijoSelected.personaId);
    }*/
    getEventoActuales(usuarioUi.personaId, selectedTipoEventoUi!=null?selectedTipoEventoUi.personaId:0, hijosIdList);
  }

}

class _GetEventoActualesCase extends Observer<GetEventoActualesResponse>{
  final PortalAlumnoPresenter presenter;

  _GetEventoActualesCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getSesionUsuarioOnComplete != null);
    presenter.getSesionUsuarioOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getSesionUsuarioOnError != null);
    presenter.getSesionUsuarioOnError(e);
  }

  @override
  void onNext(GetEventoActualesResponse? response) {
    assert(presenter.getEventoActualesOnNext != null);
    presenter.getEventoActualesOnNext(response?.eventoUiList, response?.errorServidor);
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final PortalAlumnoPresenter presenter;
  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getSesionUsuarioOnComplete != null);
    presenter.getSesionUsuarioOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getSesionUsuarioOnError != null);
    presenter.getSesionUsuarioOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getSesionUsuarioOnNext != null);
    presenter.getSesionUsuarioOnNext(response?.usurio);
  }

}

class _UpdateSessionCase extends Observer<UpdateSessionResponse>{
  final PortalAlumnoPresenter presenter;
  _UpdateSessionCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {

  }

  @override
  void onNext(UpdateSessionResponse? response) {

  }

}

class _GetPrematriculaCase extends Observer<GetPrematriculaResponse>{
  final PortalAlumnoPresenter presenter;
  _GetPrematriculaCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getPrematiculaOnComplete != null);
    presenter.getPrematiculaOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getPrematiculaOnError != null);
    presenter.getPrematiculaOnError(e);
  }

  @override
  void onNext(GetPrematriculaResponse? response) {
    assert(presenter.getPrematiculaOnNext != null);
    presenter.getPrematiculaOnNext(response?.titulo);
  }

}

class _IsHabilitadoUseCase extends Observer<IsHabilitadoResponse>{
  final PortalAlumnoPresenter presenter;

  _IsHabilitadoUseCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.isHabilitadoOnError != null);
    presenter.isHabilitadoOnError(e);
  }

  @override
  void onNext(IsHabilitadoResponse? response) {
    assert(presenter.isHabilitadoOnComplete != null);
    presenter.isHabilitadoOnComplete(response?.habilitarAcceso);
  }

}