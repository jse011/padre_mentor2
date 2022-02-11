import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/asistencia/asistencia_presenter.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_tipo_ui.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_ui.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';

class AsistenciaController extends Controller{
  AsistenciaPresenter presenter;
  final int? alumnoId;
  final int? programaAcademicoId;
  final int? anioAcademicoId;
  final String fotoAlumno;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  List<AsistenciaTipoUi> _asistenciaTipoList = [];
  List<AsistenciaTipoUi> get asistenciaTipoList => _asistenciaTipoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<dynamic> _asistenciaAlumnoList = [];
  List<dynamic> get aistenicaAlumnoList => _asistenciaAlumnoList;
  bool _isLoadingCurso = false;
  get isLoadingCurso => _isLoadingCurso;
  bool _isLoadingGeneral = false;
  get isLoadingGeneral => _isLoadingGeneral;
  String? _msgConexion = null;
  String? get msgConexion => _msgConexion;
  int _porcentaje = 0;
  int get porcentaje => _porcentaje;
  int _cantidad = 0;
  int get cantidad => _cantidad;

  List<AsistenciaUi> _asistenciaGeneralList = [];
  List<AsistenciaUi> get asistenciaGeneralList => _asistenciaGeneralList;
  int _porcentajeGeneral = 0;
  int get porcentajeGeneral => _porcentajeGeneral;
  int _cantidadGeneral = 0;
  int get cantidadGeneral => _cantidadGeneral;
  List<AsistenciaTipoUi> _asistenciaTipoGeneralList = [];
  List<AsistenciaTipoUi> get asistenciaTipoGeneralList => _asistenciaTipoGeneralList;


  AsistenciaController(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno, usuarioConfigRepo, cursoRepo, httpDatosRepo): presenter = AsistenciaPresenter(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, cursoRepo, httpDatosRepo, usuarioConfigRepo), super();

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
      presenter.getEvaluacionGeneral(_calendarioPeriodoUI);
    };

    presenter.getAsistenciaOnError = (e){
      _asistenciaAlumnoList = [];
      _asistenciaTipoList = [];
      _porcentaje = 0;
      _cantidad = 0;
      hideProgressCurso();
      refreshUI();
    };

    presenter.getAsistenciaOnNext = (List<dynamic> items,  List<AsistenciaTipoUi> asistenciaTipoList, int porcentaje, int cantidad, bool errorServidor, bool offlineServidor){
      _asistenciaAlumnoList = items;
      _asistenciaTipoList = asistenciaTipoList;
      _porcentaje = porcentaje;
      _cantidad = cantidad;
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = offlineServidor? "No hay Conexión a Internet...":null;
      hideProgressCurso();
      refreshUI();
    };

    presenter.getAsistenciaOnComplete = (){

    };

    presenter.getAsistenciaGeneralOnError = (e){
      _asistenciaGeneralList = [];
      _asistenciaTipoGeneralList = [];
      _porcentajeGeneral = 0;
      _cantidadGeneral = 0;
      hideProgressGeneral();
      refreshUI();
    };

    presenter.getAsistenciaGeneralOnNext = (List<AsistenciaUi> items,  List<AsistenciaTipoUi> asistenciaTipoList, int porcentaje, int cantidad, bool errorServidor, bool offlineServidor){
      _asistenciaGeneralList = items;
      _asistenciaTipoGeneralList = asistenciaTipoList;
      _porcentajeGeneral = porcentaje;
      _cantidadGeneral = cantidad;
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = offlineServidor? "No hay Conexión a Internet...":null;
      hideProgressGeneral();
      refreshUI();
    };

    presenter.getAsistenciaGeneralOnComplete = (){

    };
  }

  @override
  void onInitState() {
    super.onInitState();
    showProgressCurso();
    showProgressGeneral();
    presenter.getCalendarioPerido();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    showProgressGeneral();
    showProgressCurso();
    presenter.getEvaluacion(calendarioPeriodoUi);
    presenter.getEvaluacionGeneral(calendarioPeriodoUi);
    refreshUI();
  }

  void showProgressCurso(){
    _isLoadingCurso = true;
  }

  void hideProgressCurso(){
    _isLoadingCurso = false;
  }

  void showProgressGeneral(){
    _isLoadingGeneral = true;
  }

  void hideProgressGeneral(){
    _isLoadingGeneral = false;
  }

  void successMsg() {
    _msgConexion = null;
  }

}