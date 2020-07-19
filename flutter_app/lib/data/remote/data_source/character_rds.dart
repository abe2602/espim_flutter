import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/remote/model/character_rm.dart';

class CharacterRDS {
  const CharacterRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<List<CharacterRM>> getCharacterList() =>
      dio.get('characters?limit=10&offset=10').then(
            (response) =>
            List<CharacterRM>.from(
              response.data.map(
                    (character) => CharacterRM.fromJson(character),
              ),
            ).toList(),
      );
}