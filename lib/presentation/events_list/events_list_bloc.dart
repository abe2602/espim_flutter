import 'package:domain/exceptions.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/user.dart';
import 'package:domain/use_case/get_actives_events_list_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:flutter_app/presentation/events_list/events_list_models.dart';
import 'package:rxdart/rxdart.dart';

class EventsListBloc with SubscriptionBag {
  EventsListBloc({
    @required this.getEventsListUC,
    @required this.getLoggedUserUC,
    @required this.logoutUC,
  })  : assert(getEventsListUC != null),
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

  final GetActiveEventsListUC getEventsListUC;
  final GetLoggedUserUC getLoggedUserUC;
  final LogoutUC logoutUC;

  final _onNewStateSubject = BehaviorSubject<EventsListResponseState>();
  final _onTryAgainSubject = PublishSubject<EventsListResponseState>();
  final _onNewActionEvent = PublishSubject<EventsListResponseState>();
  final _onLogoutSubject = PublishSubject<void>();

  Stream<EventsListResponseState> get onNewState => _onNewStateSubject;

  Stream<EventsListResponseState> get onActionEvent =>
      _onNewActionEvent.stream;

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Sink<void> get onLogout => _onLogoutSubject.sink;

  Stream<EventsListResponseState> _getProgramsList() async* {
    yield Loading();

    try {
      final eventListAndUser = await Future.wait([
        getEventsListUC.getFuture(),
        getLoggedUserUC.getFuture(),
      ]);

      final List<Event> originalProgramList = eventListAndUser[0];
      final User loggedUser = eventListAndUser[1];

      if (originalProgramList.isEmpty) {
        yield EmptyListError();
      } else {
        final programsList = <Event>[null];

        originalProgramList.forEach(programsList.add);

        yield Success(
          eventsList: programsList,
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

  Stream<EventsListResponseState> _logout() async* {
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
