import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padre_mentor/src/app/page/evaluacion/evaluacion_controller.dart';
import 'package:padre_mentor/src/app/page/evaluacion_informacion/evaluacion_informacion_router.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_icon.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/custom_expansion_tile.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/curso_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';

class EvaluacionView extends View{
  final int? alumnoId;
  final int? programaAcademicoId;
  final int? anioAcademicoId;
  final String? fotoAlumno;

  EvaluacionView({this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno});

  @override
  _EvaluacionViewState createState() => _EvaluacionViewState(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno);

}

class _EvaluacionViewState extends ViewState<EvaluacionView, EvaluacionController> with TickerProviderStateMixin{
  _EvaluacionViewState(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno) : super(EvaluacionController(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno,DataUsuarioAndRepository(),DataCursoRepository(), DeviceHttpDatosRepositorio()));
  late Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  late AutoScrollController autoController;
  double topBarOpacity = 0.0;
  late AnimationController animationController;
  ValueNotifier<Key?> _expanded = ValueNotifier(null);

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
      body: ControlledWidgetBuilder<EvaluacionController>(
        builder: (context, controller) {
          return Stack(
            children: <Widget>[
              controller.rubroEvaluacionList.isEmpty?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 32),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 48),
                    ),
                    child: Center(
                      child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Container(
                    padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 32),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 48),
                    ),
                    child: Center(
                      child: Text("Bimestre o trimestre sin evaluaciones \n${!controller.conexion?", revice su conexión a internet":""}",
                          style: TextStyle(
                            color: AppTheme.grey,
                            fontFamily: AppTheme.fontTTNorms,
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                          )
                      ),
                    ),
                  )
                ],
              ):Container(),
              getMainTab(),
              controller.isLoading ?  ArsProgressWidget(
                  blur: 2,
                  dismissable: true,
                  onDismiss: (resp){
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500)): Container(),
              getAppBarUI(),
            ],
          );
        },
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
                          'Evaluación',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700,
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 22 + 6 - 6 * topBarOpacity),
                            letterSpacing: 1.2,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                    ControlledWidgetBuilder<EvaluacionController>(
                      builder: (context, controller) {
                        return CachedNetworkImage(
                            placeholder: (context, url) => SizedBox(
                              child: Shimmer.fromColors(
                                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                child: Container(
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context,8)),
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
                                height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context,45 + 6 - 6 * topBarOpacity),
                                width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context,45 + 6 - 6 * topBarOpacity),
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
        )
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
                child:  ControlledWidgetBuilder<EvaluacionController>(
                    builder: (context, controller) {
                      return Stack(
                        children: [
                          CustomScrollView(
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)
                                ),
                                sliver: SliverToBoxAdapter(
                                  child:  (!controller.conexion && !controller.isLoading)?
                                  Center(
                                    child: Container(
                                        constraints: BoxConstraints(
                                          //minWidth: 200.0,
                                          maxWidth: 600.0,
                                        ),
                                        height: 45,
                                        margin: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                          left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 20),
                                          right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 20),
                                        ),
                                        decoration: BoxDecoration(
                                            color: AppTheme.redLighten5,
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)))
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color:  Colors.red,
                                                  ),
                                                )
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4))),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text('Sin conexión',
                                                  style: TextStyle(
                                                      color:  Colors.red,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  )
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ): Container(),
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, (!controller.conexion && !controller.isLoading)?0:24),
                                    bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                    left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index){
                                      dynamic o = controller.rubroEvaluacionList[index];
                                      if(o is CursoEvaluacionUi){
                                        return InkWell(
                                          key: Key((o.cursoUi?.silaboEventoId??0).toString()),
                                          onTap: (){
                                            controller.onClickCurso(o);
                                          },
                                          child: Card(
                                            color: o.cursoUi?.colorCurso == null ? AppTheme.colorAccent : HexColor(o.cursoUi?.colorCurso),
                                            margin:  EdgeInsets.only(
                                                top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                right: 0,
                                                bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10)), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey.withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child:  Row(
                                              children: [
                                                Expanded(child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 18),
                                                        right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                                                        top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                                                        bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10)),
                                                    child: Text(o.cursoUi?.nombre??"",
                                                        style: TextStyle(
                                                            fontFamily: AppTheme.fontTTNorms,
                                                            fontWeight: FontWeight.w700,
                                                            color: AppTheme.white,
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 20)
                                                        )
                                                    )
                                                )),
                                              ],
                                            ),
                                          ),
                                        );
                                      }else if(o is RubroEvaluacionUi){
                                        return  InkWell(
                                          onTap: (){
                                            EvaluacionInformacionRouter.createRoute(context,o.cursoUi, o.rubroEvalId, controller.alumnoId);
                                          },
                                          child: Container(
                                            key: Key("Rubro_${o.rubroEvalId}"),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:  EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:  EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(o.cursoUi?.colorCurso),
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, (o.evaluacionIncial??false)?3:0 )),
                                                              topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context,  (o.evaluacionIncial??false)?3:0 )),
                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 3)),
                                                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 3)),
                                                            )
                                                        ),
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4),
                                                        height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 45),
                                                      ),
                                                      Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 25),
                                                        height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 25),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: HexColor(o.cursoUi?.colorCurso) ,
                                                                width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 3)
                                                            )
                                                        ),
                                                        child: Center(
                                                          child: Container(
                                                            width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                                                            height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: HexColor(o.cursoUi?.colorCurso),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:  EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(o.cursoUi?.colorCurso),
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 3)),
                                                              topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 3)),
                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, o.evaluacionFinal??false?3:0)),
                                                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, o.evaluacionFinal??false?3:0)),
                                                            )
                                                        ),
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4),
                                                        height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 50),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child:  Card(
                                                      color: AppTheme.colorCard,
                                                      margin: EdgeInsets.only(
                                                          top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                                          left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                          right: 0,
                                                          bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)), // if you need this
                                                      ),
                                                      elevation: 0,
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 20),
                                                                        right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                                        top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                                        bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(o.fecha??'', maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black54,
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                                                                            )
                                                                        ),
                                                                        SizedBox(height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 2),),
                                                                        Text(o.titulo??'',
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                fontWeight: FontWeight.w700,
                                                                               fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                                                            )
                                                                        ),
                                                                        SizedBox(height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 2),),
                                                                        Text(o.tipo??'',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              color: Colors.black54,
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                                                                            )
                                                                        ),
                                                                      ],
                                                                    )
                                                                )
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)),
                                                              width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 68),
                                                              child: (() {

                                                                switch(o.tipoNotaEnum){
                                                                  case TipoNotaEnumUi.SELECTOR_VALORES:
                                                                    return Center(
                                                                      child: Text(o.tituloNota??"",
                                                                          style: TextStyle(
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                                          )
                                                                      ),
                                                                    );
                                                                  case TipoNotaEnumUi.SELECTOR_ICONOS:
                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        o.iconoNota != null && ( o.iconoNota??"").length > 0 ? CachedNetworkImage(
                                                                            height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 40),
                                                                            width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 40),
                                                                            placeholder: (context, url) => CircularProgressIndicator(),
                                                                            imageUrl: o.iconoNota??"",
                                                                            imageBuilder: (context, imageProvider) => Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 30))),
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                )
                                                                            )
                                                                        ) : Container(),
                                                                        SizedBox(height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4),),
                                                                        Text(o.descNota??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: AppTheme.fontName, fontWeight: FontWeight.w500, fontSize: 12))
                                                                      ],
                                                                    );
                                                                  default:
                                                                    return Center(
                                                                      child: Text(o.nota==null?"-":(o.nota??0).toStringAsFixed(1),
                                                                          style: TextStyle(
                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                                                          )
                                                                      ),
                                                                    );
                                                                }

                                                              }()),
                                                            )
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
                                        return Container();
                                      }

                                    },
                                    childCount: controller.rubroEvaluacionList.length,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    })
            )
        ),
        Container(
            width: 32,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0,
            ),
            child: ControlledWidgetBuilder<EvaluacionController>(
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
                                  color:(controller.calendarioPeriodoList[index].selected??false) ? AppTheme.white: AppTheme.colorAccent,
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
                })
        )
      ],
    );
  }
}