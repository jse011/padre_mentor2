import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padre_mentor/libs/fdottedline/fdottedline.dart';
import 'package:padre_mentor/src/app/page/evaluacion_informacion/evaluacion_informacion_router.dart';
import 'package:padre_mentor/src/app/page/tarea_evaluacion/tarea_evaluacion_controller.dart';
import 'package:padre_mentor/src/app/page/tarea_informacion/tarea_informacion_router.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/curso_tarea_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:shimmer/shimmer.dart';

class TareaEvaluacionView extends View{
  final int? alumnoId;
  final int? programaAcademicoId;
  final int? anioAcademicoId;
  final String? fotoAlumno;

  TareaEvaluacionView({this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno});

  @override
  _TareaEvaluacionViewState createState() => _TareaEvaluacionViewState(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno);

}

class _TareaEvaluacionViewState extends ViewState<TareaEvaluacionView, TareaEvaluacionController> with TickerProviderStateMixin{
  _TareaEvaluacionViewState(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno) : super(TareaEvaluacionController(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, DataUsuarioAndRepository(),DataCursoRepository(), DeviceHttpDatosRepositorio()));
  late Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late AnimationController animationController;

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
  Widget get view => Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    ),
  );

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
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
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 16,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                      onPressed: () {
                        animationController.reverse().then<dynamic>((data) {
                          if (!mounted) {
                            return;
                          }
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tarea',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700,
                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 22 + 6 - 6 * topBarOpacity),
                            letterSpacing: 1.2,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                    ControlledWidgetBuilder<TareaEvaluacionController>(
                      builder: (context, controller) {
                        return CachedNetworkImage(
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
                            imageUrl: controller.fotoAlumno,
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
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }


  Widget getMainTab() {
    return Row(
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      0,
                ),
                child: ControlledWidgetBuilder<TareaEvaluacionController>(
                    builder: (context, controller) {
                      if((controller.msgConexion??"").isNotEmpty){
                        Fluttertoast.showToast(
                          msg: controller.msgConexion!,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                        controller.successMsg();
                      }
                      return Stack(
                        children: [
                          CustomScrollView(
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                    Card(
                                      color: AppTheme.colorPrimary.withOpacity(0.1) ,
                                      margin: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32),
                                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                          right: 0,
                                          bottom: 0
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10),), // if you need this
                                      ),
                                      elevation: 0,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 0,
                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("${controller.cantSinCalificar}", maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.deepOrangeAccent4,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                      )
                                                  ),
                                                  Text('Sin calificar', maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.black,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 0, right: 16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(controller.cantCalificado.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.blueAccent4,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                      )
                                                  ),
                                                  Text('Calificado', maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.black,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 0,
                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text((controller.cantCalificado+controller.cantSinCalificar).toString(), maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.black,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                      )
                                                  ),
                                                  Text('Total', maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.black,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ])
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                    bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                    left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                    right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)
                                ),
                                sliver:  SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index){
                                      dynamic o = controller.rubroEvaluacionList[index];
                                      if(o is CursoTareaEvaluacionUi){
                                        return Card(
                                          color: HexColor(o.cursoUi?.colorCurso),
                                          margin:  EdgeInsets.only(
                                              top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                              left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24),
                                              right: 0,
                                              bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10)), // if you need this
                                            side: BorderSide(
                                              color: Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 18),
                                                      right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10),
                                                      top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10),
                                                      bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10)),
                                                  child: Text(o.cursoUi?.nombre??"",
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppTheme.white,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20)
                                                      )
                                                  )
                                              )),
                                            ],
                                          ),
                                        );
                                      }else if(o is TareaEvaluacionCursoUi){
                                        return InkWell(
                                          onTap: (){
                                            TareaInformacionRouter.createRoute(context,o, controller.fotoAlumno, controller.alumnoId);
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:  EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(o.cursoUi?.colorCurso),
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, (o.tareaIncial??false)?3:0 )),
                                                              topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,  (o.tareaIncial??false)?3:0 )),
                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 3)),
                                                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 3)),
                                                            )
                                                        ),
                                                        width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                                        height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 70),
                                                      ),
                                                      Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 25),
                                                        height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 25),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: HexColor(o.cursoUi?.colorCurso) ,
                                                                width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 3)
                                                            )
                                                        ),
                                                        child: Center(
                                                          child: Container(
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10),
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: HexColor(o.cursoUi?.colorCurso),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:  EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(o.cursoUi?.colorCurso),
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 3)),
                                                              topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 3)),
                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, o.tareaFinal??false?3:0)),
                                                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, o.tareaFinal??false?3:0)),
                                                            )
                                                        ),
                                                        width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                                        height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 120),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child:  Card(
                                                      color: AppTheme.colorCard,
                                                      margin: EdgeInsets.only(
                                                        top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                                        left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                        right: 0,
                                                        bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10), // if you need this
                                                      ),
                                                      elevation: 0,
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                margin: EdgeInsets.only(
                                                                  left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                                  right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                  top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                  bottom: 0,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Icon(Icons.assignment,
                                                                          color: HexColor(o.cursoUi?.colorCurso),
                                                                          size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                                        ),
                                                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2))),
                                                                        Expanded(child: Text("Tarea ${o.position??""}",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 2,
                                                                            style: TextStyle(
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                fontWeight: FontWeight.w700,
                                                                                letterSpacing: 0.5,
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                                                color: HexColor(o.cursoUi?.colorCurso),
                                                                            ))),
                                                                        //Text("Tarea ${index}", style: TextStyle(color: widget.color1, fontSize: 12, fontWeight: FontWeight.w500),),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                                                    Text(o.tituloTarea??'',
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontFamily: AppTheme.fontTTNorms,
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                        )
                                                                    ),
                                                                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                                                    Text(o.nombreDocente??'',
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontFamily: AppTheme.fontTTNorms,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                        )
                                                                    ),
                                                                  ],
                                                                )
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets.only(
                                                                  left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                                  right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                  top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                  bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Center(
                                                                      child: InkWell(
                                                                        onTap: (o.rubroEvaluacionId!=null&&(o.rubroEvaluacionId?.length??0)>0)?(){

                                                                            EvaluacionInformacionRouter.createRoute(context,o.cursoUi, o.rubroEvaluacionId, controller.alumnoId);

                                                                        }:null,
                                                                        child: Container(
                                                                          width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 55),
                                                                          height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 55),
                                                                          child: FDottedLine(
                                                                            color: AppTheme.greyLighten1,
                                                                            strokeWidth: 1.0,
                                                                            dottedLength: 5.0,
                                                                            space: 3.0,
                                                                            corner: FDottedLineCorner.all(30.0),
                                                                            child: Container(
                                                                              color: AppTheme.greyLighten2,
                                                                              child: (){
                                                                                //#region Nota
                                                                                Color color;
                                                                                if (("B" == (o.tituloNota??"") || "C" == (o.tituloNota??""))) {
                                                                                  color = AppTheme.redDarken4;
                                                                                }else if (("AD" == (o.tituloNota??"")) || "A" == (o.tituloNota??"")) {
                                                                                  color = AppTheme.blueDarken4;
                                                                                }else {
                                                                                  color = AppTheme.black;
                                                                                }
                                                                                if(o.rubroEvaluacionId!=null&&(o.rubroEvaluacionId?.length??0)>0){
                                                                                  switch(o.tipoNotaEnum) {
                                                                                    case TipoNotaEnumUi.SELECTOR_VALORES:
                                                                                      return Container(
                                                                                        child: Center(
                                                                                          child: Text(o.tituloNota ?? "",
                                                                                              style: TextStyle(
                                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 20),
                                                                                                  color: color
                                                                                              )),
                                                                                        ),
                                                                                      );
                                                                                    case TipoNotaEnumUi.SELECTOR_ICONOS:
                                                                                      return Container(
                                                                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
                                                                                        child: CachedNetworkImage(
                                                                                          imageUrl:o.iconoNota ?? "",
                                                                                          placeholder: (context, url) => SizedBox(
                                                                                            child: Shimmer.fromColors(
                                                                                              baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                                                              highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                                                              child: Container(
                                                                                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                                                decoration: BoxDecoration(
                                                                                                    color: HexColor(o.cursoUi?.colorCurso2),
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
                                                                                        child: Text("${o.nota==null?"-":(o.nota??0).toStringAsFixed(1)}", style: TextStyle(
                                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                                                            color: AppTheme.black),
                                                                                        ),
                                                                                      );
                                                                                    default:
                                                                                      return Center(
                                                                                        child: Text("", style: TextStyle(
                                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
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
                                                                    Expanded(child: Container()),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left: 0,
                                                                          right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20),
                                                                      ),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('Entrega',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                color: HexColor(o.cursoUi?.colorCurso),
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2))),
                                                                          Text(o.finDiaSemana??'',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color:Colors.black,
                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                          Text(o.finDia??'--', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                                                              color:((){
                                                                                switch (o.evalEstado){
                                                                                  case TareaEvalEstadoEnumUi.SINFECHA:
                                                                                    return  AppTheme.grey;
                                                                                  case TareaEvalEstadoEnumUi.HA_ENTREGAR:
                                                                                    return AppTheme.black;
                                                                                  case TareaEvalEstadoEnumUi.HA_ENTREGAR_RETRAZO:
                                                                                    return AppTheme.deepOrangeAccent4;
                                                                                  case TareaEvalEstadoEnumUi.ENTREGADO:
                                                                                  //return AppTheme.greenAccent3;
                                                                                    return AppTheme.blueAccent4;
                                                                                }
                                                                              }()),
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                                          )
                                                                          ),
                                                                          Text(o.finMes??'',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin:  EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.black54.withOpacity(0.1),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 1)),
                                                                            topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 1)),
                                                                            bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, o.tareaFinal??false?3:0)),
                                                                            bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, o.tareaFinal??false?3:0)),
                                                                          )
                                                                      ),
                                                                      width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2),
                                                                      height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 70),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                        left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
                                                                        right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                                                      ),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('Publicación',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                color: HexColor(o.cursoUi?.colorCurso),
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2))),
                                                                          Text(o.incioDiaSemana??'-',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                          Text(o.incioDia??'-',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: AppTheme.black,
                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                                                              )
                                                                          ),
                                                                          Text(o.incioMes??'-',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                                                                              )
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }else{
                                        print(o);
                                        return Container();
                                      }

                                    },
                                    childCount: controller.rubroEvaluacionList.length,
                                  ),

                                ),
                              ),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(padding: EdgeInsets.all(100))
                                  ])
                              ),
                            ],
                          ),
                          controller.isLoading ?  Container(child: Center(
                            child: CircularProgressIndicator(),
                          )): Container(),
                        ],
                      );
                    })
            )),
        Container(
            width: 32,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0,
            ),
            child: ControlledWidgetBuilder<TareaEvaluacionController>(
                builder: (context, controller) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.calendarioPeriodoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child:Container(
                              margin: const EdgeInsets.only(top: 0, left: 8, right: 0, bottom: 0),
                              decoration: BoxDecoration(
                                color: AppTheme.colorAccent,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft:const Radius.circular(10.0),
                                ),
                              ),
                              child: Container(
                                height: 110,
                                margin: const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 1),
                                decoration: BoxDecoration(
                                  color: (controller.calendarioPeriodoList[index].selected ??false)? AppTheme.white: AppTheme.colorAccent,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft:const Radius.circular(10.0),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                                    splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                                    onTap: () {
                                      controller.onSelectedCalendarioPeriodo(controller.calendarioPeriodoList[index]);
                                    },
                                    child: Center(
                                      child: RotatedBox(quarterTurns: 1,
                                          child: Text((controller.calendarioPeriodoList[index].nombre??"").toUpperCase(), style: TextStyle(color: (controller.calendarioPeriodoList[index].selected??false) ? AppTheme.colorAccent: AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w600, fontSize: 9), )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        );
                      }
                  );
                }),
        )
      ],
    );
  }
}