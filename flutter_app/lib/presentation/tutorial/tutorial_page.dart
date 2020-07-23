import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child:  Container(
        color: Colors.blue,
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('login');
            },
            child: Text('Got It!')
        ),
      ),
    ),
  );
}