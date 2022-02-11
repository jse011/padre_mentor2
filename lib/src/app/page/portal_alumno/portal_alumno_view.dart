import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:padre_mentor/src/app/page/asistencia/asistencia_router.dart';
import 'package:padre_mentor/src/app/page/boleta_notas/boleta_notas_router.dart';
import 'package:padre_mentor/src/app/page/comportamiento/comportamiento_router.dart';
import 'package:padre_mentor/src/app/page/cursos/cursos_router.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_router.dart';
import 'package:padre_mentor/src/app/page/evaluacion/evaluacion_router.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/informacion/evento_info_router.dart';
import 'package:padre_mentor/src/app/page/horarios/horarios_router.dart';
import 'package:padre_mentor/src/app/page/informacion_evento_agenda/informacion_evento_agenda_view.dart';
import 'package:padre_mentor/src/app/page/portal_alumno/portal_alumno_controller.dart';
import 'package:padre_mentor/src/app/page/prematricula/prematricula_router.dart';
import 'package:padre_mentor/src/app/page/tarea_evaluacion/tarea_evaluacion_router.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/app/widgets/area_list_view.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/hijos_view.dart';
import 'package:padre_mentor/src/app/widgets/menu_alumno_list_view.dart';
import 'package:padre_mentor/src/app/widgets/menu_item_view.dart';
import 'package:padre_mentor/src/app/widgets/programa_educativo_view.dart';
import 'package:padre_mentor/src/app/widgets/running_view.dart';
import 'package:padre_mentor/src/app/widgets/title_view.dart';
import 'package:padre_mentor/src/app/widgets/workout_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';

class PortalAlumnoView extends View{
  final AnimationController animationController;
  final CarouselController buttonCarouselController = CarouselController();
  PortalAlumnoView({required this.animationController});
  //const PortalAlumnoView({Key key, this.animationController}) : super(key: key);

  @override
  _PortalAlumnoState createState() =>
      _PortalAlumnoState(this.buttonCarouselController);

}

class _PortalAlumnoState extends ViewState<PortalAlumnoView, PortalAlumnoController> {

  late Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  CarouselController carouselController = CarouselController();
  double topBarOpacity = 0.0;

  int _currentIndex = 0;

  _PortalAlumnoState(buttonCarouselController) :  super(PortalAlumnoController( DeviceHttpDatosRepositorio(), DataUsuarioAndRepository()));

