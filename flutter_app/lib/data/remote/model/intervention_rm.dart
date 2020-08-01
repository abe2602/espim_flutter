import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_app/data/remote/model/complex_condition_rm.dart';
import 'package:flutter_app/data/remote/model/media_information_rm.dart';
import 'package:flutter_app/data/remote/model/task_parameter_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intervention_rm.g.dart';

@JsonSerializable()
class InterventionRM {
  InterventionRM(
      {@required this.type,
      @required this.statement,
      @required this.orderPosition,
      @required this.isFirst,
      @required this.next,
      @required this.isObligatory,
      this.complexConditions,
      this.questionType,
      this.questionAnswers,
      this.questionConditions,
      this.scales,
      this.appPackage,
      this.taskParameters,
      this.startFromNotification,
      this.mediaType,
      this.mediaInformation})
      : assert(type != null),
        assert(statement != null),
        assert(orderPosition != null),
        assert(isFirst != null),
        assert(next != null),
        assert(isObligatory != null);

  factory InterventionRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$InterventionRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$InterventionRMToJson(this);

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'statement')
  final String statement;

  @JsonKey(name: 'orderPosition')
  final int orderPosition;

  @JsonKey(name: 'first')
  final bool isFirst;

  @JsonKey(name: 'next')
  final int next;

  @JsonKey(name: 'obligatory')
  final bool isObligatory;

  @JsonKey(name: 'medias')
  final List<MediaInformationRM> mediaInformation;

  @JsonKey(name: 'complexConditions')
  final List<ComplexConditionRM> complexConditions;

  // question
  @JsonKey(name: 'questionType')
  final int questionType;
  @JsonKey(name: 'options')
  final List<String> questionAnswers;
  @JsonKey(name: 'conditions')
  final Map<String, int> questionConditions;
  @JsonKey(name: 'scales')
  final List<String> scales;

  // task
  @JsonKey(name: 'appPackage')
  final String appPackage;
  @JsonKey(name: 'parameters')
  final TaskParameterRM taskParameters;
  @JsonKey(name: 'startFromNotification')
  final bool startFromNotification;

  // empty

  // media
  @JsonKey(name: 'mediaType')
  final String mediaType;
}
