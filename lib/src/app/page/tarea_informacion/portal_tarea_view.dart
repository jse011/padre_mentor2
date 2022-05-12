import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:padre_mentor/libs/fdottedline/fdottedline.dart';
import 'package:padre_mentor/src/app/page/tarea_informacion/portal_tarea_controller.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_icon.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/app_url_launcher.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_recursos_ui.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PortalTareaView extends View{
  TareaEvaluacionCursoUi? tareaEvaluacionCursoUi;
  String? fotoAlumno;
  int? alumnoId;
  PortalTareaView(this.tareaEvaluacionCursoUi, this.fotoAlumno, this.alumnoId);

  @override
  _PortalTareaViewState createState() => _PortalTareaViewState(this.tareaEvaluacionCursoUi, this.fotoAlumno, this.alumnoId);

}

class _PortalTareaViewState extends ViewState<PortalTareaView, PortalTareaController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late bool isExpandedSlidingSheet = false;
  late AnimationController animationController;
  late SheetController _sheetController = SheetController();
  _PortalTareaViewState(TareaEvaluacionCursoUi? tareaEvaluacionCursoUi, String? fotoAlumno, int? alumnoId) : super(PortalTareaController(tareaEvaluacionCursoUi, fotoAlumno, alumnoId,
      DataCursoRepository(), DataUsuarioAndRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
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

    animationController.reset();

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        animationController.forward();
      });}

    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget get view => WillPopScope(
      onWillPop: () async {
        if(_sheetController.state?.isExpanded??false){
          _sheetController.collapse();
          return false;
        } else{
          return true;
        }
      },
    child: Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.background,
      body: SlidingSheet(
        elevation: isExpandedSlidingSheet?0:2,
        cornerRadius: isExpandedSlidingSheet?0:16,
        listener: (state) {
          if(state.isExpanded != isExpandedSlidingSheet){
            setState(() {
              isExpandedSlidingSheet = state.isExpanded;
            });
          }

          print("state.isAtTop: ${state.isAtTop}");
        },
        controller: _sheetController,
        snapSpec: SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          //snappings: [0.2, 0.5, 1.0],
          // Define to what the snappings relate to. In this case,
          // the total available space that the sheet can expand to.
          //positioning: SnapPositioning.relativeToAvailableSpace,
          //initialSnap: 0.2
          snappings: [
            150 + (MediaQuery.of(context).padding.top  + 65),
            double.infinity
          ],
          positioning: SnapPositioning.pixelOffset,
        ),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: Stack(
          children: [
            getMainTab(),
            getAppBarUI(),
          ],
        ),
        margin: EdgeInsets.only(top: (MediaQuery.of(context).padding.top  + 65)),
        minHeight: MediaQuery.of(context).size.height,
        builder: (context, state){
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return SheetListenerBuilder(
            // buildWhen can be used to only rebuild the widget when needed.
            //buildWhen: (oldState, newState) => oldState.isExpanded != newState.isExpanded || oldState.isCollapsed != newState.isCollapsed,
            builder: (context, state) {
              return ControlledWidgetBuilder<PortalTareaController>(
                  builder: (context, controller) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                              if(!state.isExpanded)
                                Stack(
                                  children: [
                                    Center(
                                      child: Icon(!state.isExpanded ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down, size: 32,),
                                    )
                                  ],
                                ),
                              Container(
                                padding: EdgeInsets.only(top: state.isCollapsed?8:24,left: 24, right: 24),
                                child: Row(
                                  children: [
                                    Text("Tu trabajo",
                                      style: TextStyle(
                                          color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso),
                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 28),
                                          fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w800,
                                      )
                                    ),
                                    Expanded(child: Container()),
                                    Text("",//Sin entregar
                                      style: TextStyle(
                                          color: AppTheme.redDarken4,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                          fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              if(state.isCollapsed)
                                InkWell(
                                  onTap: (){
                                    _sheetController.expand();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                        right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                        top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)
                                    ),
                                    height: 70,
                                    child: Row(
                                      children: [
                                       Container(
                                         padding: EdgeInsets.only(
                                             top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)
                                         ),
                                         child:  Icon(Icons.message_outlined, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),),
                                       ),
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4))),
                                        Expanded(
                                            child: Text("Entregar mi trabajo o agregar un comentario",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontSize:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                              )
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if(!state.isCollapsed)
                              Container(
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                                child: Center(
                                  child:  FDottedLine(
                                    color: AppTheme.greyDarken2,
                                    strokeWidth: 2.0,
                                    dottedLength: 5.0,
                                    space: 3.0,
                                    corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                                    child: Container(
                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 15)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.attach_file,
                                            color: AppTheme.greyDarken2,
                                            size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                          ),
                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2))),
                                          Text("Adjuntar",
                                            style: TextStyle(
                                                color: AppTheme.greyDarken2,
                                              fontWeight: FontWeight.w500,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 18),
                                              fontFamily: AppTheme.fontTTNorms
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              if(!state.isCollapsed)
                              ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                      bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 0),
                                      left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                      right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)
                                  ),
                                  itemCount: controller.tareaEvaluacionCursoUi?.recursoArchivoUiList?.length??0,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    TareaArchivoUi tareaArchivoUi = controller.tareaEvaluacionCursoUi!.recursoArchivoUiList![index];
                                    return Stack(
                                      children: [
                                        Center(
                                          child: InkWell(
                                            onTap: () async {
                                              //await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),), // use instead of BorderRadius.all(Radius.circular(20))
                                                  border:  Border.all(
                                                      width: 1,
                                                      color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso)
                                                  ),
                                                  color: AppTheme.white
                                              ),
                                              margin: EdgeInsets.only(bottom: 8),
                                              height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 60),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(right: 16),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(8),
                                                        topLeft: Radius.circular(8),
                                                      ), // use instead of BorderRadius.all(Radius.circular(20))
                                                      color: AppTheme.greyLighten2,
                                                    ),
                                                    width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 60),
                                                    child: Center(
                                                      child: Image.asset(getImagen(null),
                                                        height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 40),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${tareaArchivoUi.nombre}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                        Padding(padding: EdgeInsets.all(2)),
                                                        tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO?
                                                        Text("${(tareaArchivoUi.url??"").isNotEmpty?tareaArchivoUi.url: tareaArchivoUi.descripcion}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 10)):
                                                        Text("${(tareaArchivoUi.descripcion??"").isNotEmpty?tareaArchivoUi.descripcion: getDescripcion(tareaArchivoUi.tipoArchivo)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ),
                              if(!state.isCollapsed)
                              Container(
                                padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                  bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                  left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                      right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                      top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                      bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                      color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso)
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("ENTREGAR MI TRABAJO",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w500,
                                              color:AppTheme.white,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,18),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ])
                        ),

                      ],
                    );
                  });
            },
          );
        },
      ),
    ),
  );

  Widget getAppBarUI() {
    return  ControlledWidgetBuilder<PortalTareaController>(
        builder: (context, controller) {
          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: isExpandedSlidingSheet? AppTheme.white : AppTheme.white.withOpacity(topBarOpacity),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey
                            .withOpacity(0.4 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 16 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                          bottom: 12 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              child:  IconButton(
                                icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                onPressed: () {

                                  if(_sheetController.state?.isExpanded??false){
                                    _sheetController.collapse();

                                  } else{
                                    animationController.reverse().then<dynamic>((data) {
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.of(this.context).pop();
                                    });
                                  }
                                  return;

                                },
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 52),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //SvgPicture.asset(AppIcon.ic_curso_tarea, height: 32 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1), width: 35 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, top: 8),
                                  child: Text(
                                    'Tarea',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                      fontSize:ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                                      letterSpacing: 0.8,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            child:  Container(
                              height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45 + 6 - 6 * topBarOpacity),
                              width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45 + 6 - 6 * topBarOpacity),
                              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => SizedBox(
                                    child: Shimmer.fromColors(
                                      baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                      highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                      child: Container(
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                        decoration: BoxDecoration(
                                            color: AppTheme.colorPrimary,
                                            shape: BoxShape.circle
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  imageUrl: controller.fotoAlumno??"",
                                  imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: <BoxShadow>[

                                          ]
                                      )
                                  )
                              ),
                            ),
                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                          )

                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<PortalTareaController>(
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32),
                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32)
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        child: Center(
                          child: Container(
                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 75),
                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 75),
                            child: FDottedLine(
                              color: AppTheme.greyLighten1,
                              strokeWidth: 1.0,
                              dottedLength: 5.0,
                              space: 3.0,
                              corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 40)),
                              child: Container(
                                color: AppTheme.greyLighten2,
                                child: (){
                                  //#region Nota
                                  Color color;
                                  if (("B" == (controller.tareaEvaluacionCursoUi?.tituloNota??"") || "C" == (controller.tareaEvaluacionCursoUi?.tituloNota??""))) {
                                    color = AppTheme.redDarken4;
                                  }else if (("AD" == (controller.tareaEvaluacionCursoUi?.tituloNota??"")) || "A" == (controller.tareaEvaluacionCursoUi?.tituloNota??"")) {
                                    color = AppTheme.blueDarken4;
                                  }else {
                                    color = AppTheme.black;
                                  }
                                  if(controller.tareaEvaluacionCursoUi?.rubroEvaluacionId!=null&&(controller.tareaEvaluacionCursoUi?.rubroEvaluacionId?.length??0)>0){
                                    switch(controller.tareaEvaluacionCursoUi?.tipoNotaEnum) {
                                      case TipoNotaEnumUi.SELECTOR_VALORES:
                                        return Container(
                                          child: Center(
                                            child: Text(controller.tareaEvaluacionCursoUi?.tituloNota ?? "",
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                                    color: color
                                                )),
                                          ),
                                        );
                                      case TipoNotaEnumUi.SELECTOR_ICONOS:
                                        return Container(
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                          child: CachedNetworkImage(
                                            imageUrl:controller.tareaEvaluacionCursoUi?.iconoNota ?? "",
                                            placeholder: (context, url) => SizedBox(
                                              child: Shimmer.fromColors(
                                                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                child: Container(
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                  decoration: BoxDecoration(
                                                      color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso2),
                                                      shape: BoxShape.circle
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        );
                                      case TipoNotaEnumUi.SELECTOR_NUMERICO:
                                      case TipoNotaEnumUi.VALOR_NUMERICO:
                                      case TipoNotaEnumUi.VALOR_ASISTENCIA:
                                        return Center(
                                          child: Text("${controller.tareaEvaluacionCursoUi?.nota==null?"-":(controller.tareaEvaluacionCursoUi?.nota??0).toStringAsFixed(1)}", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 19),
                                              color: AppTheme.black),
                                          ),
                                        );
                                      default:
                                        return Center(
                                          child: Text("-", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                              color: AppTheme.black
                                          ),),
                                        );
                                    }
                                  }else{
                                    return Container();
                                  }



                                  //#endregion
                                }(),
                              ),

                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                        child: Text("Fecha de entrega: ${AppTools.f_fecha_hora_anio_mes_dia_letras(controller.tareaEvaluacionCursoUi?.fechaEntrega)}",
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                            fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w500
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text("${controller.tareaEvaluacionCursoUi?.tituloTarea??""}",
                          style: TextStyle(
                              color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso) ,
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                              fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Container(
                                margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                                child: Row(
                                  children: [
                                    Icon(Icons.message_outlined, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),),
                                    Padding(padding: EdgeInsets.all(4)),
                                    Text("Agregar un comentario de la clase",
                                      style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w500
                                      )
                                    )
                                  ],
                                ),
                              ),
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)),
                        height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2),
                        color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso),
                      ),
                      ((controller.tareaEvaluacionCursoUi?.tareaDescripcion??"").isEmpty)?
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                        child: Text("${controller.tareaEvaluacionCursoUi?.tareaDescripcion??"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."}",
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                              height: 1.5,
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w500
                          )
                        ),
                      ):Container(),
                      (controller.tareaEvaluacionCursoUi?.recursoArchivoUiList??[]).isNotEmpty?
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                        child: Text("Recursos",
                          style: TextStyle(
                              color: AppTheme.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                              fontFamily: AppTheme.fontTTNorms
                          )
                        ),
                      ):Container(),
                      ListView.builder(
                          padding: EdgeInsets.only(top: 8.0, bottom: 0),
                          itemCount: controller.tareaEvaluacionCursoUi?.recursoArchivoUiList?.length??0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            TareaArchivoUi tareaArchivoUi = controller.tareaEvaluacionCursoUi!.recursoArchivoUiList![index];
                            return Stack(
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      //await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                          border:  Border.all(
                                              width: 1,
                                              color: HexColor(controller.tareaEvaluacionCursoUi?.cursoUi?.colorCurso)
                                          ),
                                          color: AppTheme.white
                                      ),
                                      margin: EdgeInsets.only(bottom: 8),
                                      width: 450,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                              ), // use instead of BorderRadius.all(Radius.circular(20))
                                              color: AppTheme.greyLighten2,
                                            ),
                                            width: 50,
                                            child: Center(
                                              child: Image.asset(getImagen(null),
                                                height: 30.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${tareaArchivoUi.nombre}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                Padding(padding: EdgeInsets.all(2)),
                                                tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaArchivoUi.tipoArchivo == TipoRecursosUi.TIPO_VINCULO?
                                                Text("${(tareaArchivoUi.url??"").isNotEmpty?tareaArchivoUi.url: tareaArchivoUi.descripcion}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 10)):
                                                Text("${(tareaArchivoUi.descripcion??"").isNotEmpty?tareaArchivoUi.descripcion: getDescripcion(tareaArchivoUi.tipoArchivo)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                      (controller.tareaEvaluacionCursoUi?.recursoArchivoUiList??[]).isNotEmpty?
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        height: 1,
                        color: AppTheme.greyLighten1,
                      ):Container(),
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)),
                        child: Text("Comentario de clase",
                          style: TextStyle(
                              color: AppTheme.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                        child: Row(
                          children: [
                            Container(
                                width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 50),
                                height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 50),
                                margin: EdgeInsets.only(top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => SizedBox(
                                  child: Shimmer.fromColors(
                                    baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                    highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                    child: Container(
                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                      decoration: BoxDecoration(
                                          color: AppTheme.colorPrimary,
                                          shape: BoxShape.circle
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                imageUrl: "${controller.fotoAlumno??""}",
                                errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 40,),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                            left: 0,
                                            top: 0,
                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 65),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppTheme.greyLighten3,
                                                borderRadius: BorderRadius.circular(8.0),
                                                border: Border.all(color: AppTheme.greyLighten2),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: TextField(
                                                      maxLines: null,
                                                      keyboardType: TextInputType.multiline,
                                                      style: TextStyle(
                                                        fontSize:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),

                                                      ),
                                                      decoration: InputDecoration(
                                                          isDense: true,
                                                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                          hintText: "",
                                                          border: InputBorder.none),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      // You enter here what you want the button to do once the user interacts with it
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: AppTheme.greyDarken1,
                                    ),
                                    iconSize: 20.0,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 200))
                    ])
                ),
              ],
            ),
          );
        });
  }

  String getImagen(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppIcon.archivo_video;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppIcon.archivo_link;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppIcon.archivo_documento;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppIcon.archivo_imagen;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppIcon.archivo_audio;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppIcon.archivo_hoja_calculo;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppIcon.archivo_diapositiva;
      case TipoRecursosUi.TIPO_PDF:
        return AppIcon.archivo_pdf;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppIcon.archivo_youtube;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppIcon.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppIcon.archivo_recurso;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return AppIcon.archivo_recurso;
    }
  }

  String getDescripcion(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return "Video";
      case TipoRecursosUi.TIPO_VINCULO:
        return "Link";
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return "Documento";
      case TipoRecursosUi.TIPO_IMAGEN:
        return "Imagen";
      case TipoRecursosUi.TIPO_AUDIO:
        return "Audio";
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return "Hoja cálculo";
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return "Presentación";
      case TipoRecursosUi.TIPO_PDF:
        return "Documento Portátil";
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return "Youtube";
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return "Drive";
      case TipoRecursosUi.TIPO_RECURSO:
        return "Recurso";
      case TipoRecursosUi.TIPO_ENCUESTA:
        return "Recurso";
    }
  }


}