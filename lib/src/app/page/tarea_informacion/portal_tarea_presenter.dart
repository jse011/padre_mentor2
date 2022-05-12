import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/get_tarea_info.dart';

class PortalTareaPresenter extends Presenter{
  GetTareaInfo _getTareaInfo;
  late Function getTareaInfoResponseOnError, getTareaInfoResponseOnNext;

  PortalTareaPresenter(CursoRepository cursoRepository, UsuarioAndConfiguracionRepository configuracionRepository, HttpDatosRepository httpDatosRepository):
        this._getTareaInfo = GetTareaInfo(httpDatosRepository, cursoRepository, configuracionRepository);


  void getTareaInfo(TareaEvaluacionCursoUi? tareaEvaluacionCursoUi, int? hijoPersonaId){
    _getTareaInfo.execute(_GetRubroInfoCase(this), GetTareaInfoParms(tareaEvaluacionCursoUi, hijoPersonaId));
  }

  @override
  void dispose() {
    _getTareaInfo.dispose();
  }

}

class _GetRubroInfoCase extends Observer<GetTareaInfoResponse>{
  final PortalTareaPresenter presenter;

  _GetRubroInfoCase(this.presenter);

  @override
  void onComplete() {
  }

  @override
  void onError(e) {
    assert(presenter.getTareaInfoResponseOnError != null);
    presenter.getTareaInfoResponseOnError(e);
  }

  @override
  void onNext(GetTareaInfoResponse ? response) {
    assert(presenter.getTareaInfoResponseOnNext != null);
    presenter.getTareaInfoResponseOnNext(response?.tareaEvaluacionCursoUi, response?.errorServidor, response?.offlineServidor);
  }

}