  @override
  void initState() {
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

    Future.delayed(const Duration(milliseconds: 700), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });
    super.initState();
  }

  @override
  Widget get view => Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainListViewUI(),
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
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget? child) {
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
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 48),
                            right: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                            top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 10 ),
                            bottom: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 12 - 8.0 * topBarOpacity)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Estudiante',
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
                            ),
                            ControlledWidgetBuilder<PortalAlumnoController>(
                              builder: (context, controller) {
                                if(controller.hijoSelected==null){
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB (00.0, 00.0, 00.0, 00.0),
                                  );
                                }else{
                                  return CachedNetworkImage(
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      imageUrl:controller.hijoSelected == null ? '' : '${controller.hijoSelected?.foto}',
                                      imageBuilder: (context, imageProvider) => Container(
                                          height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 48),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 48),
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
                                }
                              },
                            )
                          ],
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

  List<int> list = [1,2,3,4,5];
  int countView = 11;
  Widget getMainListViewUI() {
    return Container(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              0,
          bottom: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 62) + MediaQuery.of(context).padding.bottom,
        ),
      child: ControlledWidgetBuilder<PortalAlumnoController>(
          builder: (context, controller) {
            int pagePosition = 0;
            if(controller.programaEducativoList!=null&&controller.programaEducativoSelected!=null){
              pagePosition = controller.programaEducativoList.indexWhere((element) => controller.programaEducativoSelected?.programaId == element.programaId
                  && controller.programaEducativoSelected?.anioAcademicoId == element.anioAcademicoId && controller.programaEducativoSelected?.alumnoId == element.alumnoId);
              print("pagePosition ");
            }else{
              pagePosition = 0;
              print("pagePosition null");
            }
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 220),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 220),
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 10),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  pauseAutoPlayOnTouch: true,
                                  //initialPage: pagePosition,
                                  aspectRatio: 2.0,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    //_currentIndex = index;
                                    //controller.onSelectedProgramaSelected(controller.programaEducativoList[index]);
                                  },
                                ),
                                items:controller.eventoUiList.map((item){

                                  Color? color;
                                  switch(item.tipoEventoUi?.tipo){
                                    case EventoIconoEnumUI.DEFAULT:
                                      color = Color(0xFF00BCD4);
                                      break;
                                    case EventoIconoEnumUI.EVENTO:
                                      color = Color(0xFF4CAF50);
                                      break;
                                    case EventoIconoEnumUI.NOTICIA:
                                      color = Color(0xFF03A9F4);
                                      break;
                                    case EventoIconoEnumUI.ACTIVIDAD:
                                      color = Color(0xFFFF9800);
                                      break;
                                    case EventoIconoEnumUI.TAREA:
                                      color = Color(0xFFE91E63);
                                      break;
                                    case EventoIconoEnumUI.CITA:
                                      color = Color(0xFF00BCD4);
                                      break;
                                    case EventoIconoEnumUI.AGENDA:
                                      color = Color(0xFFAD3FF8);
                                      break;
                                    case EventoIconoEnumUI.TODOS:
                                      color = Color(0xFF00BCD4);
                                      break;
                                  }

                                  String? foto;
                                  if (item.tipoEventoUi?.tipo == EventoIconoEnumUI.NOTICIA ||
                                      item.tipoEventoUi?.tipo == EventoIconoEnumUI.EVENTO || (item.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && item.foto!=null&&(item.foto??"").isNotEmpty)){

                                    if(item.eventoAdjuntoUiPreviewList?.isNotEmpty??false){
                                      foto = item.eventoAdjuntoUiPreviewList![0].imagePreview;
                                    }else{
                                      foto = item.foto;
                                    }

                                  }else{
                                    foto = null;
                                  }

                                  return InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(EventoInfoRouter.createRouteInfoEventoComplejo(eventoUi: item));
                                    },
                                    child: WorkoutView(
                                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                          parent: widget.animationController,
                                          curve:
                                          Interval((1 / countView) * 2, 1.0, curve: Curves.fastOutSlowIn))),
                                      animationController: widget.animationController,
                                      titulo1: item.nombreEmisor,
                                      titulo2: item.titulo,
                                      subTitulo: item.rolEmisor,
                                      foto: foto,
                                      colors1: Colors.black,
                                      colors2: color??Color(0xFF4CAF50),
                                    ),
                                  );


                                }).toList(),
                              ),
                            ),
                            AnimationView(
                              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                  parent: widget.animationController,
                                  curve:
                                  Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                              animationController: widget.animationController,
                              child: TitleView(
                                titleTxt: 'Programa Educativo',
                                subTxt: "Cambiar",
                                onClick: (){
                                  if(carouselController!=null)carouselController.nextPage();
                                },
                              ),
                            ),

                            AnimationView(
                              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                  parent: widget.animationController,
                                  curve:
                                  Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                              animationController: widget.animationController,
                              child:  Container(
                                margin: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 8),
                                ),
                                height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 120),
                                child: CarouselSlider(
                                  key: Key("car_"+ (pagePosition!=null?pagePosition.toString():"0")),
                                  carouselController: carouselController,
                                  options: CarouselOptions(
                                    height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 120),
                                    autoPlay: false,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    pauseAutoPlayOnTouch: true,
                                    initialPage: pagePosition,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      _currentIndex = index;
                                      controller.onSelectedProgramaSelected(controller.programaEducativoList[index]);
                                    },
                                  ),
                                  items: controller.programaEducativoList!=null?controller.programaEducativoList.map((item) => ProgramaEducativoView(titulo: item.nombrePrograma, subTitulo: "Año ${item.nombreAnioAcademico??""}", subTitulo2: item.nombreHijo, foto: item.fotoHijo, cerrado: item.cerrado,)).toList():[],
                                ),
                              ),

                            )

                          ],
                        )
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 8),
                          left: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 48),
                          right: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 48),
                      ),
                      sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ColumnCountProvider.columnsForWidthPortalAlumnoOpciones(context),
                            mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24),
                            crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24),
                            childAspectRatio: 1.0,

                          ),
                          delegate: SliverChildListDelegate(
                              [
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Tareas",
                                  imagepath: "assets/fitness_app/icono_tarea.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(TareaEvaluacionRouter.createRouteEvaluacion(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Evaluación",
                                  imagepath: "assets/fitness_app/icono_evaluacion.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(EvaluacionRouter.createRouteEvaluacion(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Asistencia",
                                  imagepath: "assets/fitness_app/icono_asistencia.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(AsistenciaRouter.createRouteAsistencia(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Comportamiento",
                                  imagepath: "assets/fitness_app/icono_comportamiento.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(ComportamientoRouter.createRouteComportamiento(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Horario",
                                  imagepath: "assets/fitness_app/icono_horario.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(HorariosRouter.createRouteHorarios(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Cursos",
                                  imagepath: "assets/fitness_app/icono_curso.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(CursosRouter.createRouteCursosRouter(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Boleta de Nota",
                                  imagepath: "assets/fitness_app/icono_boleta.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(BoletaNotasRouter.createRouteBoletaNotas(programaAcademicoId: programaEducativo.programaId, alumnoId: programaEducativo.hijoId, anioAcademico: programaEducativo.anioAcademicoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                MenuItemView(
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                      parent: widget.animationController,
                                      curve:
                                      Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                  animationController: widget.animationController,
                                  titulo: "Pago en línea",
                                  imagepath: "assets/fitness_app/icono_pago.svg",
                                  onTap: () {
                                    var programaEducativo = controller.programaEducativoSelected;
                                    if(programaEducativo!=null){
                                      Navigator.of(context).push(EstadoCuentaRouter.createRouteEstadoCuenta(alumnoId: programaEducativo.hijoId, fotoAlumno: programaEducativo.fotoHijo));
                                    }
                                  },
                                ),
                                if(controller.showPrematricula)
                                  MenuItemView(
                                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                        parent: widget.animationController,
                                        curve:
                                        Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                                    animationController: widget.animationController,
                                    titulo: controller.tituloPrematricula??"",
                                    imagepath: "assets/fitness_app/icono_prematricula.svg",
                                    onTap: () {
                                      var programaEducativo = controller.programaEducativoSelected;
                                      if(programaEducativo!=null){
                                        Navigator.of(context).push(PrematriculaRouter.createRoutePrematricula(alumnoId: programaEducativo.hijoId, fotoAlumno: programaEducativo.fotoHijo));
                                      }
                                    },
                                  )
                              ]
                          )
                      ),
                    ),
                    //https://www.flaticon.es/packs/online-learning-192?k=1611187904419
                    SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 100,
                            ),


                          ],
                        )
                    ),
                  ],
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
                                      imageUrl: controller.hijoSelected == null ? '' : '${controller.hijoSelected?.foto}',
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
                                                          Navigator.of(context).push(EstadoCuentaRouter.createRouteEstadoCuenta(fotoAlumno: controller.hijoSelected?.foto , alumnoId: controller.hijoSelected?.personaId));

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
                )
              ],
            );
          })
      );
    /*ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        widget.animationController.forward();
        return listViews[index];
      },
    );*/
  }

}

class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: color,
      alignment: Alignment.center,

    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? AppTheme.colorPrimary,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}