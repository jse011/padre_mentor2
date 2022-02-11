import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/tarea_evaluacion/tarea_evaluacion_presenter.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';

class TareaEvaluacionController extends Controller{
  TareaEvaluacionPresenter presenter;
  final int alumnoId;
  final int programaAcademicoId;
  final int anioAcademicoId;
  final String fotoAlumno;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];

  String? _msgConexion = null;
  String? get msgConexion => _msgConexion;
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<dynamic> _rubroEvaluacionList = [];
  List<dynamic> get rubroEvaluacionList => _rubroEvaluacionList;
  bool _isLoading = false;
  get isLoading => _isLoading;
  int _cantCalificado = 0;
  get cantCalificado => _cantCalificado;
  int _cantSinCalificar = 0;
  get cantSinCalificar => _cantSinCalificar;


  TareaEvaluacionController(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno,usuarioConfigRepo, cursoRepo, httpDatosRepo): presenter = TareaEvaluacionPresenter(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, usuarioConfigRepo, cursoRepo, httpDatosRepo), super();

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnNext = (List<CalendarioPeriodoUI>? items, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = items??[];
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
      _msgConexion = "!Oops! Al parecer ocurrió un error involuntario.";
      hideProgress();
      refreshUI();
    };

    presenter.getEvaluacionOnNext = (List<dynamic>? items, int? cantCalificado, int? cantSinCalificar, bool? offlineServidor, bool? errorServidor){
      _rubroEvaluacionList = items??[];
      _cantCalificado = cantCalificado??0;
      _cantSinCalificar = cantSinCalificar??0;
      _msgConexion = (errorServidor??false)? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = (offlineServidor??false)? "No hay Conexión a Internet...":null;
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
    calendarioPeriodoUI?.selected = true;
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

}