import 'package:domain/data_repository/character_data_repository.dart';
import 'package:domain/model/character.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/remote/data_source/character_rds.dart';
import 'package:flutter_app/data/remote/mappers.dart';

class CharacterRepository implements CharacterDataRepository {
  const CharacterRepository({
    @required this.characterRDS,
  }) : assert(characterRDS != null);

  final CharacterRDS characterRDS;

  @override
  Future<List<Character>> getCharacterList() =>
      characterRDS.getCharacterList().then(
            (characterList) => characterList.toDM(),
          );
}
