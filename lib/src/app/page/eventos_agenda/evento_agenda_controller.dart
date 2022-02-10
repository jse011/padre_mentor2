import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/evento_agenda_presenter.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/check_conex_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class EventoAgendaController extends Controller{
  UsuarioUi _usuarioUi;
  List<TipoEventoUi> _tipoEventoList = [];

  String _msgConexion = null;

  Timer selectedTipoEventoTimer;

  EventoUi _selectedEventoUi = null;
  EventoUi get selectedEventoUi => _selectedEventoUi;
  String get msgConexion => _msgConexion;
  List<TipoEventoUi> get tipoEventoList => _tipoEventoList;
  TipoEventoUi _selectedTipoEventoUi;
  TipoEventoUi get selectedTipoEventoUi => _selectedTipoEventoUi;
  List<EventoUi> _eventoUilIst = [];
  List<EventoUi> get eventoUiList => _eventoUilIst;
  bool _isLoading = false;
  get isLoading => _isLoading;

  HijosUi get hijoSelected => _hijoSelected;
  HijosUi _hijoSelected = null;
  EventoAgendaPresenter presenter;

  EventoAgendaController(CheckConexRepository checkConext, UsuarioAndConfiguracionRepository usuarioRepo, HttpDatosRepository httpRepo):this.presenter = new EventoAgendaPresenter(checkConext, usuarioRepo, httpRepo);

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
      presenter.onChangeUsuario(_usuarioUi, _selectedTipoEventoUi);
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getSesionUsuarioOnError = (e) {
      print('Could not retrieve user.');
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getEventoAgendaOnComplete = () {
      print('Could on Complete.');
    };
    presenter.getEventoAgendaOnError = (e) {
      print('evento error');
      if(tipoEventoList!=null){
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          tipoEventoUi.toogle = false;
        }
      }

      _eventoUilIst = [];
      hideProgress();
      _msgConexion = "!Oops! Al parecer ocurrió un error involuntario.";
      refreshUI();
    };
    presenter.getEventoAgendaOnNext = (List<TipoEventoUi> tipoEvantoList, List<EventoUi> eventoList, bool errorServidor, bool datosOffline) {

      _tipoEventoList = tipoEvantoList;
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = datosOffline? "No hay Conexión a Internet...":null;

      if(_selectedTipoEventoUi==null){
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          if(tipoEventoUi.id == 0){
            tipoEventoUi.toogle = true;
            _selectedTipoEventoUi = tipoEventoUi;
          }
        }
      }else{
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          if(_selectedTipoEventoUi.id == tipoEventoUi.id){
            tipoEventoUi.toogle = true;
            _selectedTipoEventoUi = tipoEventoUi;
          }
        }
      }

      if(eventoList!=null){
        _eventoUilIst = eventoList;
        hideProgress();
      }else{
        _eventoUilIst = [];
      }

      print('evento next');
      refreshUI();
    };
  }

  @override
  void onInitState() {
    showProgress();
    presenter.onInitState();
  }

  @override
  void dispose() {
    super.dispose();
    if(selectedTipoEventoTimer!=null)selectedTipoEventoTimer.cancel();

  }

  void onSelectedTipoEvento(TipoEventoUi tipoEvento) {
    if(tipoEvento.disable)return;
    showProgress();
    _selectedTipoEventoUi = tipoEvento;
    for(var item in _tipoEventoList)item.toogle = false;
    tipoEvento.toogle = true;
    refreshUI();
    if(selectedTipoEventoTimer!=null)selectedTipoEventoTimer.cancel();
    selectedTipoEventoTimer = Timer(Duration(milliseconds: 1000), () {
      print("GetEventoAgenda onSelectedTipoEvento");
      presenter.onChangeUsuario(_usuarioUi, selectedTipoEventoUi);
    });

  }

  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }

  void onChagenHijo() {
    showProgress();
    if(_usuarioUi.hijos!=null&&_usuarioUi.hijoSelected!=null){
        int position = _usuarioUi.hijos.indexWhere((element) => element.personaId == _hijoSelected.personaId);
        if(position == _usuarioUi.hijos.length-1){
          _hijoSelected =_usuarioUi.hijos[0];
        }else{
          _hijoSelected =_usuarioUi.hijos[position+1];
        }
    }
    presenter.onChagenHijo(_hijoSelected);
    print("GetEventoAgenda onChagenHijo");
    presenter.onChangeUsuario(_usuarioUi, selectedTipoEventoUi);
    refreshUI();
  }

  void onClickVerEvento(EventoUi eventoUi) {
    _selectedEventoUi = eventoUi;
  }

}