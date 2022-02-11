import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/cursos/curso_presenter.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';

class CursoController extends Controller{
  CursoPresenter presenter;
 final alumnoId, programaAcademicoId, anioAcademicoId;
  final String fotoAlumno;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<CursoUi> _cursoUiList = [];
  List<CursoUi> get cursoUiList => _cursoUiList;

  CursoController(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno, cursoRepo): presenter = CursoPresenter(cursoRepo);
  @override
  void onInitState() {
    super.onInitState();
    presenter.getCursos(alumnoId, programaAcademicoId, anioAcademicoId);
  }
  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
      presenter.getCursosOnError = (e){
        _cursoUiList =[];
        refreshUI();
      };
      presenter.getCursosOnComple = (){

      };
      presenter.getCursosOnNext = (List<CursoUi>? cursoUiList){
        _cursoUiList = cursoUiList??[];
        refreshUI();
      };
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoList) {

  }

}