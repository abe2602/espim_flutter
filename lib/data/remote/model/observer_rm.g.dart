// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observer_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObserverRM _$ObserverRMFromJson(Map<String, dynamic> json) {
  return ObserverRM(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    observerContacts:
        (json['contacts'] as List)?.map((e) => e as int)?.toList(),
    phoneNumber: json['phoneNumber'] as String,
    profileImageUrl: json['profilePhotoUrl'] as String,
  );
}

Map<String, dynamic> _$ObserverRMToJson(ObserverRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profilePhotoUrl': instance.profileImageUrl,
      'role': instance.role,
      'contacts': instance.observerContacts,
    };
