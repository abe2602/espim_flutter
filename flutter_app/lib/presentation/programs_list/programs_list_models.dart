import 'package:domain/model/event.dart';
import 'package:domain/model/program.dart';
import 'package:domain/model/user.dart';

abstract class ProgramsListResponseState {}

class Success implements ProgramsListResponseState {
  const Success({this.programsList, this.user});

  final List<Program> programsList;
  final User user;
}

class LogoutSuccess implements ProgramsListResponseState{}

class Loading implements ProgramsListResponseState {}

class Error implements ProgramsListResponseState {}

class NoInternetError implements Error {}

class EmptyListError implements Error {}

class NonBlockingGenericError implements Error{}

class GenericError implements Error {}
