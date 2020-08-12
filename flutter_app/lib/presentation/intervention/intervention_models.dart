import 'package:domain/model/intervention.dart';

abstract class InterventionResponseState {}

class Loading implements InterventionResponseState {}

class Error implements InterventionResponseState {}

class Success implements InterventionResponseState {
  const Success({
    this.intervention,
    this.nextInterventionType,
    this.nextPage,
  });

  final int nextPage;
  final Intervention intervention;
  final String nextInterventionType;
}

class NoInternetError implements Error {}

class NonBlockingGenericError implements Error {}

class GenericError implements Error {}
