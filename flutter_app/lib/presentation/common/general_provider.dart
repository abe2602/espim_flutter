import 'package:dio/dio.dart';
import 'package:domain/data_repository/events_data_repository.dart';
import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/use_case/get_events_list_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/login_uc.dart';
import 'package:domain/use_case/check_is_user_logged_uc.dart';
import 'package:domain/use_case/check_has_shown_landing_page_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';
import 'package:flutter_app/data/remote/data_source/events_rds.dart';
import 'package:flutter_app/data/remote/data_source/user_rds.dart';
import 'package:flutter_app/data/remote/infrastructure/espim_dio.dart';
import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:flutter_app/data/repository/auth_repository.dart';
import 'package:flutter_app/data/repository/events_repository.dart';
import 'package:flutter_app/data/repository/user_repository.dart';
import 'package:domain/use_case/mark_landing_page_as_seen_uc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GeneralProvider extends StatelessWidget {
  const GeneralProvider({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._buildGoogleSignInProviders(),
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
              baseUrl: 'https://www.espim.com.br:8000/',
            );

            return EspimDio(options);
          },
        ),
        ProxyProvider<Dio, EventsRDS>(
          update: (context, dio, _) => EventsRDS(dio: dio),
        ),
        ProxyProvider<Dio, UserRDS>(
          update: (context, dio, _) => UserRDS(dio: dio),
        ),
        ProxyProvider2<Dio, GoogleSignIn, AuthRDS>(
          update: (context, dio, googleSignIn, _) =>
              AuthRDS(dio: dio, googleSignIn: googleSignIn),
        ),
      ];

  List<SingleChildWidget> _buildCDSProviders() => [
        ProxyProvider<Dio, UserCDS>(
          update: (context, dio, _) => UserCDS(),
        ),
      ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
        ProxyProvider2<EventsRDS, UserCDS, EventsDataRepository>(
          update: (context, eventsRDS, userCDS, _) => EventsRepository(
            eventsRDS: eventsRDS,
            userCDS: userCDS,
          ),
        ),
        ProxyProvider2<AuthRDS, UserCDS, AuthDataRepository>(
          update: (context, authRDS, userCDS, _) => AuthRepository(
            authRDS: authRDS,
            userCDS: userCDS,
          ),
        ),
        ProxyProvider2<UserCDS, UserRDS, UserDataRepository>(
          update: (context, userCDS, userRDS, _) => UserRepository(
            userCDS: userCDS,
            userRDS: userRDS,
          ),
        ),
      ];

  List<SingleChildWidget> _buildUseCaseProviders() => [
        ProxyProvider<EventsDataRepository, GetEventsListUC>(
          update: (context, eventsRepository, _) => GetEventsListUC(
            eventsRepository: eventsRepository,
          ),
        ),
        ProxyProvider<UserDataRepository, GetLoggedUserUC>(
          update: (context, userRepository, _) => GetLoggedUserUC(
            userRepository: userRepository,
          ),
        ),
        ProxyProvider<AuthDataRepository, CheckIsUserLoggedUC>(
          update: (context, authRepository, _) => CheckIsUserLoggedUC(
            authRepository: authRepository,
          ),
        ),
        ProxyProvider<UserDataRepository, CheckHasShownLandingPageUC>(
          update: (context, userRepository, _) => CheckHasShownLandingPageUC(
            userRepository: userRepository,
          ),
        ),
        ProxyProvider<UserDataRepository, MarkLandingPageAsSeenUC>(
          update: (context, userRepository, _) => MarkLandingPageAsSeenUC(
            userRepository: userRepository,
          ),
        ),
        ProxyProvider<AuthDataRepository, LoginUC>(
          update: (context, authRepository, _) => LoginUC(
            authRepository: authRepository,
          ),
        ),
        ProxyProvider<AuthDataRepository, LogoutUC>(
          update: (context, authRepository, _) => LogoutUC(
            authRepository: authRepository,
          ),
        ),
      ];

  List<SingleChildWidget> _buildGoogleSignInProviders() => [
        Provider<GoogleSignIn>(
          create: (context) => GoogleSignIn(),
        ),
      ];

  List<SingleChildWidget> _buildRouteFactory() => [];
}
