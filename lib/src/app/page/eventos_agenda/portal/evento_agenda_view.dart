import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:padre_mentor/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/informacion/evento_info_router.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/portal/evento_agenda_controller.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_icon.dart';
import 'package:padre_mentor/src/app/utils/app_system_ui.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/app_url_launcher.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/item_evento_view.dart';
import 'package:padre_mentor/src/app/widgets/smart_text_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/evento_adjunto_ui.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_recursos_ui.dart';
import 'package:padre_mentor/src/domain/tools/domain_drive_tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../informacion_evento_agenda/informacion_evento_agenda_view.dart';

class EventoAgendaView extends View{
  final AnimationController animationController;
  final MenuBuilder? menuBuilder;
  Function? closeMenu;
  final ConnectedCallback connectedCallback;

  EventoAgendaView({required this.animationController, this.menuBuilder, this.closeMenu,required this.connectedCallback});

  @override
  _EventoAgendaViewState createState() => _EventoAgendaViewState();

}

class _EventoAgendaViewState extends ViewState<EventoAgendaView, EventoAgendaController> with TickerProviderStateMixin{

  _EventoAgendaViewState() : super(EventoAgendaController(DataUsuarioAndRepository(), DeviceHttpDatosRepositorio()));

  late Animation<double> topBarAnimation;
  late ScrollController agendaTiposcrollController;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Map<TipoEventoUi,GlobalKey> evaluadoKeyMap = Map();


