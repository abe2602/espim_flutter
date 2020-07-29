import 'package:domain/use_case/check_is_user_logged_uc.dart';
import 'package:domain/use_case/check_has_shown_landing_page_uc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:rxdart/rxdart.dart';

import 'main_container_models.dart';

class MainContainerBloc with SubscriptionBag {
  MainContainerBloc({
    @required this.checkIsUserLoggedUC,
    @required this.checkHasShownTutorialUC,
  })  : assert(checkIsUserLoggedUC != null),
        assert(checkHasShownTutorialUC != null) {
    MergeStream([
      _getFlow(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final CheckIsUserLoggedUC checkIsUserLoggedUC;
  final CheckHasShownLandingPageUC checkHasShownTutorialUC;
  final _onNewStateSubject = BehaviorSubject<MainScreenResponseState>();

  Stream<MainScreenResponseState> get onNewState => _onNewStateSubject;

  Stream<MainScreenResponseState> _getFlow() async* {
    try {
      final flowConditions = await Future.wait([
        checkIsUserLoggedUC.getFuture(),
        checkHasShownTutorialUC.getFuture(),
      ]);

      final isUserLogged = flowConditions[0];
      final hasShowTutorial = flowConditions[1];

      if (!hasShowTutorial) {
        yield TutorialNotShownError();
      } else if (!isUserLogged) {
        yield UserNotLoggedError();
      } else {
        yield Success();
      }
    } catch (exception) {
      yield GenericError();
    }
  }

  void dispose() {
    _onNewStateSubject.close();
  }
}
