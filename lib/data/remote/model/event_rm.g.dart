// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRM _$EventRMFromJson(Map<String, dynamic> json) {
  return EventRM(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    eventTriggerList: (json['triggers'] as List)
        ?.map((e) => e == null
            ? null
            : EventTriggerRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    interventionList: (json['interventions'] as List)
        ?.map((e) => e == null
            ? null
            : InterventionRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EventRMToJson(EventRM instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'triggers': instance.eventTriggerList,
      'interventions': instance.interventionList,
    };
