import 'package:dio/dio.dart';
import 'package:domain/data_repository/character_data_repository.dart';
import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/use_case/get_character_list_uc.dart';
import 'package:domain/use_case/check_is_user_logged_uc.dart';
import 'package:domain/use_case/check_has_shown_tutorial_uc.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';
import 'package:flutter_app/data/remote/data_source/character_rds.dart';
import 'package:flutter_app/data/remote/infrastructure/espim_dio.dart';
import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:flutter_app/data/repository/auth_repository.dart';
import 'package:flutter_app/data/repository/character_repository.dart';
import 'package:flutter_app/data/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'main_container/main_container_screen.dart';
import 'navigation_utils.dart';


class GeneralProvider extends StatelessWidget {
  const GeneralProvider({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._buildRDSProviders(),
      ..._buildCDSProviders(),
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
    ProxyProvider<Dio, AuthRDS>(
      update: (context, dio, _) => AuthRDS(dio: dio),
    ),
  ];

  List<SingleChildWidget> _buildCDSProviders() => [
    ProxyProvider<Dio, UserCDS>(
      update: (context, dio, _) => UserCDS(),
    ),
  ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
    ProxyProvider<CharacterRDS, CharacterDataRepository>(
      update: (context, characterRDS, _) => CharacterRepository(
        characterRDS: characterRDS,
      ),
    ),
    ProxyProvider<AuthRDS, AuthDataRepository>(
      update: (context, authRDS, _) => AuthRepository(
        authRDS: authRDS,
      ),
    ),
    ProxyProvider<UserCDS, UserDataRepository>(
      update: (context, userCDS, _) => UserRepository(
        userCDS: userCDS,
      ),
    ),
  ];

  List<SingleChildWidget> _buildUseCaseProviders() => [
    ProxyProvider<CharacterDataRepository, GetCharacterListUC>(
      update: (context, characterRepository, _) => GetCharacterListUC(
        characterRepository: characterRepository,
      ),
    ),
    ProxyProvider<AuthDataRepository, CheckIsUserLoggedUC>(
      update: (context, authRepository, _) => CheckIsUserLoggedUC(
        authRepository: authRepository,
      ),
    ),
    ProxyProvider<UserDataRepository, CheckHasShownTutorialUC>(
      update: (context, userRepository, _) => CheckHasShownTutorialUC(
        userRepository: userRepository,
      ),
    ),
  ];

  List<SingleChildWidget> _buildRouteFactory() => [
    Provider<Router>(
      create: (context) => Router()
        ..define(
          '/',
          handler: Handler(
            handlerFunc: (context, params) => MainContainerScreen.create(),
          ),
        )
    ),

    ProxyProvider<Router, RouteFactory>(
      update: (context, router, _) =>
          (settings) => router.routeGeneratorFactory(context, settings),
    ),
  ];
}