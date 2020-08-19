import 'package:domain/model/event.dart';
import 'package:domain/model/user.dart';

abstract class EventsListResponseState {}

class Success implements EventsListResponseState {
  const Success({this.eventsList, this.user});

  final List<Event> eventsList;
  final User user;
}

class LogoutSuccess implements EventsListResponseState{}

class Loading implements EventsListResponseState {}

class Error implements EventsListResponseState {}

class NoInternetError implements Error {}

class EmptyListError implements Error {}

class NonBlockingGenericError implements Error{}

class GenericError implements Error {}
