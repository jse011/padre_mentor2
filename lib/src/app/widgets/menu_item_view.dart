import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';

import '../utils/app_theme.dart';

class MenuItemView extends StatelessWidget {
  final String? titulo;
  final String? imagepath;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function? onTap;
  const MenuItemView({Key? key, required this.animationController, required this.animation, this.titulo, this.imagepath, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              //margin: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
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
                      blurRadius: 4.0),
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
                  onTap: () {

                      onTap?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                                left: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                                right: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                                bottom: 0
                            ),
                            child: SvgPicture.asset(imagepath??"",
                              semanticsLabel:"Eventos",
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 8),
                            left: 0,
                            right: 0,
                            bottom: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                        ),
                        child: Text(titulo??"",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.colorPrimary,
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                          )
                        ),
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
