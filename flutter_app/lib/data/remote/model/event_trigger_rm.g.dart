// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_trigger_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventTriggerRM _$EventTriggerRMFromJson(Map<String, dynamic> json) {
  return EventTriggerRM(
    id: json['id'] as int,
    triggerType: json['triggerType'] as String,
    triggerCondition: json['triggerCondition'] as String,
    priority: json['priority'] as String,
    timeOut: json['timeOut'] as int,
  );
}

Map<String, dynamic> _$EventTriggerRMToJson(EventTriggerRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'triggerType': instance.triggerType,
      'triggerCondition': instance.triggerCondition,
      'priority': instance.priority,
      'timeOut': instance.timeOut,
    };
