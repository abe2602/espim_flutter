import 'package:domain/model/character.dart';

abstract class CharacterDataRepository {
  Future<List<Character>> getCharacterList();
}