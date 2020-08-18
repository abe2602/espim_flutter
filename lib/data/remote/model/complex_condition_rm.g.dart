// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex_condition_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplexConditionRM _$ComplexConditionRMFromJson(Map<String, dynamic> json) {
  return ComplexConditionRM(
    dependencyCondition: json['dependentConditions'] as int,
    complexAction: json['action'] as String,
  );
}

Map<String, dynamic> _$ComplexConditionRMToJson(ComplexConditionRM instance) =>
    <String, dynamic>{
      'dependentConditions': instance.dependencyCondition,
      'action': instance.complexAction,
    };
