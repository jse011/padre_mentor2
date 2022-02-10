import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/comportamiento/comportamiento_presenter.dart';
import 'package:padre_mentor/src/app/page/horarios/horarios_presenter.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class HorariosController extends Controller{
  HorariosPresenter presenter;
  final int alumnoId;
  final int programaAcademicoId;
  final int anioAcademicoId;
  final String fotoAlumno;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI _calendarioPeriodoUI = null;
  CalendarioPeriodoUI get calendarioPeriodoUI => _calendarioPeriodoUI;
  bool _isLoading = false;
  get isLoading => _isLoading;
  String _msgConexion = null;
  String get msgConexion => _msgConexion;

  HorariosController(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno, UsuarioAndConfiguracionRepository usuarioConfigRepo, CursoRepository cursoRepo, DeviceHttpDatosRepositorio httpDatosRepo): presenter = HorariosPresenter(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, cursoRepo, httpDatosRepo, usuarioConfigRepo), super();

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

    };

  }

  @override
  void onInitState() {
    super.onInitState();
    //showProgress();
    presenter.getCalendarioPerido();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI.selected = true;
    //showProgress();

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