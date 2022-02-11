import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/get_contactos.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/update_session_usuario.dart';

class ContactosPresenter extends Presenter{
  GetContactos _getContactos;
  late Function getContactosOnNext, getContactosOnComplete, getContactosOnError;
  GetSessionUsuarioCase getSessionUsuarioCase;
  late Function getSesionUsuarioOnNext, getSesionUsuarioOnComplete, getSesionUsuarioOnError;
  UpdateSession updateSession;

  ContactosPresenter(UsuarioAndConfiguracionRepository usuarioConfigRepo, HttpDatosRepository httpRepo, CursoRepository cursoRepo):_getContactos = GetContactos(cursoRepo, httpRepo, usuarioConfigRepo), getSessionUsuarioCase = GetSessionUsuarioCase(usuarioConfigRepo), updateSession = UpdateSession(usuarioConfigRepo);


  @override
  void dispose() {
    _getContactos.dispose();
    getSessionUsuarioCase.dispose();
  }

  void getDatosGenerales(){
    getSessionUsuarioCase.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  void getContactos(UsuarioUi? usuarioUi){
    if(usuarioUi!=null&&usuarioUi.hijoSelected!=null){
      List<int> hijosIdList = [];
      /*for(var hijo in usuarioUi.hijos){
        hijosIdList.add(hijo.personaId);
      }*/
      hijosIdList.add(usuarioUi.hijoSelected?.personaId??0);
      if(_getContactos!=null)_getContactos.dispose();
      _getContactos.execute(_GetContactosCase(this), GetContactosCaseParams(usuarioUi.personaId??0, hijosIdList));
    }
  }

  void onChagenHijo(HijosUi? hijoSelected) {
    if(hijoSelected!=null){
      updateSession.execute(_UpdateSessionCase(this), UpdateSessionParams(hijoSelectedId: hijoSelected.personaId));
    }
  }

}

class _GetContactosCase extends Observer<GetContactosCaseResponse>{
  final ContactosPresenter presenter;
  _GetContactosCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getContactosOnComplete != null);
    presenter.getContactosOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getContactosOnError != null);

    presenter.getContactosOnError(e);
  }

  @override
  void onNext(GetContactosCaseResponse? response) {
    assert(presenter.getContactosOnNext != null);
    presenter.getContactosOnNext(response?.alumnosList, response?.docentesList, response?.directivosList, response?.datosOffline, response?.errorServidor);
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final ContactosPresenter presenter;
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
  final ContactosPresenter presenter;
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