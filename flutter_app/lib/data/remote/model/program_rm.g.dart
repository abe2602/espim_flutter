// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramRM _$ProgramRMFromJson(Map<String, dynamic> json) {
  return ProgramRM(
    title: json['title'] as String,
    description: json['description'] as String,
    startTime: json['starts'] as String,
    endTime: json['ends'] as String,
    updateTime: json['updateDate'] as String,
    hasPhase: json['hasPhases'] as bool,
    isPublic: json['isPublic'] as bool,
    eventList: (json['events'] as List)
        ?.map((e) =>
            e == null ? null : EventRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    observer: (json['observers'] as List)
        ?.map((e) =>
            e == null ? null : ObserverRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    participants: (json['participants'] as List)
        ?.map((e) => e == null
            ? null
            : ParticipantRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProgramRMToJson(ProgramRM instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'starts': instance.startTime,
      'ends': instance.endTime,
      'updateDate': instance.updateTime,
      'hasPhases': instance.hasPhase,
      'isPublic': instance.isPublic,
      'participants': instance.participants,
      'observers': instance.observer,
      'events': instance.eventList,
    };
