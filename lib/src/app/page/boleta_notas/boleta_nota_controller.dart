import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/boleta_notas/boleta_notas_presenter.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_boleta_ui.dart';

class BoletaNotaController extends Controller{

  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI _calendarioPeriodoUI = null;
  CalendarioPeriodoUI get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<CursoBoletaUi> _cursoBoletaUiList = [];
  List<CursoBoletaUi> get cursoBoletaUiList => _cursoBoletaUiList;
  final String fotoAlumno;
  BoletaNotasPresenter presenter;
  BoletaNotaController(alumnoId, programaAcademicoId, anioAcademicoId, this.fotoAlumno, usuarioConfigRepo, cursoRepo, httpRepo):presenter = BoletaNotasPresenter(alumnoId, programaAcademicoId, anioAcademicoId, usuarioConfigRepo, cursoRepo, httpRepo), super();
  bool _isLoading = false;
  get isLoading => _isLoading;
  String _msgConexion = null;
  String get msgConexion => _msgConexion;

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
        presenter.getBoletaNota(_calendarioPeriodoUI);
      };

      presenter.getBoletaNotaOnError = (e){
        _cursoBoletaUiList = [];
        hideProgress();
        refreshUI();
      };
      presenter.getBoletaNotaOnNext = (List<CursoBoletaUi> items, bool errorServidor, bool offlineServidor){
        _cursoBoletaUiList = items;
        hideProgress();
        _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
        _msgConexion = offlineServidor? "No hay Conexión a Internet...":null;
        refreshUI();
      };

      presenter.getBoletaNotaOnComplete = (){

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
      presenter.getBoletaNota(calendarioPeriodoUi);
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

