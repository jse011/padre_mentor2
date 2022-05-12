import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/evaluacion_informacion/evaluacion_informacion_presenter.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/evaluacion_rubro_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/entities/valor_tipo_nota_ui.dart';

class EvaluacionInformacionController extends Controller{
  String? rubroEvaluacionId;
  int? alumnoId;
  CursoUi? cursoUi;
  EvaluacionInformacionPresenter presenter;
  RubroEvaluacionUi? _rubroEvaluacionUi = null;
  RubroEvaluacionUi? get rubroEvaluacionUi => _rubroEvaluacionUi;
  List<List<dynamic>> _cells = [];
  List<List<dynamic>>  get cells => _cells;
  List<dynamic> _column = [];
  List<dynamic>  get columns => _column;
  List<RubroEvaluacionUi> _row = [];
  List<RubroEvaluacionUi>  get row => _row;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi => _usuarioUi;
  bool _conexion = true;
  bool get conexion => _conexion;

  EvaluacionInformacionController(this.cursoUi, this.rubroEvaluacionId, this.alumnoId, httpDatosRepository, cursoRepository, configuracionRepository, usuarioConfigRepo):
    presenter = EvaluacionInformacionPresenter(httpDatosRepository, cursoRepository, configuracionRepository, usuarioConfigRepo);

  bool _progress = true;
  bool get progress => _progress;

  @override
  void initListeners() {
    presenter.getRubroInfoResponseOnError = () {
      _rubroEvaluacionUi = null;
      _cells = [];
      _column = [];
      _row = [];
      _progress = false;
      _conexion = false;
    };

    presenter.getRubroInfoResponseOnNext = (RubroEvaluacionUi? rubroEvaluacionUi, bool? errorServidor, bool? offlineServidor){
      _rubroEvaluacionUi = rubroEvaluacionUi;
      _progress = false;
      if(offlineServidor??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
      getListRubro();
    };

    presenter.getUserOnNext = (UsuarioUi? user) {
      _usuarioUi = user;
      //print("foto: ${user?.foto}");
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getUserOnError = (e) {
      //print('Could not retrieve user.');
      _usuarioUi = null;
      refreshUI(); // Refreshes the UI manually
    };

  }

  @override
  void onInitState() {
    presenter.getRubroInfo(rubroEvaluacionId, alumnoId);
    presenter.getUserSession();
    super.onInitState();
  }



  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }


  void getListRubro() {
    _row = _rubroEvaluacionUi?.rubroEvaluacionUiList??[];
    List<ValorTipoNotaUi> valorTipoNotaList = [];
    TipoNotaEnumUi? tipoNotaEnumUi = null;
    if(rubroEvaluacionUi?.rubroEvaluacionUiList?.isNotEmpty??false){
      tipoNotaEnumUi = rubroEvaluacionUi?.rubroEvaluacionUiList?[0].tipoNotaEnum;
      valorTipoNotaList = rubroEvaluacionUi?.rubroEvaluacionUiList?[0].valorTipoNotas??[];
    }else{
      tipoNotaEnumUi = rubroEvaluacionUi?.tipoNotaEnum;
    }
    //_column.add(RubroEvaluacionUi());
    //print("valorTipoNotaList: ${valorTipoNotaList.length}");
    if(tipoNotaEnumUi == TipoNotaEnumUi.SELECTOR_ICONOS ||
        tipoNotaEnumUi == TipoNotaEnumUi.SELECTOR_VALORES){
      _column.addAll(valorTipoNotaList);
    }else{
      _column.add(EvaluacionRubroUi());
    }


    for(RubroEvaluacionUi row in _row){
      List<dynamic> cellList = [];
      //cellList.add(row);
      if(tipoNotaEnumUi == TipoNotaEnumUi.SELECTOR_ICONOS ||
          tipoNotaEnumUi == TipoNotaEnumUi.SELECTOR_VALORES){
        cellList.addAll(row.valorTipoNotas??[]);
      }else{
        cellList.add(row);
      }

      _cells.add(cellList);
    }
    refreshUI();
  }



}