  @override
  void initState() {
    agendaTiposcrollController = ScrollController();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });

    super.initState();
  }

  @override
  Widget get view => ControlledWidgetBuilder<EventoAgendaController>(
    builder: (context, controller){

      SchedulerBinding.instance?.addPostFrameCallback((_) {
        widget.menuBuilder?.call(getMenuView(controller));
      });

      return WillPopScope(
        key: globalKey,
        onWillPop: () async {
          bool salir = controller.onBackPress();
          if(salir){
            //return await widget.closeSessionHandler.closeSession()??false;
          }
          return salir;
        },
        child:  AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.getSystemUiOverlayStyleOscuro(),
          child: Container(
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  getMainTab(),
                  getAppBarUI2(),
                  controller.isLoading?
                  controller.eventoUiList!=null? ArsProgressWidget(
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500)):
                  Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                  ):Container(),
                  controller.dialogAdjuntoDownload?
                  dialogAdjuntoDownload(controller):
                  Container(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget dialogAdjuntoDownload(EventoAgendaController controller) {
    List<EventoAdjuntoUi> eventoAdjuntoUiList = controller.eventoUiSelected?.eventoAdjuntoUiDownloadList??[];
    print("eventoAdjuntoUiList: a ${eventoAdjuntoUiList.length}");
    return ArsProgressWidget(
      blur: 2,
      backgroundColor: Color(0x33000000),
      animationDuration: Duration(milliseconds: 500),
      loadingWidget: Container(
        constraints: BoxConstraints(
            minWidth: 280.0,
            maxHeight: MediaQuery.of(context).size.height * 0.8
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: HexColor("#6D8392")
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 48),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(right: 32, left: 32, top: 16, bottom: 8),
                color: HexColor("#F5F5F5"),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      EventoAdjuntoUi eventoAdjuntoUi = eventoAdjuntoUiList[index];
                      return InkWell(
                        onTap: () async{
                          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi.driveId), webview: false);
                        },
                        child:  Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: HexColor("#526D8392"),
                                  )
                              )
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 16),
                                width: 30,
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    getImagen(eventoAdjuntoUi.tipoRecursosUi),
                                    height: 25.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text("${eventoAdjuntoUi.titulo??""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HexColor("#013A62"),
                                          fontSize: 12
                                      )
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12, right: 12),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    color: HexColor("#E0E0E0")
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcon.ic_evento_adjunto_download,
                                    semanticsLabel:"Download Evento",
                                    color: HexColor("#6D8392"),
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: eventoAdjuntoUiList.length,
                  ),

                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 32, top: 16, bottom: 8),
              child: TextButton(
                onPressed: () {
                  controller.onClickAtrasDialogEventoAdjuntoDownload();
                },
                child: Text('Atras', style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 16
                ),),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getImagen(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppIcon.archivo_video_ico;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppIcon.archivo_link_ico;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppIcon.archivo_documento_ico;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppIcon.archivo_imagen_ico;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppIcon.archivo_audio_ico;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppIcon.archivo_hoja_calculo_ico;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppIcon.archivo_diapositiva_ico;
      case TipoRecursosUi.TIPO_PDF:
        return AppIcon.archivo_pdf_ico;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppIcon.archivo_youtube_ico;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppIcon.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppIcon.archivo_recurso_ico;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return AppIcon.archivo_recurso_ico;
    }
  }
  
  Widget chip(TipoEventoUi tipo, Function onClick) {
    Color color;
    String imagepath;
    switch(tipo.tipo??EventoIconoEnumUI.DEFAULT){
      case EventoIconoEnumUI.DEFAULT:
        color = HexColor("#00BCD4");
        imagepath = AppIcon.ic_tipo_evento_cita;
        break;
      case EventoIconoEnumUI.EVENTO:
        color = HexColor("#bfca52");
        imagepath = AppIcon.ic_tipo_evento_evento;
        break;
      case EventoIconoEnumUI.NOTICIA:
        color = HexColor("#ffc107");
        imagepath = AppIcon.ic_tipo_evento_noticia;
        break;
      case EventoIconoEnumUI.ACTIVIDAD:
        color = HexColor("#ff6b9d");
        imagepath = AppIcon.ic_tipo_evento_actividad;
        break;
      case EventoIconoEnumUI.TAREA:
        color = HexColor("#ff9800");
        imagepath =  AppIcon.ic_tipo_evento_tarea;
        break;
      case EventoIconoEnumUI.CITA:
        color = HexColor("#00bcd4");
        imagepath = AppIcon.ic_tipo_evento_cita;
        break;
      case EventoIconoEnumUI.AGENDA:
        color = HexColor("#71bb74");
        imagepath = AppIcon.ic_tipo_evento_agenda;
        break;
      case EventoIconoEnumUI.TODOS:
        color = HexColor("#0091EA");
        imagepath = AppIcon.ic_tipo_evento_todos;
        break;
    }

    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,65),
      width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 78),
      decoration: BoxDecoration(
        color: color.withOpacity(tipo.toogle??false?1:0.6),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            topRight:Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0))),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: color.withOpacity(tipo.toogle??false?1:0.3),
              offset: Offset(0, tipo.toogle??false?3:1),
              blurRadius: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,10.0)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
          onTap: () {
            onClick(tipo);
          },
          child: Column(
            //alignment: AlignmentDirectional.center,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8)),
                    child: SvgPicture.asset(
                      imagepath,
                      semanticsLabel:"Eventos",
                      color: AppTheme.white,
                      width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,20.0),
                      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,20.0),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8),
                    left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,4.0),
                    right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,4.0)),
                child: Text(tipo.nombre??"",
                    textAlign: TextAlign.center ,
                    style: TextStyle(
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontTTNorms,
                        fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,12.0),
                        fontWeight: FontWeight.w900)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chipEspacio() {
    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: 65,
      width: 80,
      color: Colors.transparent,
    );
  }

  Widget getAppBarUI2() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext? context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context!).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 24, right: 24,top: 8 * topBarOpacity, bottom: 8),
                                  child: Text(
                                    'Agenda digital',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16 + 10 - 4 * topBarOpacity,
                                      letterSpacing: 1.2,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 48,
                          right: 16,
                          top: 16 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Eventos',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),
                          ),
                          ControlledWidgetBuilder<EventoAgendaController>(
                              builder: (context, controller) {
                                if(controller.hijoSelected==null){
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB (00.0, 00.0, 00.0, 00.0),
                                  );
                                }else{
                                  return  InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                    onTap: () {
                                      controller.onChagenHijo();
                                    },
                                    child:  CachedNetworkImage(
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        imageUrl: controller.hijoSelected == null ? '' : '${controller.hijoSelected?.foto}',
                                        imageBuilder: (context, imageProvider) => Container(
                                            height: 45 + 6 - 6 * topBarOpacity,
                                            width: 45 + 6 - 6 * topBarOpacity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                ]
                                            )
                                        )
                                    ),);

                                }})

                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
  int countView = 7;
  Widget getMainTab() {
    return ControlledWidgetBuilder<EventoAgendaController>(
      builder: (context, controller){
        return Scaffold(
          body: Container(
            color: AppTheme.background,
            child: Container(
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      0),
              child: Stack(
                children: [
                  controller.eventoUiList == null?
                  Container():
                  controller.eventoUiList!.isEmpty?
                  Column(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                              ),
                              Padding(padding: EdgeInsets.all(4)),
                              Center(
                                child: Text("${controller.selectedTipoEventoUi?.tipo == EventoIconoEnumUI.TODOS?"Sin publicaciones":"Sin publicaciones de ${(controller.selectedTipoEventoUi?.nombre??"").toLowerCase()}"} ${!controller.conexion?", revice su conexión a internet":""}",
                                  style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12)
                                ),
                              )
                            ],
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Container()
                      )
                    ],
                  ):Container(),
                  CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(padding: EdgeInsets.only(top: 8)),
                            _categoryRow(controller, "Filtrar agenda diguital"),
                            Container(
                              padding: EdgeInsets.only(
                                top: 8,
                              ),
                            ),
                          ])
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index){
                                EventoUi eventoUi = controller.eventoUiList![index];
                                return ItemEventoView(
                                  eventoUi,
                                  onClickMoreEventoAdjuntoDowload:(eventoUi) {
                                    controller.onClickMoreEventoAdjuntoDowload(eventoUi);
                                  },
                                  onClickPreview: (eventoUi, eventoAdjuntoUi) async{
                                    if((eventoUi?.eventoAdjuntoUiPreviewList??[]).isNotEmpty&&(eventoUi?.eventoAdjuntoUiPreviewList??[]).length>1){
                                      Navigator.of(context).push(EventoInfoRouter.createRouteInfoEventoComplejo(eventoUi: eventoUi));
                                    }else{
                                      Navigator.of(context).push(EventoInfoRouter.createRouteInfoEventoSimple(eventoAdjuntoUi: eventoAdjuntoUi, eventoUi: eventoUi));
                                      print("createRouteInfoEventoSimple");
                                    }
                                  },
                                  onClickPreviewComplejo: (eventoUi, eventoAdjuntoUi) async {
                                    //dynamic response = await AppRouter.createEventoInfoComplejoRouter(context, eventoUi);
                                  },
                                );
                              },
                              childCount: controller.eventoUiList?.length??0
                          )
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate(
                              [
                                Container(
                                  height: 100,
                                )
                              ])
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareImageFromUrl(EventoUi eventoUi) async {
    try {
      /*var request = await HttpClient().getUrl(Uri.parse(
          'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);*/

      var file = await DefaultCacheManager().getSingleFile(eventoUi.foto??"");
      List<int> bytes = await file.readAsBytes();
      Uint8List ubytes = Uint8List.fromList(bytes);

      //await Share.file(eventoUi.titulo, 'amlog.jpg', ubytes, 'image/jpg', text: eventoUi.titulo +"\n"+eventoUi.descripcion,);
    } catch (e) {}
  }

  Future<void> _shareText(EventoUi eventoUi) async {
    try {
      //Share.text(eventoUi.titulo,
        //  eventoUi.titulo +"\n"+eventoUi.descripcion, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Widget _categoryRow(EventoAgendaController controller, String title) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /* Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: TextStyle(
                  color: AppTheme.colorPrimary,
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),*/
          Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 10),
                scrollDirection: Axis.horizontal,
                controller: agendaTiposcrollController,
                itemCount: controller.tipoEventoListInvert.length,
                itemBuilder: (BuildContext context, int index) {
                  TipoEventoUi tipoEventoUi = controller.tipoEventoListInvert[index];
                  return Row(
                    children: [
                      _chip(tipoEventoUi, height: 5, isPrimaryCard: tipoEventoUi.toogle??false, onClick: (){
                        controller.onSelectedTipoEvento(tipoEventoUi);
                      }),
                      SizedBox(width: 10),
                    ],
                  );
                },
              )),
          /*SizedBox(height: 10)*/
        ],
      ),
    );
  }

  Widget _chip(TipoEventoUi tipo,
      {double height = 0, bool isPrimaryCard = false, Function? onClick }) {
    Color? textColor = null;
    switch(tipo.tipo??EventoIconoEnumUI.DEFAULT){
      case EventoIconoEnumUI.DEFAULT:
        textColor = HexColor("#00BCD4");
        break;
      case EventoIconoEnumUI.EVENTO:
        textColor = HexColor("#bfca52");
        break;
      case EventoIconoEnumUI.NOTICIA:
        textColor = HexColor("#ffc107");
        break;
      case EventoIconoEnumUI.ACTIVIDAD:
        textColor = HexColor("#ff6b9d");
        break;
      case EventoIconoEnumUI.TAREA:
        textColor = HexColor("#ff9800");
        break;
      case EventoIconoEnumUI.CITA:
        textColor = HexColor("#00bcd4");
        break;
      case EventoIconoEnumUI.AGENDA:
        textColor = HexColor("#71bb74");
        break;
      case EventoIconoEnumUI.TODOS:
        textColor = HexColor("#0091EA");
        break;
    }
    if(evaluadoKeyMap[tipo] == null){
      evaluadoKeyMap[tipo] = GlobalKey();
    }

    return InkWell(
      key: evaluadoKeyMap[tipo],
      onTap: (){
        onClick?.call();
      },
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
            minWidth: 60
        ),
        margin: EdgeInsets.only(top: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: textColor.withAlpha(isPrimaryCard ? 200 : 0),
            boxShadow: isPrimaryCard?[
              BoxShadow(
                  color:textColor.withOpacity(0.3),
                  offset:  Offset(0,2),
                  blurRadius: 10.0,
                  spreadRadius: 0
              ),
            ]:null
        ),
        child: Text(
          "${tipo.nombre??""}",
          style: TextStyle(
              color: isPrimaryCard ? Colors.white : AppTheme.colorPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: AppTheme.fontTTNorms
          ),
        ),
      ),
    );
  }
  Widget getMenuView(EventoAgendaController controller) {
    return Container(
      margin: EdgeInsets.only(
          top: 16,
          left: 24,
          right: 24,
          bottom: 64
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filtrar publicaciones",
            style: TextStyle(
                fontFamily: AppTheme.fontTTNorms,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppTheme.colorPrimary
            ),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Container(
            color: AppTheme.darkerText,
            height: 2,
          ),
          Padding(padding: EdgeInsets.all(12)),
          Container(
            alignment: Alignment.center,
            child:  Wrap(
              spacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
              runSpacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: <Widget>[
                for(var item in controller.tipoEventoList)
                  chip(item, (tipoEvento){
                    Future.delayed(const Duration(milliseconds: 200), () {
                      widget.closeMenu?.call();
                    });


                    final targetContext = evaluadoKeyMap[tipoEvento]?.currentContext;
                    if (targetContext != null) {

                      Scrollable.ensureVisible(
                          targetContext,
                          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart
                      );

                    }

                    controller.onSelectedTipoEvento(tipoEvento);
                  }),
                //chipEspacio()
              ],
            ),
          )
        ],
      ),
    );
  }
}
typedef ConnectedCallback = void Function(Function(bool connected) onChangeConnected);
typedef MenuBuilder = void Function(Widget menuView);