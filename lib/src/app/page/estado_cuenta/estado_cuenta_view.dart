import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:padre_mentor/src/app/page/estado_cuenta/estado_cuenta_controller.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';

class EstadoCuentaView extends View{
  final String? fotoAlumno;
  final int? alumnoId;

  EstadoCuentaView({this.fotoAlumno, this.alumnoId});

  @override
  _EstadoCuentaViewState createState() => _EstadoCuentaViewState(this.alumnoId, this.fotoAlumno);

}

class _EstadoCuentaViewState extends ViewState<EstadoCuentaView, EstadoCuentaController>  with TickerProviderStateMixin{
  double _webViewHeight = 1;
  bool _visibleWebView = false;
  InAppWebViewController _webView;
  String url = "";
  double progress = 0;

  Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController animationController;

  _EstadoCuentaViewState(alumnoId, fotoAlumno) : super(EstadoCuentaController(alumnoId, fotoAlumno, DataUsuarioAndRepository()));

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
    color: AppTheme.colorPrimary,
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
                              icon: Icon(Icons.arrow_back, color:  topBarOpacity>0.5? AppTheme.nearlyBlack:AppTheme.white, size: 22 + 6 - 6 * topBarOpacity,),
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
                                  'Pago en línea',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: topBarOpacity>0.5? AppTheme.darkerText:AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                            ControlledWidgetBuilder<EstadoCuentaController>(
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
          child:  ControlledWidgetBuilder<EstadoCuentaController>(
              builder: (context, controller) {

                  return  Stack(
                    children: [
                     controller.hijosUi!=null&&controller.urlServidor!=null?
                     SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            /*Container(height: 100, color: Colors.green),*/
                            AnimatedOpacity(
                              opacity: _visibleWebView ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 2000),
                              child:  Container(
                                height: _webViewHeight==0?  MediaQuery.of(context).size.height:_webViewHeight,
                                child: InAppWebView(
                                  //initialUrl: 'http://educar.icrmedu.com/CRMMovil/PortalAcadMovil.ashx' +'/?misaldo',
                                  initialHeaders: {},
                                  initialOptions: InAppWebViewGroupOptions(
                                      crossPlatform: InAppWebViewOptions(
                                        debuggingEnabled: true,
                                      )),
                                  onWebViewCreated: (InAppWebViewController webController) {

                                    var data = "nrodocumento=" + (controller.hijosUi!=null?controller.hijosUi.documento:"") + "&password="+(controller.hijosUi!=null?controller.hijosUi.personaId.toString():"");
                                    webController.postUrl(
                                        url: (controller.urlServidor??"") +'/?misaldo',
                                        postData: utf8.encode(data));
                                    _webView = webController;

                                  },
                                  onLoadStart: (InAppWebViewController controller, String url) {
                                    setState(() {
                                      this.url = url;
                                    });
                                  },
                                  onLoadStop:
                                      (  controller, String url) async {

                                    controller.evaluateJavascript(source: '''(() => { return document.body.scrollHeight;})()''').then((value) {
                                      if(value == null || value == '') {
                                        return;
                                      }

                                      setState(() {
                                        _webViewHeight = double.parse('$value');
                                        if(_webViewHeight > 400){
                                          Future.delayed(const Duration(milliseconds: 1000), () {
                                            setState(() {
                                              _visibleWebView = true;
                                            });
                                          });
                                        }

                                        print('_onPageFinished: '+ (_webViewHeight!=null?_webViewHeight.toString():"0" ));
                                      });


                                    });

                                    setState(() {
                                      this.url = url;
                                    });
                                  },
                                  onProgressChanged:
                                      (InAppWebViewController controller, int progress) {
                                    setState(() {
                                      this.progress = progress / 100;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                     Container(
                       color: Colors.transparent,
                     ),
                      !_visibleWebView? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.white),
                            ),
                          )): Container(),
                    ],
                  );
              }
          ),
        )
    );
  }

}