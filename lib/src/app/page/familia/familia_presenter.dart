import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/update_familia.dart';

class FamiliaPresenter extends Presenter{
  GetSessionUsuarioCase getSessionUsuarioCase;
  late Function getSesionUsuarioOnNext, getSesionUsuarioOnComplete,  getSesionUsuarioOnError;

  FamiliaPresenter(httpRepo, usuarioConfiRepo ):getSessionUsuarioCase = GetSessionUsuarioCase(usuarioConfiRepo);

  @override
  void dispose() {
    getSessionUsuarioCase.dispose();
  }

  void onInitState() {
    getDatosGenerales();
  }

  void getDatosGenerales(){
    getSessionUsuarioCase.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }


}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final FamiliaPresenter presenter;
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
