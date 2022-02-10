import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';

class SplashView extends StatefulWidget {

  SplashView();


  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        child: new Stack(
          children: <Widget>[
            Container(
              color: ChangeAppTheme.colorEspera(),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: ChangeAppTheme.getApp() != App.ICRM?4:1,
                      child: Container(
                        child: Image.asset(ChangeAppTheme.imagenEspera()),
                      ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ChangeAppTheme.getApp() != App.ICRM?AppTheme.white:AppTheme.colorAccent),
                          ),
                          Padding(padding: const EdgeInsets.only(bottom: 48))
                        ],
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width/2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}