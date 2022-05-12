import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:padre_mentor/src/app/page/contactos/contactos_view.dart';
import 'package:padre_mentor/src/app/page/editar_usuario/editar_usuario_view.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_router.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/portal/evento_agenda_view.dart';
import 'package:padre_mentor/src/app/page/familia/famila_view.dart';
import 'package:padre_mentor/src/app/page/login/login_router.dart';
import 'package:padre_mentor/src/app/page/portal_alumno/portal_alumno_view.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/barra_navegacion.dart';
import 'package:padre_mentor/src/app/widgets/bottom_navigation.dart';
import 'package:padre_mentor/src/app/widgets/splash.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/utils/new_version.dart';

import 'home_controller.dart';

class HomePage extends View{
  static const TAG = "HomePage";
  @override
  _HomePageState createState() =>
      // inject dependencies inwards
      _HomePageState();

}
class _HomePageState extends ViewState<HomePage, HomeController> {

  late Widget _screenView;
  Widget _menuScreenView = Container();
  late Function CloseMenuView;
  Function? _closeMenu;
  Function(bool connected)? _onChangeConnected;
  bool? _connected;

  _HomePageState() : super(HomeController(DataUsuarioAndRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    /*Future.delayed(const Duration(milliseconds: 500), () {
      NewVersion(
        context: context,
        dismissText: "Quizás más tarde",
        updateText: "Actualizar",
        dialogTitle: "Actualización disponible",
        //iOSId: 'com.google.Vespa',
        iOSId: ChangeAppTheme.getApp()!=App.ICRM?'com.consultoraestrategia.padreMentor':'com.consultoraestrategia.padreMentor2',
        androidId: 'com.consultoraestrategia.padre_mentor2',
        dialogTextBuilder: (localVersion, storeVersion) => 'Ahora puede actualizar esta aplicación del ${localVersion} al ${storeVersion}',
      ).showAlertIfNecessary();
    }
    );*/
  }


  @override
  Widget get view =>
      Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            /*appBar: AppBar(
                title: Text('DBDEBUG'),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.folder),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList()));
                      }
                  ),
                ]
            ),*/
            body: ControlledWidgetBuilder<HomeController>(
              builder: (context, controller) {
                if(controller.showLoggin == 0){
                  return Container(
                    color: ChangeAppTheme.colorEspera(),
                  );
                }else if(controller.showLoggin == 1){
                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    // fetch data
                    LoginRouter.createRouteLogin(context);
                  });

                  return Container();
                }else{
                  changeIndex(controller.vistaActual, controller);
                  return Stack(
                    children: [
                      DrawerUserController(
                        photoUser: controller.usuario == null ? '' : '${controller.usuario?.foto??""}',
                        nameUser: controller.usuario == null ? '' : '${controller.usuario?.nombre??""}',
                        correo: '',
                        screenView: _screenView,
                        menuListaView: _menuScreenView,
                        drawerWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.70,
                        onClickCerrarCession: () async{
                          controller.onClickCerrarCession();
                        },
                        drawerIsOpen: (bool ) { },
                        onTapImagePerfil: () {
                          //AppRouter.showEditarUsuarioView(context, controller.usuario);
                        },
                        closeMenuCallback: (closeSesion) {
                          _closeMenu = closeSesion;
                        },
                      ),
                      if(controller.showDeuda)ArsProgressWidget(
                          blur: 2,
                          backgroundColor: Color(0x33000000),
                          animationDuration: Duration(milliseconds: 500),
                          loadingWidget: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                              color: AppTheme.colorPrimary,
                                          ),
                                          alignment: Alignment.center,
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              imageUrl: controller.usuario?.hijoSelected == null ? '' : '${controller.usuario?.hijoSelected?.foto}',
                                              imageBuilder: (context, imageProvider) => Container(
                                                  height: 170,
                                                  width: 170,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(80)),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                      ]
                                                  )
                                              )
                                          )
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                            color: AppTheme.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
                                                  child: SvgPicture.asset("assets/fitness_app/rest_look.svg"),
                                                ),
                                                flex: 5,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
                                                  child: Column(
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(left: 8, right: 8),
                                                          child: Text("No tiene acceso a la aplicación. \n Comuniquese con la administración del colegio por favor!!",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                          )
                                                      ),
                                                     Expanded(
                                                       child:  Row(
                                                         children: [
                                                           Container(
                                                             margin: EdgeInsets.all(10),
                                                             height: 50.0,
                                                             width: 70,
                                                             child: RaisedButton(
                                                               shape: RoundedRectangleBorder(
                                                                 borderRadius: BorderRadius.circular(18.0),),
                                                               onPressed: () {
                                                                 controller.onClicSalirDialodDeuda();
                                                               },
                                                               padding: EdgeInsets.all(10.0),
                                                               color: Colors.white,
                                                               textColor: AppTheme.colorAccent,
                                                               child: Text("  Atras  ",
                                                                   style: TextStyle(fontSize: 15)),
                                                             ),
                                                           ),
                                                           Expanded(
                                                             child: Container(),
                                                           ),
                                                           Container(
                                                             margin: EdgeInsets.all(10),
                                                             height: 50.0,
                                                             child: RaisedButton(
                                                               shape: RoundedRectangleBorder(
                                                                   borderRadius: BorderRadius.circular(18.0),
                                                                   side: BorderSide(color: HexColor("#8bc34a"))),
                                                               onPressed: () {
                                                                 controller.onClicSalirDialodDeuda();
                                                                 Navigator.of(context).push(EstadoCuentaRouter.createRouteEstadoCuenta(fotoAlumno: controller.usuario?.hijoSelected?.foto , alumnoId: controller.usuario?.hijoSelected?.personaId));

                                                               },
                                                               padding: EdgeInsets.all(10.0),
                                                               color: HexColor("#8bc34a"),
                                                               textColor: Colors.white,
                                                               child: Text("  Pago en línea  ",
                                                                   style: TextStyle(fontSize: 15)),
                                                             ),
                                                           )

                                                         ],
                                                       ),
                                                     )
                                                    ],
                                                  ),
                                                ),
                                                flex: 7,
                                              )
                                            ],
                                          ),
                                          alignment: Alignment.centerRight
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              )

                          ),
                      ),
                      if(controller.splash??false)SplashView(),

                    ],
                  );
                }

              }
            ),
          ),
        ),
      );


  void changeIndex(VistaIndex vistaIndex, HomeController controller) {
    switch (vistaIndex) {
      case VistaIndex.Principal:
        _screenView = BottomNavigationView(
          icono: controller.logo??"",
          builder: (context, position, animationController) {
            switch(position){
              case 2:
                setState(() {
                  _menuScreenView = Container();
                });
                return ContactosView(animationController: animationController!,);
              case 1:
                setState(() {
                  _menuScreenView = Container();
                });
                return PortalAlumnoView(animationController: animationController!);
              case 0:
                return EventoAgendaView(animationController: animationController!,closeMenu: _closeMenu, menuBuilder: (menuView) {
                  setState(() {
                    _menuScreenView = menuView;
                  });
                },connectedCallback: (dynamic Function(bool) onChangeConnected) {
                    _onChangeConnected = onChangeConnected;
                  },);
              default:
                setState(() {
                  _menuScreenView = Container();
                });
                return FamiliaView(animationController: animationController!);
            }
          },
        );
        break;
      case VistaIndex.EditarUsuario:
        _menuScreenView = EditarUsuarioView();
        break;
      case VistaIndex.Sugerencia:
        _menuScreenView = Container(
          color: Colors.red,
        );
        break;
      case VistaIndex.SobreNosotros:
        _menuScreenView = Container(
          color: Colors.red,
        );
        break;
    }
  }

}


/*
class _HomePageState2 extends ViewState<HomePage, HomeController>{
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    // TODO: implement initState
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
*/
