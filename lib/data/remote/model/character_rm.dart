import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_rm.g.dart';

@JsonSerializable()
class CharacterRM {
  const CharacterRM(
      {@required this.id, @required this.name, @required this.imgUrl})
      : assert(id != null),
        assert(name != null),
        assert(imgUrl != null);

  factory CharacterRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$CharacterRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$CharacterRMToJson(this);

  @JsonKey(name: 'char_id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'img')
  final String imgUrl;
}
