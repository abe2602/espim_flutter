import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/general_provider.dart';
import 'package:flutter_app/presentation/character_detail/character_detail_page.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

//todo: Estou tendo problemas para injetar o Fluro
// então irei seguir sem a injeção, fazendo "na mão"
// volto aqui depois
void main() {
  Router.appRouter
    ..define(
      '/',
      handler: Handler(
        handlerFunc: (context, _) => HomeScreen(),
      ),
    )
    ..define(
      'details',
      handler: Handler(
        handlerFunc: (context, _) => CharacterDetailPage(),
      ),
    );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GeneralProvider(
        child: MaterialApp(
          title: 'Espim',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: (settings) => Router.appRouter
              .matchRoute(context, settings.name, routeSettings: settings)
              .route,
        ),
      );
}
