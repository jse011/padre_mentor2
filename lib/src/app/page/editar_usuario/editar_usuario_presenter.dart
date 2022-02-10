import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/update_familia.dart';

class EditarUsuarioPresenter extends Presenter{
  GetSessionUsuarioCase _getSessionUsuarioCase;

  Function getUserOnComplete, getUserOnError, getUserOnNext;
  UpdateFamilia _updateFamilia;
  Function updateFamiliaOnComplete, updateFamiliaOnError, updateFamiliaOnNext;

  EditarUsuarioPresenter(httpRepo, usuarioConfRepo, checkInternetRepo, compresImageRepo):this._getSessionUsuarioCase=GetSessionUsuarioCase(usuarioConfRepo),_updateFamilia = UpdateFamilia(httpRepo, usuarioConfRepo, checkInternetRepo, compresImageRepo);

  void getSessionUsuarioCase(){
    _getSessionUsuarioCase.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  @override
  void dispose() {
    _getSessionUsuarioCase.dispose();
    _updateFamilia.dispose();
  }

  void onSaveFamiliar(UsuarioUi usuarioUi, List<HijosUi> hijoUiList, List<FamiliaUi> familiaUiList) {
    _updateFamilia.execute(_UpdateFamiliaCase(this), UpdateFamiliaCaseParams(usuarioUi, hijoUiList, familiaUiList));
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final EditarUsuarioPresenter presenter;

  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response.usurio);
  }

}

class _UpdateFamiliaCase extends Observer<UpdateFamiliaCaseResponse>{
  EditarUsuarioPresenter presenter;

  _UpdateFamiliaCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.updateFamiliaOnComplete != null);
    presenter.updateFamiliaOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.updateFamiliaOnError != null);
    presenter.updateFamiliaOnError(e);
  }

  @override
  void onNext(UpdateFamiliaCaseResponse response) {
    assert(presenter.updateFamiliaOnNext != null);
    presenter.updateFamiliaOnNext(response.hayconexion);
  }

}