import 'package:domain/model/intervention.dart';

abstract class EmptyInterventionResponseState {}

class Success implements EmptyInterventionResponseState {
  const Success({this.intervention});

  final Intervention intervention;
}

class LogoutSuccess implements EmptyInterventionResponseState{}

class Loading implements EmptyInterventionResponseState {}

class Error implements EmptyInterventionResponseState {}

class NoInternetError implements Error {}

class EmptyListError implements Error {}

class NonBlockingGenericError implements Error{}

class GenericError implements Error {}