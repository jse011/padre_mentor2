import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/editar_usuario/editar_usuario_view.dart';
import 'package:padre_mentor/src/app/page/familia/famila_controller.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/app/widgets/custom_expansion_tile.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';

class FamiliaView extends View{

  final AnimationController animationController;
  ValueNotifier<Key?> _expanded = ValueNotifier(null);
  FamiliaView({required this.animationController});

  @override
  _FamiliaViewState createState() => _FamiliaViewState();

}

class _FamiliaViewState extends ViewState<FamiliaView, FamiliaController>{
  late Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  _FamiliaViewState() : super(FamiliaController(DeviceHttpDatosRepositorio(), DataUsuarioAndRepository()));


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

    Future.delayed(const Duration(milliseconds: 500), () {
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
                                  'Mi perfil',
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

  int countView = 11;
  Widget getMainListViewUI() {
    return AnimationView(
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: widget.animationController,
          curve:
          Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: widget.animationController,
      child: Container(
          padding: EdgeInsets.only(
            top: AppBar().preferredSize.height +
                MediaQuery
                    .of(context)
                    .padding
                    .top +
                0,
            bottom: 62 + MediaQuery
                .of(context)
                .padding
                .bottom,
          ),
          child: ControlledWidgetBuilder<FamiliaController>(
              builder: (context, controller) {
                return CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 48, top: 16),
                                  child: CachedNetworkImage(
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      imageUrl: '${controller.usuarioUi?.foto??''}',
                                      imageBuilder: (context, imageProvider) => Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(color: AppTheme.grey.withOpacity(0.2), offset: const Offset(1.0, 1.0), blurRadius: 1),
                                              ]
                                          )
                                      )
                                  ),
                                ),
                                Expanded(
                                    child:  Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 24, left: 8, right: 24),
                                            child: Text(controller.usuarioUi?.nombre??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              focusColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                              splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                              onTap: () {
                                                _navigateAndDisplaySelection(context, controller);
                                              },
                                              child:
                                              Container(
                                                  padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
                                                  width: 180,
                                                  child: Row(
                                                    children: [
                                                      Padding(padding: const EdgeInsets.only(right: 8),
                                                        child: Icon(Icons.edit_road , size: 20,),),
                                                      Text("EDITAR MI PERFIL", style: TextStyle(fontSize: 10),),
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8, right: 24),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8, right: 24),
                              child: Text("INFORMACIÓN BÁSICA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.colorAccent)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8, right: 24),
                              child: Text("EDAD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8, right: 24),
                              child: Text(controller.usuarioUi?.fechaNacimiento??'', style: TextStyle(fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 16, right: 24),
                              child: Divider(),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 48,  right: 24),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only( top: 8),
                                            child: Text("TELÉFONO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only( top: 8),
                                            child: Text(controller.usuarioUi?.celular??'Sin teléfono', style: TextStyle(fontSize: 16)),
                                          ),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text("CORREO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only( top: 8),
                                            child: Text(controller.usuarioUi?.correo??'Sin correo', style: TextStyle(fontSize: 16)),
                                          ),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 16, right: 24),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8, right: 24),
                              child: Text("MI FAMILIA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.colorAccent)),
                            ),
                          ],
                        )
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index){
                              HijosUi hijoUi = controller.hijosUiList[index];
                              return  Container(
                                padding: const EdgeInsets.only(left: 36, top: 8, right: 24),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: CustomExpansionTile(
                                    expandedItem: widget._expanded,
                                    key: Key(hijoUi.personaId.toString()??''),
                                    title: Container(
                                        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(hijoUi.nombre??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkerText, fontWeight: FontWeight.w400),),
                                            Text("Hijo", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: AppTheme.lightText.withOpacity(0.9), fontWeight: FontWeight.w400),),
                                          ],
                                        )


                                    ),
                                    /*trailing: Container(
                                  height: 10,
                                  width: 10,
                                ),*/
                                    leading: CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        imageUrl: hijoUi.foto??'',
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                            )
                                    ),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 0),
                                        child: Text("INFORMACIÓN BÁSICA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.colorAccent)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 24),
                                        child: Text("EDAD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 24),
                                        child: Text(hijoUi.fechaNacimiento??'', style: TextStyle(fontSize: 16)),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.only(top: 4, left: 14,  right: 24),
                                        child:  Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text("TELÉFONO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text(hijoUi.celular != null && (hijoUi.celular??"").isNotEmpty ? hijoUi.celular??"": 'Sin teléfono', style: TextStyle(fontSize: 16)),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: Text("CORREO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text(hijoUi.correo != null && (hijoUi.correo??"").isNotEmpty? hijoUi.correo??"" : 'Sin correo', style: TextStyle(fontSize: 16)),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 16, right: 24),
                                        child: Divider(
                                          color: AppTheme.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: controller.hijosUiList.length
                        )
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index){
                              FamiliaUi familiaUi = controller.familiaUiList[index];
                              return  Container(
                                padding: const EdgeInsets.only(left: 36, top: 8, right: 24),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: CustomExpansionTile(
                                    expandedItem: widget._expanded,
                                    key: Key(familiaUi?.personaId.toString()??''),
                                    title: Container(
                                        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(familiaUi?.nombre??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkerText, fontWeight: FontWeight.w400),),
                                            Text(familiaUi?.relacion??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: AppTheme.lightText.withOpacity(0.9), fontWeight: FontWeight.w400),),
                                          ],
                                        )


                                    ),
                                    /*trailing: Container(
                                  height: 10,
                                  width: 10,
                                ),*/
                                    leading: CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        imageUrl: familiaUi?.foto??'',
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                            )
                                    ),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 0),
                                        child: Text("INFORMACIÓN BÁSICA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.colorAccent)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 24),
                                        child: Text("EDAD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 8, right: 24),
                                        child: Text(familiaUi?.fechaNacimiento??'', style: TextStyle(fontSize: 16)),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.only(top: 4, left: 14,  right: 24),
                                        child:  Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text("TELÉFONO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text(familiaUi.celular != null && (familiaUi.celular??"").isNotEmpty ? familiaUi.celular??"": 'Sin teléfono', style: TextStyle(fontSize: 16)),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: Text("CORREO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.lightText.withOpacity(0.7))),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only( top: 8),
                                                      child: Text(familiaUi.correo != null && (familiaUi.correo??"").isNotEmpty? familiaUi.correo??"" : 'Sin correo', style: TextStyle(fontSize: 16)),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 16, right: 24),
                                        child: Divider(
                                          color: AppTheme.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: controller.familiaUiList.length
                        )
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(
                            [
                              Container(
                                height: 50,
                              )
                            ]
                        )
                    )
                  ],
                );
              })
      ),
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  _navigateAndDisplaySelection(BuildContext context, FamiliaController controller) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    bool change = await Navigator.push(
      context,
        MaterialPageRoute(builder: (context) => EditarUsuarioView(cabecera: true,), settings: RouteSettings(name: EditarUsuarioView.Name))
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if(change!=null && change){
      controller.getDatosGenerales();
    }
    /*
    Fluttertoast.showToast(
      msg: "EditarUsuarioRouter change: " +change?.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );*/
  }
}