// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_information_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInformationRM _$MediaInformationRMFromJson(Map<String, dynamic> json) {
  return MediaInformationRM(
    id: json['id'] as int,
    mediaType: json['type'] as String,
    mediaUrl: json['mediaUrl'] as String,
    shouldAutoPlay: json['autoPlay'] as bool,
  );
}

Map<String, dynamic> _$MediaInformationRMToJson(MediaInformationRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'autoPlay': instance.shouldAutoPlay,
    };
