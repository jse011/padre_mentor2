import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:padre_mentor/libs/fdottedline/fdottedline.dart';
import 'package:padre_mentor/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:padre_mentor/src/app/page/evaluacion/evaluacion_controller.dart';
import 'package:padre_mentor/src/app/page/evaluacion_informacion/evaluacion_informacion_controller.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_icon.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/app_url_launcher.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/preview_image_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/evaluacion_rubro_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_archivo_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_comentario_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_recursos_ui.dart';
import 'package:padre_mentor/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';
import 'package:shimmer/shimmer.dart';

class EvaluacionInformacionView extends View{
  CursoUi? cursoUi;
  String? rubroEvaluacionId;
  int? alumnoId;

  EvaluacionInformacionView(this.cursoUi, this.rubroEvaluacionId, this.alumnoId);

  @override
  EvaluacionInformacionState createState() => EvaluacionInformacionState(this.cursoUi, this.rubroEvaluacionId, this.alumnoId);

}

class EvaluacionInformacionState extends ViewState<EvaluacionInformacionView, EvaluacionInformacionController> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();
  double? offset = 0.0;
  double topBarOpacity = 0.0;
  
  EvaluacionInformacionState(CursoUi? cursoUi, String? rubroEvaluacionId, int? alumnoId,) : super(EvaluacionInformacionController(cursoUi, rubroEvaluacionId, alumnoId,
    DeviceHttpDatosRepositorio(),
    DataCursoRepository(),
      DataUsuarioAndRepository(),
      DataUsuarioAndRepository()
  ));

  @override
  void initState() {

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

    super.initState();

  }
  
  @override
  Widget get view => ControlledWidgetBuilder<EvaluacionInformacionController>(
      builder: (context, controller) {
        return WillPopScope (
          onWillPop: () async {
           return true;
          },
          child: Container(
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[

                  getMainTab(),
                  if(controller.progress)
                    ArsProgressWidget(
                        blur: 2,
                        dismissable: true,
                        onDismiss: (resp){
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Color(0x33000000),
                        animationDuration: Duration(milliseconds: 500)),
                  getAppBarUI(controller),
                ],
              ),
            ),
          ),
        );
      }
  );

  Widget getMainTab() {
    return ControlledWidgetBuilder<EvaluacionInformacionController>(
        builder: (context, controller) {

          return Container(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  //MediaQuery.of(context).padding.top +
                  0,
            ),
            child:  SingleChildScrollView(
              controller: scrollController,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: (){

                    List<double> tablecolumnWidths = [];
                    /*Calular el tamaño*/
                    for(dynamic s in controller.columns){
                      if(s is ValorTipoNotaUi){
                        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 55));
                      } else if(s is RubroEvaluacionUi){
                        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 85));
                      }  else if(s is EvaluacionRubroUi){
                        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 85));
                      }
                      else{
                        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 50));
                      }
                    }

                    double width_pantalla = MediaQuery.of(context).size.width;
                    double padding_left = ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24);
                    double padding_right = ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24);
                    double width_table = padding_left + padding_right + ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 120);
                    for(double column_px in tablecolumnWidths){
                      width_table += column_px;
                    }
                    double width = 0;
                    if(width_pantalla>width_table){
                      width = width_pantalla;
                    }else{
                      width = width_table;
                    }


                    return Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              0,
                          left: padding_left,
                          right: padding_right
                      ),
                      width: width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (!controller.conexion && !controller.progress)?
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
                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12))),
                          Center(
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
                                    if (("B" == (controller.rubroEvaluacionUi?.tituloNota??"") || "C" == (controller.rubroEvaluacionUi?.tituloNota??""))) {
                                      color = AppTheme.redDarken4;
                                    }else if (("AD" == (controller.rubroEvaluacionUi?.tituloNota??"")) || "A" == (controller.rubroEvaluacionUi?.tituloNota??"")) {
                                      color = AppTheme.blueDarken4;
                                    }else {
                                      color = AppTheme.black;
                                    }

                                    switch(controller.rubroEvaluacionUi?.tipoNotaEnum) {
                                      case TipoNotaEnumUi.SELECTOR_VALORES:
                                        return Container(
                                          child: Center(
                                            child: Text(controller.rubroEvaluacionUi?.tituloNota ?? "",
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
                                            imageUrl: controller.rubroEvaluacionUi?.iconoNota ?? "",
                                             placeholder: (context, url) => SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                          child: Container(
                                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                color: HexColor(controller.cursoUi?.colorCurso2),
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
                                          child: Text("${controller.rubroEvaluacionUi?.nota==null?"-":(controller.rubroEvaluacionUi?.nota??0).toStringAsFixed(1)}", style: TextStyle(
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
                                    //#endregion
                                  }(),
                                ),

                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10))),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)),
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: <Widget>[

                                /*(controller.rubroEvaluacionUi?.tipoNotaEnum == TipoNotaEnumUi.SELECTOR_ICONOS ||
                                    controller.rubroEvaluacionUi?.tipoNotaEnum == TipoNotaEnumUi.SELECTOR_VALORES)?
                               */
                                (controller.rubroEvaluacionUi?.descNota??"").isNotEmpty?
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))),
                                    color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                    bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                    left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Logro",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              color: HexColor(controller.cursoUi?.colorCurso)
                                          )
                                      ),
                                      Text("${controller.rubroEvaluacionUi?.descNota??""}",
                                          style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                                              fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ):Container(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))),
                                    color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                      left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Desempenio", style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          color: HexColor(controller.cursoUi?.colorCurso)
                                      )
                                      ),
                                      Text("${controller.rubroEvaluacionUi?.desempenio??""}",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                                              fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                /*Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))),
                                    color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                  ),
                                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Text("Nota", style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 11),
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.colorPrimary
                                      )
                                      ),
                                      Text("${controller.rubroEvaluacionUi?.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(fontSize: 14, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),*/
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))),
                                    color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8),
                                      left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Puntos", style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          color: HexColor(controller.cursoUi?.colorCurso)
                                      )
                                      ),
                                      Text("${controller.rubroEvaluacionUi?.puntos??"-"}",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                                              fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),

                              ]
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10))),
                          Center(
                            child: Container(
                              width: width_table,
                              child:  showTableRubroDetalle(controller, tablecolumnWidths),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 28))
                          ),
                          Container(
                            width: width,
                            child: Text("Comentarios privados",
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 13),
                                    color: AppTheme.colorPrimary,
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))
                          ),
                          (controller.rubroEvaluacionUi?.comentarioList??[]).isNotEmpty?
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 0),
                              itemBuilder: (context, index) {
                                RubroComentarioUi rubroComentarioUi = controller.rubroEvaluacionUi!.comentarioList![index];
                                return Container(
                                  margin: EdgeInsets.only(top:  16),
                                  padding: EdgeInsets.only( right: padding_right),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) => SizedBox(
                                          child: Shimmer.fromColors(
                                            baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                            highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                            child: Container(
                                              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                              decoration: BoxDecoration(
                                                  color: HexColor(controller.cursoUi?.colorCurso2),
                                                  shape: BoxShape.circle
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        imageUrl: rubroComentarioUi.foto??"",
                                        errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                                width: 40,
                                                height: 40,
                                                margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                            ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.greyLighten3,
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(color: AppTheme.greyLighten2),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                          padding: EdgeInsets.only(right: 8),
                                                          child: Text("${rubroComentarioUi.nombres??""}",
                                                              style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: AppTheme.fontTTNorms
                                                              ))
                                                      )
                                                  ),
                                                  Text("${AppTools.f_fecha_hora_anio_mes_dia_letras(DateTime.fromMillisecondsSinceEpoch(rubroComentarioUi.fechaCreacion??0))}",
                                                      style: TextStyle(
                                                          fontSize:  ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 9),
                                                          color: AppTheme.greyDarken1,
                                                          fontFamily: AppTheme.fontTTNorms
                                                      )
                                                  ),
                                                ],
                                              ),
                                              Padding(padding: EdgeInsets.all(2)),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text("${rubroComentarioUi.descripcion??""}",
                                                  style: TextStyle(
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  )
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                          },
                            itemCount: controller.rubroEvaluacionUi?.comentarioList?.length??0,
                          ):Container(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                              ),
                              child: FDottedLine(
                                color: AppTheme.white,
                                strokeWidth: 3.0,
                                dottedLength: 10.0,
                                space: 3.0,
                                corner: FDottedLineCorner.all(14.0),

                                /// add widget
                                child: Container(
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)),
                                  alignment: Alignment.center,
                                  child: Text("Sin comentarios",  style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AppTheme.fontTTNorms,
                                      color: AppTheme.white
                                  ),),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16))
                          ),
                          Container(
                            width: width,
                            child: Text("Evidencias del docente",
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                    color: AppTheme.colorPrimary,
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8))
                          ),
                          (controller.rubroEvaluacionUi?.archivoList??[]).isNotEmpty?
                          ListView.builder(
                              padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 24),
                                  top: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                  bottom: 0),
                              itemCount: controller.rubroEvaluacionUi?.archivoList?.length??0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                RubroArchivoUi rubroEvidenciaUi =  controller.rubroEvaluacionUi!.archivoList![index];

                                return Stack(
                                  children: [
                                    Center(
                                      child: InkWell(
                                        onTap: () async{

                                          if(rubroEvidenciaUi.tipoRecurso == TipoRecursosUi.TIPO_IMAGEN){
                                            Navigator.of(context).push(PreviewImageView.createRoute(rubroEvidenciaUi.url));
                                          }else{
                                            await AppUrlLauncher.openLink(rubroEvidenciaUi.url, webview: false);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                                              border:  Border.all(
                                                  width: 1,
                                                  color: HexColor(controller.cursoUi?.colorCurso)
                                              ),
                                              color: AppTheme.white
                                          ),
                                          margin: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)),
                                          width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 450),
                                          height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 50),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)),
                                                      topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)),
                                                    ), // use instead of BorderRadius.all(Radius.circular(20))
                                                    color: AppTheme.greyLighten2,
                                                  ),
                                                  width: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 50),
                                                  child: Center(
                                                    child: Image.asset(getImagen(rubroEvidenciaUi.tipoRecurso),
                                                      height: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 30),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${rubroEvidenciaUi.titulo??""}",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: AppTheme.greyDarken3,
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                                                            fontFamily: AppTheme.fontTTNorms,
                                                            fontWeight: FontWeight.w600,
                                                          )),
                                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 2))),
                                                      Text("${getDescripcion(rubroEvidenciaUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: AppTheme.blue,
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10)
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ):Container(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                              ),
                              child: FDottedLine(
                                color: AppTheme.white,
                                strokeWidth: 3.0,
                                dottedLength: 10.0,
                                space: 3.0,
                                corner: FDottedLineCorner.all(14.0),

                                /// add widget
                                child: Container(
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16)),
                                  alignment: Alignment.center,
                                  child: Text("Sin evidencia",  style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 16),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AppTheme.fontTTNorms,
                                      color: AppTheme.white
                                  ),),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(48)
                          ),
                        ],
                      ),
                    );

                  }(),
                ),
              ),
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
        break;
    }
  }

  Widget getAppBarUI(EvaluacionInformacionController controller) {
    return Column(
      children: [
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
                    right: 8,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child:  IconButton(
                          icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child:  Container(
                              margin: EdgeInsets.only(top: 0 + 8 * topBarOpacity, bottom: 8, left: 0, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                  Padding(padding: EdgeInsets.only(left: 4)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Evaluación',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16 + 6 - 6 * topBarOpacity,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),

            ],
          ),
        )
      ],
    );
  }
  
  Widget showTableRubroDetalle(EvaluacionInformacionController controller, List<double> tablecolumnWidths) {
    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 55),
            stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 140),
            contentCellHeight: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 60),
            columnWidths: tablecolumnWidths
        ),
        //cellAlignments: CellAlignments.,
        scrollControllers: ScrollControllers() ,
        columnsLength: controller.columns.length,
        rowsLength: controller.row.length,
        columnsTitleBuilder: (i) {
          dynamic o = controller.columns[i];
          if(o is ValorTipoNotaUi){
            return InkWell(
              //onDoubleTap: () =>  controller.onClicClearEvaluacionAll(o, personaUi),
              //onLongPress: () =>  controller.onClicEvaluacionAll(o, personaUi),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(controller.columns.length - 1 == i ?8: 0)
                      ),
                      child: _getTipoNotaCabeceraV2(i, o, controller)
                  ),
                ],
              ),
            );
          }else if(o is RubroEvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Text("Criterios",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
                      color:  AppTheme.white,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.colorPrimary),
                    right: BorderSide(color: AppTheme.colorPrimary),
                  ),
                  color: AppTheme.colorPrimary,
                )
            );
          }else if(o is EvaluacionRubroUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Text("Nota",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 13),
                      color:  AppTheme.black,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                  ),
                  color: AppTheme.white,
                )
            );
          }else
            return Container(

            );
        },
        rowsTitleBuilder: (i) {

          RubroEvaluacionUi rubricaEvaluacionUi = controller.row[i];
          return  Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.only(
                  left: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 10),
                  right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 5)
              ),
              child: Center(
                  child: Text(rubricaEvaluacionUi.titulo??"",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 11),
                      color:  AppTheme.colorAccent,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w700,
                    ),
                  )
              ),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    left: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.row.length)-1 == i?1:0)),
                  ),
                  color: AppTheme.white
              )
          );
        },
        contentCellBuilder: (i, j){
          dynamic o = controller.cells[j][i];
          if(o is RubroEvaluacionUi){
            return Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color:  AppTheme.greyLighten2),
                    bottom: controller.cells.length-1 == j? BorderSide(color:  AppTheme.greyLighten2) : BorderSide(color:  AppTheme.white),
                  ),
                  color: AppTheme.white
              ),
              child: Center(
                child: Text("${o.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w500,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                    color: AppTheme.black
                ),),
              ),
            );
          }else if(o is ValorTipoNotaUi){
            return Container(
              color: AppTheme.white,
              child: Stack(
                children: [
                  _getTipoNotaV2(o, controller, controller.cells.length,i, j),
                ],
              ),
            );
          }
          /*else if(o is RubricaEvaluacionFormulaPesoUi){
            return InkWell(
              //onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[personaUi]!.length-1) <= j ? 1:0)),
                        ),
                        color: AppTheme.white
                    ),
                    child: Center(
                      child: Text("${(o.formula_peso).toStringAsFixed(0)}%",
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                            color:  AppTheme.greyDarken1
                        ),
                      ),
                    ),
                  ),
                  !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14)
                      )
                  ),
                ],
              ),
            );
          }*/else
            return Container();
        },
        legendCell: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: HexColor(controller.cursoUi?.colorCurso),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)))
                )
            ),
            Container(
                child: Center(
                  child: Text('Criterios',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w800,
                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 13)
                      )
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: HexColor(controller.cursoUi?.colorCurso).withOpacity(0.0),),
                  ),
                )
            ),

          ],
        ),
      ),
    );

  }

  Widget _getTipoNotaV2(ValorTipoNotaUi? valorTipoNotaUi, EvaluacionInformacionController controller,int? length ,int positionX, int positionY) {
    Widget? widget = null;

    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 0){
      if(valorTipoNotaUi?.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 1){
      if(valorTipoNotaUi?.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(valorTipoNotaUi?.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(valorTipoNotaUi?.toggle??false){
        color_fondo = HexColor("#D32F2F");
        color_texto = AppTheme.white;
        color_borde = HexColor("#D32F2F");
      }else {
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#D32F2F");
        color_borde = AppTheme.greyLighten2;
      }
    }else{
      if(valorTipoNotaUi?.toggle??false){
        color_fondo = AppTheme.greyLighten2;
        color_texto =  null;
        color_borde = AppTheme.greyLighten2;
      }else{
        color_fondo = AppTheme.white;
        color_texto = null;
        color_borde = AppTheme.greyLighten2;
      }
    }

    color_fondo = color_fondo.withOpacity(0.8);
    color_borde = AppTheme.greyLighten2.withOpacity(0.8);

    var tipo = valorTipoNotaUi?.tipoNotaEnum??TipoNotaEnumUi.VALOR_NUMERICO;
    
    switch(tipo){
      case TipoNotaEnumUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w900,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 13),
                  color: color_texto?.withOpacity((valorTipoNotaUi?.toggle??false)? 1 : 0.7)
              )),
        );
        break;
      case TipoNotaEnumUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (valorTipoNotaUi?.toggle??false)? 1 : 0.7,
          child: Container(
            margin: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
            padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 2)),
            decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)))
            ),
            child:  CachedNetworkImage(
              imageUrl: valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        color: HexColor(controller.cursoUi?.colorCurso2),
                        shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
        break;
      case TipoNotaEnumUi.VALOR_ASISTENCIA:
      case TipoNotaEnumUi.VALOR_NUMERICO:
      case TipoNotaEnumUi.SELECTOR_NUMERICO:
        double? nota = null;
        if(valorTipoNotaUi?.toggle??false)nota = valorTipoNotaUi?.rubroEvalDetalleUi?.nota;
        else nota = valorTipoNotaUi?.valorNumerico;
/*
        if(nota == 0){
          if(valorTipoNotaUi?.rubroEvalDetalleUi?.tipoNotaEnum == TipoNotaEnumUi.SELECTOR_VALORES ||
              valorTipoNotaUi?.rubroEvalDetalleUi?.tipoNotaEnum == TipoNotaEnumUi.SELECTOR_VALORES){
            if(valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }*/
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w900,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 12),
              color: color_texto
          ),),
        );
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
            bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity(((length??0)-1) <= positionY ? 1:0)),
          ),
          color: color_fondo
      ),
      child: widget,
    );

  }

  Widget _getTipoNotaCabeceraV2(int? index, ValorTipoNotaUi? valorTipoNotaUi, EvaluacionInformacionController controller) {
    Widget? nota = null;
    Color color_fondo;
    Color? color_texto;

    if(index == 0){
      color_fondo = HexColor("#1976d2");
      color_texto = AppTheme.white;
    }else if(index == 1){
      color_fondo =  HexColor("#388e3c");
      color_texto = AppTheme.white;
    }else if(index == 2){
      color_fondo =  HexColor("#FF6D00");
      color_texto = AppTheme.white;
    }else if(index == 3){
      color_fondo =  HexColor("#D32F2F");
      color_texto = AppTheme.white;
    }else{
      color_fondo =  AppTheme.greyLighten2;
      color_texto = null;//defaul
    }

    switch(valorTipoNotaUi?.tipoNotaEnum??TipoNotaEnumUi.VALOR_NUMERICO) {
      case TipoNotaEnumUi.SELECTOR_VALORES:
        nota = Container(
          child: Center(
            child: Text(valorTipoNotaUi?.titulo ?? "",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w900,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 14),
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaEnumUi.SELECTOR_ICONOS:
        nota = Container(
          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 4)),
          decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacion(context, 8)))
          ),
          child: CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono ?? "",
            placeholder: (context, url) => SizedBox(
              child: Shimmer.fromColors(
                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                child: Container(
                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                  decoration: BoxDecoration(
                      color: HexColor(controller.cursoUi?.colorCurso2),
                      shape: BoxShape.circle
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
        break;
      default:
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color_fondo),
          right: BorderSide(color:  color_fondo),
        ),
        color: color_fondo,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nota??Container(),
        ],
      ),
    );
  }

}