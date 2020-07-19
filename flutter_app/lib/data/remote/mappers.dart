import 'package:flutter_app/data/remote/model/character_rm.dart';
import 'package:domain/model/character.dart';

extension CharacterRMToDM on CharacterRM {
  Character toDM() => Character(id: id, name: name, imgUrl: imgUrl);
}

extension CharacterListRMToDM on List<CharacterRM> {
  List<Character> toDM() => map(
        (character) => Character(
            id: character.id, name: character.name, imgUrl: character.imgUrl),
      ).toList();
}
