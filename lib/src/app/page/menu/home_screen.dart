import 'dart:math';

import 'package:flutter/material.dart';
import 'package:padre_mentor/bottom_navigation_view/bottom_bar_view.dart';
import 'package:padre_mentor/model/tabIcon_data.dart';
import 'package:padre_mentor/src/app/page/contactos/contactos_view.dart';
import 'package:padre_mentor/src/app/page/eventos_agenda/evento_agenda_view.dart';
import 'package:padre_mentor/src/app/page/familia/famila_view.dart';
import 'package:padre_mentor/src/app/page/portal_alumno/portal_alumno_view.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';

import '../my_diary/my_diary_screen.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key key, this.logo}) : super(key: key);

  final String logo;

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = EventoAgendaView(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          logo: widget.logo,
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      EventoAgendaView(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      PortalAlumnoView(animationController: animationController);
                });
              });
            }else if(index == 2){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ContactosView(animationController: animationController,);
                });
              });

            }else if(index == 3){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = FamiliaView(animationController: animationController,);
                });
              });

            }
          },
        ),
      ],
    );
  }
}
