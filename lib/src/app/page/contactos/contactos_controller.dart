import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/contactos/contactos_presentar.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/domain/entities/contacto_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class ContactosController extends Controller{
  ContactosPresenter presenter;

  HijosUi _hijoSelected = null;
  UsuarioUi _usuarioUi = null;

  String _msgConexion = null;
  String get msgConexion => _msgConexion;

  HijosUi get hijoSelected => _hijoSelected;
  List<dynamic> _companieroList = [];
  List<dynamic> get companieroList => _companieroList;
  List<dynamic> _directivosList = [];
  List<dynamic> get directivosList => _directivosList;
  List<dynamic> _doncentesList = [];
  List<dynamic> get doncentesList => _doncentesList;
  ContactoUi _companiero = null;
  ContactoUi get companiero => companiero;
  bool _isLoading = false;
  get isLoading => _isLoading;

  ContactosController(HttpDatosRepository httpRepo, CursoRepository cursoRepo, UsuarioAndConfiguracionRepository usuarioConfRepo): presenter = ContactosPresenter(usuarioConfRepo, httpRepo, cursoRepo);

@override
  void onInitState() {
    // TODO: implement onInitState
    super.onInitState();
    showProgress();
    refreshUI();
    presenter.getDatosGenerales();
  }


  @override
  void initListeners() {
    presenter.getSesionUsuarioOnNext = (UsuarioUi usuarioUi) {
      _hijoSelected = usuarioUi.hijoSelected;
      //refreshUI(); // Refreshes the UI manually
      _usuarioUi = usuarioUi;
      refreshUI();
    };

    presenter.getSesionUsuarioOnComplete = () {
      print('User retrieved');
      print("GetEventoAgenda getSesionUsuarioOnComplete");
      presenter.getContactos(_usuarioUi);
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getSesionUsuarioOnError = (e) {
      print('Could not retrieve user.');
      _companieroList=[];
      _doncentesList=[];
      _directivosList = [];
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getContactosOnNext = (List<dynamic> alumnosList, List<dynamic> docentesList, List<dynamic> directivosList,  bool datosOffline, bool errorServidor){
      _companieroList=alumnosList;
      _doncentesList=docentesList;
      _directivosList = directivosList;
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = datosOffline? "No hay Conexión a Internet...":null;
      hideProgress();
      refreshUI();
    };

    presenter.getContactosOnComplete = (){

    };

    presenter.getContactosOnError = (e){
      _companieroList= [];
      _doncentesList=[];
      _directivosList = [];
      _msgConexion = "!Oops! Al parecer ocurrió un error involuntario.";
      hideProgress();
      refreshUI();
    };
  }

  void onChagenHijo() {

    if(!_isLoading){
      showProgress();
      if(_usuarioUi.hijos!=null&&_usuarioUi.hijoSelected!=null){
        int position = _usuarioUi.hijos.indexWhere((element) => element.personaId == _hijoSelected.personaId);
        if(position == _usuarioUi.hijos.length-1){
          _hijoSelected =_usuarioUi.hijos[0];
        }else{
          _hijoSelected =_usuarioUi.hijos[position+1];
        }
      }
      _usuarioUi.hijoSelected = hijoSelected;
      presenter.getContactos(_usuarioUi);
      print("GetEventoAgenda onChagenHijo");
      presenter.onChagenHijo(_hijoSelected);
      refreshUI();
    }

  }
  void onClickCompanieroContacto(ContactoUi contactoUi) {
    _companiero = contactoUi;
    for(dynamic comp in _companieroList)if(comp is ContactoUi)comp.toogle =  false;
    _companiero.toogle = true;
    refreshUI();


  }

  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }

}