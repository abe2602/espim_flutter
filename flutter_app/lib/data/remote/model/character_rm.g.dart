// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterRM _$CharacterRMFromJson(Map<String, dynamic> json) {
  return CharacterRM(
    id: json['char_id'] as int,
    name: json['name'] as String,
    imgUrl: json['img'] as String,
  );
}

Map<String, dynamic> _$CharacterRMToJson(CharacterRM instance) =>
    <String, dynamic>{
      'char_id': instance.id,
      'name': instance.name,
      'img': instance.imgUrl,
    };
