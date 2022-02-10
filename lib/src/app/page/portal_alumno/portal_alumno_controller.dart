import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/portal_alumno/portal_alumno_presenter.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/programa_educativo_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';

class PortalAlumnoController extends Controller{
  static const String TAG = "PortalAlumnoController";
  HijosUi _hijoSelected;

  var _selectedTipoEventoUi;
  String _msgConexion = null;
  String get msgConexion => _msgConexion;
  List<EventoUi> _eventoUilIst = [];
  List<EventoUi> get eventoUiList => _eventoUilIst;
  bool _isLoading = false;
  get isLoading => _isLoading;
  bool _showPrematricula = false;
  bool get showPrematricula => _showPrematricula;
  String _tituloPrematricula = null;
  String get tituloPrematricula => _tituloPrematricula;
  HijosUi get hijoSelected => _hijoSelected;
  List<HijosUi> _hijoList = [];
  List<ProgramaEducativoUi> _programaEducativoList = [];
  List<ProgramaEducativoUi> get programaEducativoList => _programaEducativoList;
  ProgramaEducativoUi _programaEducativoSelected;
  ProgramaEducativoUi get programaEducativoSelected => _programaEducativoSelected;
  PortalAlumnoPresenter presenter;

  bool _showDeuda = false;
  bool get showDeuda => _showDeuda;

  PortalAlumnoController(checkConexRepo, httpRepository, usuarioConfiRepo):this.presenter = PortalAlumnoPresenter(checkConexRepo, httpRepository, usuarioConfiRepo)
  ,super();

  @override
  void initListeners() {
    presenter.getSesionUsuarioOnNext = (UsuarioUi user) {

      _programaEducativoList = user.programaEducativoUiList;
     _programaEducativoSelected = user.programaEducativoUiSelected;
     _hijoSelected = user.hijoSelected;
      //print('User retrieved : ' + _hijoSelected.nombre);
      _hijoList = user.hijos;
      //SelectedPageProgramaEducativo();
      refreshUI(); // Refreshes the UI manually
      presenter.onChangeUsuario(user, _selectedTipoEventoUi);
    };

    presenter.getSesionUsuarioOnComplete = () {
      print('User retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getSesionUsuarioOnError = (e) {
      print('Could not retrieve user.');
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getEventoActualesOnComplete = () {
      refreshUI();
    };
    presenter.getEventoActualesOnError = (e) {
      print('evento error');
      _eventoUilIst = [];
      hideProgress();
      _msgConexion = "No hay Conexión a Internet...";
      refreshUI();
    };
    presenter.getEventoActualesOnNext = (List<EventoUi> eventoList, bool errorServidor) {
      print('evento next');
      _eventoUilIst = eventoList;
      _msgConexion = errorServidor?"!Oops! Al parecer ocurrió un error involuntario.":null;
      refreshUI(); //
    };

    presenter.getPrematiculaOnComplete = (){

    };

    presenter.getPrematiculaOnNext = (String titulo){
      _showPrematricula = titulo!=null&&titulo.isNotEmpty;
      _tituloPrematricula = titulo;
      refreshUI();
    };

    presenter.getPrematiculaOnError = (){
      _showPrematricula = false;
      refreshUI();
    };


    presenter.isHabilitadoOnComplete = (bool habilitar){
      _showDeuda = (!habilitar);
      refreshUI();
    };

    presenter.isHabilitadoOnError = (e){

    };

  }

  @override
  void onInitState() {
    presenter.onInitState();
  }

  void onSelectedProgramaSelected(ProgramaEducativoUi programaEducativo) {
    _programaEducativoSelected = programaEducativo;
    for(var hijo in _hijoList){
        if(hijo.personaId == _programaEducativoSelected.hijoId){
          _hijoSelected = hijo;
        }
    }
    presenter.onSaveProgramaUsuario(_programaEducativoSelected);

    Future.delayed(const Duration(milliseconds: 500), () {
      if(_hijoSelected!=null)presenter.isHabilitado(_hijoSelected.personaId);
      refreshUI();
    });

  }
  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }

  void onClicSalirDialodDeuda() {
     _showDeuda = false;
     refreshUI();
  }
}