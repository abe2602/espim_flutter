import 'package:dio/dio.dart';
import 'package:domain/data_repository/character_data_repository.dart';
import 'package:domain/use_case/get_character_list_uc.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/remote/data_source/character_rds.dart';
import 'package:flutter_app/data/remote/infrastructure/espim_dio.dart';
import 'package:flutter_app/data/remote/repository/character_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'home_screen.dart';
import 'navigation_utils.dart';


class GeneralProvider extends StatelessWidget {
  const GeneralProvider({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._buildRDSProviders(),
      ..._buildRepositoryProviders(),
      ..._buildUseCaseProviders(),
      ..._buildRouteFactory(),
    ],
    child: child,
  );

  List<SingleChildWidget> _buildRDSProviders() => [
    Provider<Dio>(
      create: (context) {
        final options = BaseOptions(
          baseUrl:
          'https://www.breakingbadapi.com/api/',
        );

        return EspimDio(options);
      },
    ),
    ProxyProvider<Dio, CharacterRDS>(
      update: (context, dio, _) => CharacterRDS(dio: dio),
    ),
  ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
    ProxyProvider<CharacterRDS, CharacterDataRepository>(
      update: (context, characterRDS, _) => CharacterRepository(
        characterRDS: characterRDS,
      ),
    ),
  ];

  List<SingleChildWidget> _buildUseCaseProviders() => [
    ProxyProvider<CharacterDataRepository, GetCharacterListUC>(
      update: (context, characterRepository, _) => GetCharacterListUC(
        characterRepository: characterRepository,
      ),
    ),
  ];

  List<SingleChildWidget> _buildRouteFactory() => [
    Provider<Router>(
      create: (context) => Router()
        ..define(
          '/',
          handler: Handler(
            handlerFunc: (context, params) => HomeScreen(),
          ),
        )
    ),

    ProxyProvider<Router, RouteFactory>(
      update: (context, router, _) =>
          (settings) => router.routeGeneratorFactory(context, settings),
    ),
  ];
}