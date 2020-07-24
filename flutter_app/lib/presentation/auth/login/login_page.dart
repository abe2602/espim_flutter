import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SenSemColors.primaryColor,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('images/img_splash.png'),
            FlatButton(
              color: Colors.white,
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('accompaniment');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('images/google_icon.png'),
                  const Text('LOGIN COM GOOGLE!'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}