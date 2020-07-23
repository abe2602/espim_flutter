import 'package:domain/use_case/check_has_shown_tutorial_uc.dart';
import 'package:domain/use_case/check_is_user_logged_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/auth/login/login_page.dart';
import 'package:flutter_app/presentation/character_list/character_list_page.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/tutorial/tutorial_page.dart';
import 'package:provider/provider.dart';

import 'main_container_bloc.dart';
import 'main_container_models.dart';

class MainContainerScreen extends StatelessWidget {
  const MainContainerScreen({@required this.bloc}) : assert(bloc != null);
  final MainContainerBloc bloc;

  static Widget create() => ProxyProvider2<CheckIsUserLoggedUC,
          CheckHasShownTutorialUC, MainContainerBloc>(
        update: (context, getSignedUserUC, checkHasShownTutorialUC, _) =>
            MainContainerBloc(
                checkIsUserLoggedUC: getSignedUserUC,
                checkHasShownTutorialUC: checkHasShownTutorialUC),
        child: Consumer<MainContainerBloc>(
          builder: (context, bloc, _) => MainContainerScreen(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (successState) => CharacterListPage.create(),
            errorWidgetBuilder: (errorState) {
              if (errorState is TutorialNotShownError) {
                return TutorialPage();
              } else if (errorState is UserNotLoggedError) {
                return LoginPage();
              }
              return CharacterListPage.create();
            },
          ),
        ),
      );
}
