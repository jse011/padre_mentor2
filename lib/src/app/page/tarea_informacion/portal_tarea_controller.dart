import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/tarea_informacion/portal_tarea_presenter.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class PortalTareaController extends Controller{
  PortalTareaPresenter _presenter;

  TareaEvaluacionCursoUi? tareaEvaluacionCursoUi;
  String? fotoAlumno;
  int? alumnoId;


  PortalTareaController(this.tareaEvaluacionCursoUi, this.fotoAlumno, this.alumnoId, CursoRepository cursoRepository, UsuarioAndConfiguracionRepository configuracionRepository, HttpDatosRepository httpDatosRepository):
        _presenter = PortalTareaPresenter(cursoRepository, configuracionRepository, httpDatosRepository);

  @override
  void initListeners() {
    _presenter.getTareaInfoResponseOnNext = (TareaEvaluacionCursoUi? tareaEvaluacionCursoUi, bool? errorServidor, bool? offlineServidor){
      refreshUI();
    };

    _presenter.getTareaInfoResponseOnError = (e){
      refreshUI();
    };

  }

  @override
  void onInitState() {
    super.onInitState();
    _presenter.getTareaInfo(tareaEvaluacionCursoUi, alumnoId);
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

}