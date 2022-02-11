import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';

import 'home_presenter.dart';

class HomeController extends Controller{
  final HomePresenter homePresenter;
  VistaIndex _vistaActual;
  UsuarioUi? _userioSession;
  bool? _splash = true;
  String? _logo = null;
  String? get logo => _logo;
  bool? get splash => _splash;
  UsuarioUi? get usuario => _userioSession; // data used by the View
  int _showLoggin = 0;// 0 cargando, 1 show Loggin, -1 nada
  int get showLoggin => _showLoggin;
  bool _showDeuda = false;
  bool get showDeuda => _showDeuda;
  bool _sehisolaconsultaDeuda = false;

  VistaIndex get vistaActual => _vistaActual;

  HomeController(usuarioConfiRepo, httpDatosRepo)
      :  _vistaActual = VistaIndex.Principal,
        this.homePresenter = HomePresenter(usuarioConfiRepo, httpDatosRepo),
      super();

  @override
  // this is called automatically by the parent class
  void initListeners() {
    homePresenter.getUserOnNext = (UsuarioUi? user) {
      _userioSession = user;
      refreshUI(); // Refreshes the UI manually
    };

    homePresenter.getUserOnComplete = () {
      Future.delayed(const Duration(milliseconds: 3000), () {
        _splash = false;
        refreshUI();
        if(_userioSession?.hijoSelected!=null){
          homePresenter.isHabilitado(_userioSession?.hijoSelected?.personaId);
        }
      });
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getUserOnError = (e) {
      print('Could not retrieve user.');
      _userioSession = null;
      refreshUI(); // Refreshes the UI manually
    };


    homePresenter.validarUsuarioOnComplete = () {
      homePresenter.getUserSession();
      _showLoggin = -1;
      refreshUI();
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.validarUsuarioOnError = (e) {
      _showLoggin = 1;
      refreshUI();
    };

    homePresenter.cerrarCesionOnComplete = (bool? success){
      if(success??false){
        _showLoggin = 1;
        refreshUI();
      }
    };

    homePresenter.cerrarCesionOnError = (e){

    };

    homePresenter.isHabilitadoOnComplete = (bool? habilitar){
      _sehisolaconsultaDeuda = true;
      _showDeuda = (!(habilitar??false));
      refreshUI();
    };

    homePresenter.isHabilitadoOnError = (e){
      _sehisolaconsultaDeuda = true;
    };


    homePresenter.getIconoPadreOnComplete = (String logo){
      _logo = logo;
      print("mi logo ${_logo}");
      refreshUI();
    };

    homePresenter.getIconoPadreOnError = (e){

    };
  }

  @override
  void onInitState() {
    homePresenter.getIconoPadre();
    homePresenter.validarUsuario();
    homePresenter.updateDatos();
    super.onInitState();
  }

  @override
  void onResumed() {
    if(_sehisolaconsultaDeuda) homePresenter.isHabilitado(_userioSession?.hijoSelected?.personaId);//volver a sol hiso la consulta la primera vez al inciar la aplicacion
  }


  void onSelectedVistaAbout() {
    _vistaActual = VistaIndex.SobreNosotros;
    refreshUI(); // Refreshes the UI manually

  }

  void onSelectedVistaFeedBack() {
    _vistaActual = VistaIndex.Sugerencia;
    refreshUI(); // Refreshes the UI manually
  }

  void onSelectedVistaPrincial() {
    _vistaActual = VistaIndex.Principal;
    refreshUI(); // Refreshes the UI manually
  }

  void onSelectedVistaEditUsuario() {
    _vistaActual = VistaIndex.EditarUsuario;
    refreshUI(); // Refreshes the UI manually
  }

  void onClickCerrarCession() {
    homePresenter.cerrarCesion();
  }

  @override
  void onDisposed() {
    super.onDisposed();
    homePresenter.dispose();
  }

  void onClicSalirDialodDeuda() {
    _showDeuda = false;
    refreshUI();
  }
}

enum VistaIndex {
  Principal,
  EditarUsuario,
  Sugerencia,
  SobreNosotros,
}