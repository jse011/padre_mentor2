import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/get_calendario_periodo.dart';

class HorariosPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  Function getCalendarioPeridoOnNext, getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  final int alumnoId;
  final int programaAcademicoId;
  final int anioAcademicoId;
  final String fotoAlumno;

  HorariosPresenter(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno, DataCursoRepository cursoRepo, DeviceHttpDatosRepositorio httpDatosRepo, UsuarioAndConfiguracionRepository usuarioConfigRepo): _getCalendarioPerido = GetCalendarioPerido(cursoRepo), super();

  @override
  void dispose() {
    _getCalendarioPerido.dispose();
  }

  void getCalendarioPerido(){
    _getCalendarioPerido.execute(_GetCalendarioPeridoCase(this),GetCalendarioPeridoParams(alumnoId: alumnoId, anioAcademico: anioAcademicoId, programaAcademicoId: programaAcademicoId));
  }

}

class _GetCalendarioPeridoCase extends Observer<GetCalendarioPeridoResponse>{
  final HorariosPresenter presenter;

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