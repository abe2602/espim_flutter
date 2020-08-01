import 'package:domain/exceptions.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/program.dart';
import 'package:domain/use_case/get_programs_list_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/programs_list/programs_list_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:domain/model/user.dart';

class ProgramsListBloc with SubscriptionBag {
  ProgramsListBloc({
    @required this.getProgramsListUC,
    @required this.getLoggedUserUC,
    @required this.logoutUC,
  })  : assert(getProgramsListUC != null),
        assert(getLoggedUserUC != null),
        assert(logoutUC != null) {
    _onLogoutSubject.stream
        .flatMap((_) => _logout())
        .listen(_onNewActionEvent.add)
        .addTo(subscriptionsBag);

    MergeStream([
      _onTryAgainSubject.flatMap(
        (_) => _getProgramsList(),
      ),
      _getProgramsList(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final GetProgramsListUC getProgramsListUC;
  final GetLoggedUserUC getLoggedUserUC;
  final LogoutUC logoutUC;

  final _onNewStateSubject = BehaviorSubject<ProgramsListResponseState>();
  final _onTryAgainSubject = PublishSubject<ProgramsListResponseState>();
  final _onNewActionEvent = PublishSubject<ProgramsListResponseState>();
  final _onLogoutSubject = PublishSubject<void>();

  Stream<ProgramsListResponseState> get onNewState => _onNewStateSubject;

  Stream<ProgramsListResponseState> get onActionEvent =>
      _onNewActionEvent.stream;

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Sink<void> get onLogout => _onLogoutSubject.sink;

  Stream<ProgramsListResponseState> _getProgramsList() async* {
    yield Loading();

    try {
      final eventListAndUser = await Future.wait([
        getProgramsListUC.getFuture(),
        getLoggedUserUC.getFuture(),
      ]);

      final List<Program> originalProgramList = eventListAndUser[0];
      final User loggedUser = eventListAndUser[1];

      if (originalProgramList.isEmpty) {
        yield EmptyListError();
      } else {
        final programsList = <Program>[null];

        originalProgramList.forEach(programsList.add);

        yield Success(
          programsList: programsList,
          user: loggedUser,
        );
      }
    } catch (error) {
      if (error is NoInternetException) {
        yield NoInternetError();
      } else {
        yield GenericError();
      }
    }
  }

  Stream<ProgramsListResponseState> _logout() async* {
    try {
      await logoutUC.getFuture();
      yield LogoutSuccess();
    } catch (exception) {
      yield NonBlockingGenericError();
    }
  }

  void dispose() {
    _onLogoutSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onNewActionEvent.close();
  }
}
