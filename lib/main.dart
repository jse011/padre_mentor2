import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/app/page/home/home_view.dart';
import 'package:padre_mentor/src/app/page/login/login_view.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';


void main() {
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // it should be the first line in main method
    //WidgetsFlutterBinding.ensureInitialized();
    //UseCase
    FlutterCleanArchitecture.debugModeOn();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: ' ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        //platform: TargetPlatform.iOS,
      ),
      //home: MyHomePage(),
      home:  HomePage(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => LoginView(),
        '/home' : (BuildContext context) => HomePage(),
      },
    );
  }
}


