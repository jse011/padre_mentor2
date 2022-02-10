import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/evaluacion/evaluacion_presenter.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class EvaluacionController extends Controller{
  EvaluacionPresenter presenter;
  final int alumnoId;
  final int programaAcademicoId;
  final int anioAcademicoId;
  final String fotoAlumno;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI _calendarioPeriodoUI = null;
  CalendarioPeriodoUI get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<CursoEvaluacionUi> _cursoList = [];
  List<dynamic> _rubroEvaluacionList = [];
  List<dynamic> get rubroEvaluacionList => _rubroEvaluacionList;
  bool _isLoading = false;
  get isLoading => _isLoading;
  String _msgConexion = null;
  String get msgConexion => _msgConexion;
  EvaluacionController(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno, UsuarioAndConfiguracionRepository usuarioConfigRepo, CursoRepository cursoRepo, DeviceHttpDatosRepositorio httpDatosRepo): presenter = EvaluacionPresenter(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, cursoRepo, httpDatosRepo, usuarioConfigRepo), super();

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnNext = (List<CalendarioPeriodoUI> items, CalendarioPeriodoUI calendarioPeriodoUI){
      _calendarioPeriodoList = items;
      _calendarioPeriodoUI = calendarioPeriodoUI;
      refreshUI();
    };
    presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      refreshUI();
    };
    presenter.getCalendarioPeridoOnComplete = (){
      presenter.getEvaluacion(_calendarioPeriodoUI);
    };

    presenter.getEvaluacionOnError = (e){
      _rubroEvaluacionList = [];
      hideProgress();
      refreshUI();
    };

    presenter.getEvaluacionOnNext = (List<dynamic> items, bool errorServidor, bool offlineServidor){
      _cursoList.addAll(List<CursoEvaluacionUi>.from(items.where((element) => element is CursoEvaluacionUi)));
      _rubroEvaluacionList = items;
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = offlineServidor? "No hay Conexión a Internet...":null;
      hideProgress();
      refreshUI();
    };

    presenter.getEvaluacionOnComplete = (){

    };
  }

  @override
  void onInitState() {
    super.onInitState();
    showProgress();
    presenter.getCalendarioPerido();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI.selected = true;
    showProgress();
    presenter.getEvaluacion(calendarioPeriodoUi);
    refreshUI();
  }

  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }

  void successMsg() {
    _msgConexion = null;
  }

  void onClickCurso(CursoEvaluacionUi cursoUi) {
    /*for(CursoEvaluacionUi item in _cursoList)if(cursoUi.cursoUi.silaboEventoId !=  item.cursoUi.silaboEventoId )item.toogle = false;
    cursoUi.toogle = !(cursoUi.toogle??false);

    _rubroEvaluacionList.clear();
    for(CursoEvaluacionUi item in _cursoList){
      _rubroEvaluacionList.add(item);
      if(item.toogle??false){
        _rubroEvaluacionList.addAll(item.evaluacionUiList);
      }
    }

    refreshUI();*/
  }

}