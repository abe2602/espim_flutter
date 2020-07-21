import 'package:domain/model/character.dart';
import 'package:domain/model/user.dart';

abstract class CharacterListResponseState {}

class Success implements CharacterListResponseState {
  const Success({this.characterList, this.user});

  final List<Character> characterList;
  final User user;
}

class Loading implements CharacterListResponseState {}

class Error implements CharacterListResponseState {}

class NoInternetError implements Error {}

class GenericError implements Error {}