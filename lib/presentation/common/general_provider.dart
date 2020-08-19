import 'package:dio/dio.dart';
import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:domain/data_repository/programs_data_repository.dart';
import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/use_case/change_settings_uc.dart';
import 'package:domain/use_case/check_has_shown_landing_page_uc.dart';
import 'package:domain/use_case/check_is_user_logged_uc.dart';
import 'package:domain/use_case/get_actives_events_list_uc.dart';
import 'package:domain/use_case/get_intervention_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/get_programs_list_uc.dart';
import 'package:domain/use_case/get_settings_uc.dart';
import 'package:domain/use_case/login_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:domain/use_case/mark_landing_page_as_seen_uc.dart';
import 'package:domain/use_case/validate_empty_field_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/cache/programs_cds.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';
import 'package:flutter_app/data/remote/data_source/programs_rds.dart';
import 'package:flutter_app/data/remote/data_source/user_rds.dart';
import 'package:flutter_app/data/remote/infrastructure/espim_dio.dart';
import 'package:flutter_app/data/repository/auth_repository.dart';
import 'package:flutter_app/data/repository/programs_repository.dart';
import 'package:flutter_app/data/repository/user_repository.dart';
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
        ProxyProvider<Dio, ProgramsRDS>(
          update: (context, dio, _) => ProgramsRDS(dio: dio),
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
        Provider<UserCDS>(
          create: (context) => UserCDS(),
        ),
        Provider<ProgramsCDS>(
          create: (context) => ProgramsCDS(),
        ),
      ];

  List<SingleChildWidget> _buildRepositoryProviders() => [
        ProxyProvider4<ProgramsRDS, UserCDS, ProgramsCDS, AuthRDS,
            ProgramDataRepository>(
          update: (context, eventsRDS, userCDS, programsCDS, authRDS, _) =>
              ProgramsRepository(
            programsRDS: eventsRDS,
            userCDS: userCDS,
            programsCDS: programsCDS,
            authRDS: authRDS,
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
        Provider<ValidateOpenQuestionTextUC>(
          create: (context) => ValidateOpenQuestionTextUC(),
        ),
        ProxyProvider<UserDataRepository, GetSettingsUC>(
          update: (context, userRepository, _) => GetSettingsUC(
            userRepository: userRepository,
          ),
        ),
        ProxyProvider<UserDataRepository, ChangeSettingsUC>(
          update: (context, userRepository, _) => ChangeSettingsUC(
            userRepository: userRepository,
          ),
        ),
        ProxyProvider<ProgramDataRepository, GetProgramsListUC>(
          update: (context, programsRepository, _) => GetProgramsListUC(
            programsRepository: programsRepository,
          ),
        ),
        ProxyProvider<ProgramDataRepository, GetActiveEventsListUC>(
          update: (context, programsRepository, _) => GetActiveEventsListUC(
            programsRepository: programsRepository,
          ),
        ),
        ProxyProvider<ProgramDataRepository, GetInterventionUC>(
          update: (context, programsRepository, _) => GetInterventionUC(
            programsRepository: programsRepository,
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
