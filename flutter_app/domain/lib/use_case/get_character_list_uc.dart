import 'package:meta/meta.dart';

import '../data_repository/character_data_repository.dart';
import '../model/character.dart';
import 'use_case.dart';

class GetCharacterListUC extends UseCase<void, List<Character>> {
  GetCharacterListUC({
    @required this.characterRepository,
  }) : assert(characterRepository != null);

  final CharacterDataRepository characterRepository;

  @override
  Future<List<Character>> getRawFuture({void params}) =>
      characterRepository.getCharacterList();
}