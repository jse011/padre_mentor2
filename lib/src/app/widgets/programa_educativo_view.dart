import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ProgramaEducativoView extends StatelessWidget {
  final String? titulo;
  final String? subTitulo;
  final String? subTitulo2;
  final String? foto;
  final bool? cerrado;
  const ProgramaEducativoView({Key? key, this.titulo, this.subTitulo, this.subTitulo2, this.foto, this.cerrado = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: MediaQuery.of(context).size.height*0.30,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
        child:
        Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: 8.0,
                left: 0.0,
                right: 0.0,
                child:  Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.textGrey.withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              if(cerrado??false)
                                Positioned(
                                right: 10,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                    child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(-20/360),
                                      child: Container(
                                        height: 25,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.0,
                                              color: Colors.red
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0) //         <--- border radius here
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("CERRADO", style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w700),),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 70,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/fitness_app/back_3.png",
                                      color: Color(0xFFA9BCFA),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 0),
                                    child: CachedNetworkImage(
                                        height: 60,
                                        width: 60,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        imageUrl: foto??"",
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
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                              ),
                                              child: Text(
                                                titulo??"",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily:
                                                  AppTheme.fontName,
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  color:
                                                  AppTheme.colorPrimary,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 4,
                                                right: 16,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    subTitulo??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 10,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.textGrey
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                  Text(
                                                    subTitulo2??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 10,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.textGrey
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      /*SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/fitness_app/runner.png"),
                      )*/
                    ]
                ),
              )
            ]
        )
    );
  }
}
