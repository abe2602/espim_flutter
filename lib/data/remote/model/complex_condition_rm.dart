import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complex_condition_rm.g.dart';

@JsonSerializable()
class ComplexConditionRM {
  ComplexConditionRM({
    @required this.dependencyCondition,
    @required this.complexAction,
  })  : assert(dependencyCondition != null),
        assert(complexAction != null);

  factory ComplexConditionRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$ComplexConditionRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$ComplexConditionRMToJson(this);

  @JsonKey(name: 'dependentConditions')
  final int dependencyCondition;

  @JsonKey(name: 'action')
  final String complexAction;
}
