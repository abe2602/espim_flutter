import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/general_provider.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/auth/login/login_page.dart';
import 'package:flutter_app/presentation/character_detail/character_detail_page.dart';
import 'package:flutter_app/presentation/character_list/character_list_page.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'main_container/main_container_screen.dart';

//todo: Estou tendo problemas para injetar o Fluro
// então irei seguir sem a injeção, fazendo "na mão"
// volto aqui depois
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await getApplicationDocumentsDirectory()).path);

  Router.appRouter
    ..define(
      '/',
      handler: Handler(
        handlerFunc: (context, _) => MainContainerScreen.create(),
      ),
    )
    ..define(
      'accompaniment',
      handler: Handler(
        handlerFunc: (context, _) => CharacterListPage.create(),
      ),
    )
    ..define(
      'details',
      handler: Handler(
        handlerFunc: (context, _) => CharacterDetailPage(),
      ),
    )
    ..define(
      'login',
      handler: Handler(
        handlerFunc: (context, _) => LoginPage.create(),
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
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateRoute: (settings) => Router.appRouter
              .matchRoute(context, settings.name, routeSettings: settings)
              .route,
        ),
      );
}
