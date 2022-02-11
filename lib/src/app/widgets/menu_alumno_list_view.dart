import 'package:flutter/material.dart';

import '../utils/app_theme.dart';


class MenuAlumnoListView extends StatefulWidget {
  const MenuAlumnoListView(
      {Key? key, required this.mainScreenAnimationController, required this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  _MenuAlumnoListViewState createState() => _MenuAlumnoListViewState();
}

class _MenuAlumnoListViewState extends State<MenuAlumnoListView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  List<ItemMenu> areaListData = <ItemMenu>[
   ItemMenu.TAREA,
    ItemMenu.EVALAUCION,
    ItemMenu.ASISTENCIA,
    ItemMenu.COMPORTAMIENTO,
    ItemMenu.HORARIO,
    ItemMenu.CURSOS,
    ItemMenu.BOLETA,
    ItemMenu.ESTADO_CUENTA
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SliverGrid (
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24.0,
        crossAxisSpacing: 24.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate (
            (BuildContext context, int index) {
          String titulo = "";
          String imagepath = "";
          switch(areaListData[index]){
            case ItemMenu.TAREA:
              titulo = "Tareas";
              imagepath = "assets/fitness_app/area1.png";
              break;
            case ItemMenu.EVALAUCION:
              titulo = "Evaluación";
              imagepath = "assets/fitness_app/area2.png";
              break;
            case ItemMenu.ASISTENCIA:
              titulo = "Asistencia";
              imagepath = "assets/fitness_app/area3.png";
              break;
            case ItemMenu.COMPORTAMIENTO:
              titulo = "Comportamiento";
              imagepath = "assets/fitness_app/area1.png";
              break;
            case ItemMenu.HORARIO:
              titulo = "Horario";
              imagepath = "assets/fitness_app/area2.png";
              break;
            case ItemMenu.CURSOS:
              titulo = "Cursos";
              imagepath = "assets/fitness_app/area3.png";
              break;
            case ItemMenu.BOLETA:
              titulo = "Boleta de Nota";
              imagepath = "assets/fitness_app/area1.png";
              break;
            case ItemMenu.ESTADO_CUENTA:
              titulo = "Pago en línea";
              imagepath = "assets/fitness_app/area2.png";
              break;
          }
          final int count = areaListData.length;
          final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();

          return ItemMenuView(
            imagepath: imagepath,
            titulo: titulo,
              animation: animation,
              animationController: animationController
          );
        },
        childCount: areaListData.length,
      ),
    );

  }
}

class ItemMenuView extends StatelessWidget {
  const ItemMenuView({
    Key? key,
    this.titulo,
    this.imagepath,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final String? titulo;
  final String? imagepath;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
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
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: Padding(
                        padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
                        child: Image.asset(imagepath??""),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 16),
                        child: Text(titulo??""),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum ItemMenu{
  TAREA, EVALAUCION, ASISTENCIA, COMPORTAMIENTO, HORARIO, CURSOS, BOLETA, ESTADO_CUENTA
}