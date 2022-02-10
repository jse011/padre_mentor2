import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/editar_usuario/editar_usuario_presenter.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';

import 'editar_usuario_view.dart';

class EditarUsuarioController extends Controller{
  bool _diabledSave = false;

  EditarUsuarioPresenter presenter;

  UsuarioUi _usuarioUi;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  bool _dissmis = false;
  bool get dissmis => _dissmis;
  UsuarioUi get usuarioUi => _usuarioUi;
  List<HijosUi> _hijoUiList = [];
  List<HijosUi> get hijoUiList => _hijoUiList;
  List<FamiliaUi> _familiaUiList = [];
  List<FamiliaUi> get familiaUiList => _familiaUiList;
  String _mensaje = null;
  String get mensaje => _mensaje;
  bool _fotoUsuarioSelected = false;
  HijosUi _fotoHijosUiSelected = null;
  FamiliaUi _fotoFamiliaUiSelected = null;

  EditarUsuarioController(httpRepo, usuarioConfRepo, checkInternetRepo, compresImageRepo):this.presenter=EditarUsuarioPresenter(httpRepo, usuarioConfRepo, checkInternetRepo, compresImageRepo);

  @override
  void initListeners() {
    presenter.getUserOnNext = (UsuarioUi user) {
      _usuarioUi = user;
      _hijoUiList = user.hijos;
      _familiaUiList = user.familiaUiList;
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getUserOnComplete = () {
      print('User retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getUserOnError = (e) {
      print('Could not retrieve user.');
      _usuarioUi = null;
      _hijoUiList = [];
      _familiaUiList = [];
      refreshUI(); // Refreshes the UI manually
    };

    presenter.updateFamiliaOnNext = (bool hayconexion) {


      if(hayconexion){
        _showDialog = true;
        _mensaje=null;
        _dissmis = true;
        refreshUI();
      }else{
      _showDialog = false;
      _diabledSave = false;
      _mensaje = "No hay Conexión a Internet...";
      refreshUI();
      }
    };

    presenter.updateFamiliaOnError = (e){
      _showDialog = false;
      _diabledSave = false;
      _mensaje = "!Oops! Al parecer ocurrió un error involuntario.";
      refreshUI();
    };

    presenter.updateFamiliaOnComplete = (){

    };

  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getSessionUsuarioCase();
  }

  void onSave() {

    if(!_diabledSave){
      _showDialog = true;
      refreshUI();
      presenter.onSaveFamiliar(_usuarioUi, _hijoUiList, _familiaUiList);
    }
    _diabledSave =true;
  }

  void successMsg() {
    _mensaje = null;
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void onChangeImageUsuario() {
    _fotoUsuarioSelected = true;
    _fotoHijosUiSelected = null;
    _fotoFamiliaUiSelected = null;
  }

  void onChangeImageHijo(HijosUi hijosUi) {
    _fotoUsuarioSelected = false;
    _fotoHijosUiSelected = hijosUi;
    _fotoFamiliaUiSelected = null;
  }

  void onChangeImageFamila(FamiliaUi familiaUi) {
    _fotoUsuarioSelected = false;
    _fotoHijosUiSelected = null;
    _fotoFamiliaUiSelected = familiaUi;
  }

  void changeImage(File image) {
    refreshUI();
    if(_fotoUsuarioSelected){
      _usuarioUi.fotoFile = image;
      _usuarioUi.change = true;
    }else if(_fotoHijosUiSelected!=null){
      _fotoHijosUiSelected.fotoFile = image;
      _fotoHijosUiSelected.change = true;
    }else if(_fotoFamiliaUiSelected!=null){
      _fotoFamiliaUiSelected.fotoFile = image;
      _fotoFamiliaUiSelected.change = true;
    }
  }


}