import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/check_conex_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/get_evento_agenda.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/update_session_usuario.dart';

class EventoAgendaPresenter extends Presenter{

  GetSessionUsuarioCase getSessionUsuarioCase;
  late Function getSesionUsuarioOnNext, getSesionUsuarioOnComplete, getSesionUsuarioOnError;

  GetEventoAgenda _getEventoAgenda;
  late Function getEventoAgendaOnNext, getEventoAgendaOnComplete, getEventoAgendaOnError;
  UpdateSession updateSession;

  EventoAgendaPresenter(UsuarioAndConfiguracionRepository usuarioRepo, HttpDatosRepository httpRepo): this._getEventoAgenda = GetEventoAgenda( usuarioRepo, httpRepo), this.getSessionUsuarioCase = GetSessionUsuarioCase(usuarioRepo), updateSession = UpdateSession(usuarioRepo);

  void getEventoAgenda(int? usuarioId, int? tipoEventoId, List<int>? hijoIdList){
    _getEventoAgenda.execute(_GetEventoAgendaCase(this), GetEventoAgendaParams(usuarioId, tipoEventoId, hijoIdList));
  }

  void getDatosGenerales(){
    getSessionUsuarioCase.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  void onInitState() {
    print("GetEventoAgenda onInitState");
    getDatosGenerales();
  }

  @override
  void dispose() {
    _getEventoAgenda.dispose();
    getSessionUsuarioCase.dispose();
    updateSession.dispose();
  }

  void onChangeUsuario(UsuarioUi? usuarioUi, TipoEventoUi? selectedTipoEventoUi) {
    if(usuarioUi==null)return;
    List<int> hijosIdList = [];
    /*for(var hijo in usuarioUi.hijos){
      hijosIdList.add(hijo.personaId);
    }*/
    if(usuarioUi.hijoSelected!=null){
      hijosIdList.add(usuarioUi.hijoSelected?.personaId??0);
    }
    getEventoAgenda(usuarioUi.personaId, selectedTipoEventoUi!=null?selectedTipoEventoUi.id:0, hijosIdList);
  }

  void onChagenHijo(HijosUi? hijoSelected) {
    if(hijoSelected!=null){
      updateSession.execute(_UpdateSessionCase(this), UpdateSessionParams(hijoSelectedId: hijoSelected.personaId));
    }
  }

}

class _GetEventoAgendaCase extends Observer<GetEvaluacionCaseResponse>{
  final EventoAgendaPresenter presenter;

  _GetEventoAgendaCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getEventoAgendaOnComplete != null);
    presenter.getEventoAgendaOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getEventoAgendaOnError != null);
    presenter.getEventoAgendaOnError(e);
  }

  @override
  void onNext(GetEvaluacionCaseResponse? response) {
    assert(presenter.getEventoAgendaOnNext != null);
    presenter.getEventoAgendaOnNext(response?.tipoEventoUiList, response?.eventoUiList, response?.errorServidor, response?.datosOffline);
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final EventoAgendaPresenter presenter;
  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getSesionUsuarioOnComplete != null);
    print("_GetSessionUsuarioCase onComplete");
    presenter.getSesionUsuarioOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getSesionUsuarioOnError != null);
    print("_GetSessionUsuarioCase onError");
    presenter.getSesionUsuarioOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getSesionUsuarioOnNext != null);
    print("_GetSessionUsuarioCase onNext");
    presenter.getSesionUsuarioOnNext(response?.usurio);
  }

}

class _UpdateSessionCase extends Observer<UpdateSessionResponse>{
  final EventoAgendaPresenter presenter;
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