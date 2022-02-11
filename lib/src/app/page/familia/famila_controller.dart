import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/familia/familia_presenter.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';

class FamiliaController extends Controller{

  FamiliaPresenter presenter;

  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi => _usuarioUi;
  List<HijosUi> _hijosUiList = [];
  List<HijosUi> get hijosUiList => _hijosUiList;
  List<FamiliaUi> _familiaUiList = [];
  List<FamiliaUi> get familiaUiList => _familiaUiList;

  FamiliaController(httpRepo, UsuarioConfRepo):presenter = FamiliaPresenter(httpRepo, UsuarioConfRepo);
@override
  void onInitState() {
    super.onInitState();
    presenter.onInitState();
  }

  @override
  void onResumed() {
    presenter.onInitState();
  }

  @override
  void initListeners() {
    presenter.getSesionUsuarioOnNext = (UsuarioUi? usuarioUi) {
      _usuarioUi = usuarioUi;
      _hijosUiList = _usuarioUi?.hijos??[];
      _familiaUiList = _usuarioUi?.familiaUiList??[];
      refreshUI();
    };

    presenter.getSesionUsuarioOnComplete = () {
      print('User retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getSesionUsuarioOnError = (e) {
      print('Could not retrieve user.');
      refreshUI(); // Refreshes the UI manually
    };

  }

  void getDatosGenerales(){
    presenter.getDatosGenerales();
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }


}