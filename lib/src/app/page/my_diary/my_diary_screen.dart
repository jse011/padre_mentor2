import 'package:flutter/material.dart';


class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();

}

class _MyDiaryScreenState extends State<MyDiaryScreen>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Text("mi diario", style: TextStyle(color: Colors.indigo, fontSize: 50),),
    );
  }
}

