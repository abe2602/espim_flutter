// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterventionRM _$InterventionRMFromJson(Map<String, dynamic> json) {
  return InterventionRM(
    type: json['type'] as String,
    statement: json['statement'] as String,
    orderPosition: json['orderPosition'] as int,
    isFirst: json['first'] as bool,
    next: json['next'] as int,
    isObligatory: json['obligatory'] as bool,
    complexConditions: (json['complexConditions'] as List)
        ?.map((e) => e == null
            ? null
            : ComplexConditionRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    questionType: json['questionType'] as int,
    questionAnswers:
        (json['options'] as List)?.map((e) => e as String)?.toList(),
    questionConditions: (json['conditions'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    scales: (json['scales'] as List)?.map((e) => e as String)?.toList(),
    appPackage: json['appPackage'] as String,
    taskParameters: (json['parameters'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    startFromNotification: json['startFromNotification'] as bool,
    mediaType: json['mediaType'] as String,
    mediaInformation: (json['medias'] as List)
        ?.map((e) => e == null
            ? null
            : MediaInformationRM.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$InterventionRMToJson(InterventionRM instance) =>
    <String, dynamic>{
      'type': instance.type,
      'statement': instance.statement,
      'orderPosition': instance.orderPosition,
      'first': instance.isFirst,
      'next': instance.next,
      'obligatory': instance.isObligatory,
      'medias': instance.mediaInformation,
      'complexConditions': instance.complexConditions,
      'questionType': instance.questionType,
      'options': instance.questionAnswers,
      'conditions': instance.questionConditions,
      'scales': instance.scales,
      'appPackage': instance.appPackage,
      'parameters': instance.taskParameters,
      'startFromNotification': instance.startFromNotification,
      'mediaType': instance.mediaType,
    };
