import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/usecases/get_rubro_info.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';

class EvaluacionInformacionPresenter extends Presenter{
  late Function getUserOnNext, getUserOnError;
  final GetSessionUsuarioCase getUsuarioUseCase;
  GetRubroInfo _getRubroInfo;
  late Function getRubroInfoResponseOnError, getRubroInfoResponseOnNext;

  EvaluacionInformacionPresenter(httpDatosRepository, cursoRepository, configuracionRepository, usuarioConfigRepo):
        _getRubroInfo = GetRubroInfo(httpDatosRepository, cursoRepository, configuracionRepository),
        getUsuarioUseCase = GetSessionUsuarioCase(usuarioConfigRepo);


  void getRubroInfo(String? rubroEvaluacionId, int? alumnoId){
    _getRubroInfo.execute(_GetRubroInfoCase(this), GetRubroInfoParms(rubroEvaluacionId, alumnoId));
  }

  void getUserSession() {
    print('getUserSession GO');

    // execute getUseruserCase
    getUsuarioUseCase.execute(
        _GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  @override
  void dispose() {
    _getRubroInfo.dispose();
    getUsuarioUseCase.dispose();
  }

}

class _GetRubroInfoCase extends Observer<GetRubroInfoResponse>{
  final EvaluacionInformacionPresenter presenter;

  _GetRubroInfoCase(this.presenter);

  @override
  void onComplete() {
  }

  @override
  void onError(e) {
    assert(presenter.getRubroInfoResponseOnError != null);
    presenter.getRubroInfoResponseOnError(e);
  }

  @override
  void onNext(GetRubroInfoResponse? response) {
    assert(presenter.getRubroInfoResponseOnNext != null);
    presenter.getRubroInfoResponseOnNext(response?.rubroEvaluacionUi, response?.errorServidor, response?.offlineServidor);
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final EvaluacionInformacionPresenter presenter;

  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() { }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response?.usurio);
  }

}