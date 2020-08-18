// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantRM _$ParticipantRMFromJson(Map<String, dynamic> json) {
  return ParticipantRM(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    nickName: json['alias'] as String,
    phoneNumber: json['phoneNumber'] as String,
    profileImageUrl: json['profilePhotoUrl'] as String,
  );
}

Map<String, dynamic> _$ParticipantRMToJson(ParticipantRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profilePhotoUrl': instance.profileImageUrl,
      'alias': instance.nickName,
    };
