import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_presenter.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';

class EstadoCuentaController extends Controller{
  EstadoCuentaPresenter presenter;
  final String _fotoAlumno;
  String get fotoAlumno => _fotoAlumno;
  HijosUi _hijosUi = null;
  HijosUi get hijosUi => _hijosUi;
  String _urlServidor = null;
  String get urlServidor => _urlServidor;
  EstadoCuentaController(alumnoId, fotoAlumno, usuarioConfRepo) : presenter = EstadoCuentaPresenter(alumnoId, usuarioConfRepo), _fotoAlumno = fotoAlumno, super();

  @override
  void initListeners() {
    presenter.getHijonNext = (HijosUi hijosUi){
     _hijosUi = hijosUi;
      refreshUI();
    };
    presenter.getHijoOnError = (e){
      _hijosUi = null;
      refreshUI();
    };
    presenter.getHijoOnComplete = (){

    };
    presenter.getUrlServidorOnNext = (String url){
      _urlServidor = url;
      refreshUI();
    };

    presenter.getUrlServidorOnComplete = ( ){

    };

    presenter.getUrlServidorOnError = ( ){
      _urlServidor = null;
      refreshUI();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getUrlServidor();
    presenter.getHijo();
  }



}