import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/cursos/curso_controller.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_curso_repository.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';

class CursoView extends View{
  final int programaAcademicoId;
  final int alumnoId;
  final int anioAcademicoId;
  final String fotoAlumno;


  CursoView({this.programaAcademicoId, this.alumnoId, this.anioAcademicoId, this.fotoAlumno});

  @override
  _CursoViewState createState() => _CursoViewState(this.alumnoId, this.programaAcademicoId, this.anioAcademicoId, this.fotoAlumno);

}

class _CursoViewState extends ViewState<CursoView, CursoController> with TickerProviderStateMixin{
  Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController animationController;

  _CursoViewState(alumnoId,programaAcademicoId, anioAcademicoId, fotoAlumno) : super(CursoController(alumnoId, programaAcademicoId, anioAcademicoId, fotoAlumno, DataCursoRepository()));

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
  Widget get view =>  Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
        ],
      ),
    ),
  );
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
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
                                  'Cursos',
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
                            ControlledWidgetBuilder<CursoController>(
                              builder: (context, controller) {
                                if(false){
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB (00.0, 00.0, 00.0, 00.0),
                                  );
                                }else{
                                  return CachedNetworkImage(
                                      placeholder: (context, url) => CircularProgressIndicator(),
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

  int countView = 4;
  Widget getMainTab() {
    return Container(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              0,
        ),
        child: AnimationView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
              Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
          child:  ControlledWidgetBuilder<CursoController>(
              builder: (context, controller) {

                return Stack(
                  children: [
                    CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index){
                                  CursoUi cursoUi = controller?.cursoUiList[index];
                                  return  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 16, bottom: 18),
                                    child: Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color:  cursoUi.colorCurso!=null&&cursoUi.colorCurso.isNotEmpty?
                                                HexColor(cursoUi.colorCurso):AppTheme.nearlyDarkBlue,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey.withOpacity(0.6),
                                              offset: Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft: Radius.circular(8.0),
                                                bottomRight: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0)
                                            ),
                                            child: Opacity(
                                              opacity: 0.6,
                                              child: cursoUi.imagenCurso!=null?FancyShimmerImage(
                                                boxFit: BoxFit.cover,
                                                imageUrl: cursoUi.imagenCurso??'',
                                                width: MediaQuery.of(context).size.width,
                                                errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                              ):
                                              Container(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top:0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(cursoUi.nombre??"", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 28, color: AppTheme.white),),
                                                              Text((cursoUi.grado??"") + " " + (cursoUi.seccion??"") + " - " + (cursoUi.nivelAcademico??""), style: TextStyle(fontSize: 14, color: AppTheme.white, fontWeight: FontWeight.w700),),
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    CachedNetworkImage(
                                                        placeholder: (context, url) => CircularProgressIndicator(),
                                                        imageUrl: cursoUi.fotoDocente??"",
                                                        imageBuilder: (context, imageProvider) => Container(
                                                            height: 52,
                                                            width: 52,
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
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                    child: Container(

                                                    )
                                                ),
                                                Row(
                                                  children: [
                                                    Text(cursoUi.nombreDocente??"", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: AppTheme.white)),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    Text(cursoUi.salon??"", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: AppTheme.white))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                            },
                            childCount: controller.cursoUiList?.length,
                          ),

                        ),
                      ],
                    ),
                    controller.isLoading ?  Container(child: Center(
                      child: CircularProgressIndicator(),
                    )): Container(),
                  ],
                );
              }),
        )
    );
  }
}