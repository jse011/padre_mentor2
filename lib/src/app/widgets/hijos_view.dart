import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/utils/hex_color.dart';

import '../utils/app_theme.dart';

class HijosView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;


  const HijosView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> androidVersionNames = ['jose', 'arias', 'orezano', 'ju'];

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: OrientationBuilder(
                    builder: (context, orientation) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 6),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          return Container(
                                margin: EdgeInsets.fromLTRB (8.0, 0.0, 8.0, 0.0),
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
                                child: Center(
                                    child:Text(androidVersionNames[position])
                                )
                            );
                        },
                        itemCount: androidVersionNames.length,
                      );
                    }),
            ),
          ),
        );
      },
    );
  }
}
