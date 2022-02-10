import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/usecases/get_hijo.dart';
import 'package:padre_mentor/src/domain/usecases/get_url_servidor.dart';

class EstadoCuentaPresenter extends Presenter{
  final int alumnoId;
  GetHijo _getHijo;
  Function getHijonNext, getHijoOnComplete, getHijoOnError;
  GetUrlServidor  _getUrlServidor;
  Function getUrlServidorOnNext, getUrlServidorOnComplete, getUrlServidorOnError;

  EstadoCuentaPresenter(this.alumnoId, usuarioCongRepo): _getHijo = GetHijo(usuarioCongRepo), _getUrlServidor = GetUrlServidor(usuarioCongRepo);

  void getHijo(){
    _getHijo.execute(_GetHijoCase(this), GetHijoCaseParams(alumnoId));
  }

  void getUrlServidor(){
    _getUrlServidor.execute(_GetUrlServidorCase(this), GetUrlServidorParams());
  }

  @override
  void dispose() {
    _getHijo.dispose();
  }

}

class _GetHijoCase extends Observer<GetHijoCaseResponse>{
  final EstadoCuentaPresenter presenter;

  _GetHijoCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getHijoOnComplete != null);
    presenter.getHijoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getHijoOnError != null);
    presenter.getHijoOnError(e);
  }

  @override
  void onNext(GetHijoCaseResponse response) {
    assert(presenter.getHijonNext != null);
    presenter.getHijonNext(response.hijosUi);
  }

}

class _GetUrlServidorCase extends Observer<GetUrlServidorResponse>{
  final EstadoCuentaPresenter presenter;

  _GetUrlServidorCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUrlServidorOnComplete != null);
    presenter.getUrlServidorOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUrlServidorOnError != null);
    presenter.getUrlServidorOnError(e);
  }

  @override
  void onNext(GetUrlServidorResponse response) {

    assert(presenter.getUrlServidorOnNext != null);
    presenter.getUrlServidorOnNext(response.url);

  }

}