import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/prematricula/prematricula_presenter.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';

class PrematriculaController extends Controller{
  PrematriculaPresenter presenter;
  final String _fotoAlumno;
  String get fotoAlumno => _fotoAlumno;
  HijosUi _hijosUi = null;
  HijosUi get hijosUi => _hijosUi;
  String _urlServidor = null;
  String get urlServidor => _urlServidor;
  PrematriculaController(alumnoId, fotoAlumno, usuarioConfRepo) : presenter = PrematriculaPresenter(alumnoId, usuarioConfRepo), _fotoAlumno = fotoAlumno, super();

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
    presenter.getHijo();
    presenter.getUrlServidor();
  }



}