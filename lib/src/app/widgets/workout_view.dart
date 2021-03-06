
import 'package:flutter/material.dart';
import 'package:padre_mentor/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';

import '../utils/app_theme.dart';

class WorkoutView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String? titulo1;
  final String? titulo2;
  final String? subTitulo;
  final String? foto;
  final Color? colors1;
  final Color? colors2;
  const WorkoutView({Key? key, required this.animationController, required this.animation, this.titulo1, this.titulo2, this.subTitulo, this.foto, this.colors1, this.colors2 })
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
            child: Padding(
              padding: EdgeInsets.only(
                  left: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24),
                  right: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24),
                  top: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24),
                  bottom: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 18),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    colors1??AppTheme.nearlyDarkBlue,
                    colors2??HexColor("#6F56E8")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
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
                          topRight: Radius.circular(68.0)
                      ),
                      child: Opacity(
                        opacity: 0.3,
                        child: foto!=null?FancyShimmerImage(
                          boxFit: BoxFit.cover,
                          imageUrl: foto??'',
                          width: MediaQuery.of(context).size.width,
                          errorWidget: Icon(
                            Icons.warning_amber_rounded,
                            color: AppTheme.white,
                            size: 50
                          ),
                        ):
                              Container(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 24)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            titulo1??'',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700,
                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 14),
                              letterSpacing: 0.0,
                              color: AppTheme.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              titulo2??'',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 20),
                                letterSpacing: 0.0,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Expanded(child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.perm_contact_calendar,
                                      color: AppTheme.white,
                                      size: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      subTitulo??'',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 14),
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  /*Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.nearlyBlack
                                            .withOpacity(0.4),
                                        offset: Offset(8.0, 8.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.arrow_right,
                                    color: HexColor("#6F56E8"),
                                    size: 44,
                                  ),
                                ),
                              )*/
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
