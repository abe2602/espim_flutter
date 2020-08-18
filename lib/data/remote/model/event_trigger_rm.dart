import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_trigger_rm.g.dart';

@JsonSerializable()
class EventTriggerRM {
  const EventTriggerRM({
    @required this.id,
    @required this.triggerType,
    @required this.triggerCondition,
    @required this.priority,
    @required this.timeOut,
  })  : assert(id != null),
        assert(triggerType != null),
        assert(triggerCondition != null),
        assert(priority != null),
        assert(timeOut != null);

  factory EventTriggerRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$EventTriggerRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$EventTriggerRMToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'triggerType')
  final String triggerType;
  @JsonKey(name: 'triggerCondition')
  final String triggerCondition;
  @JsonKey(name: 'priority')
  final String priority;
  @JsonKey(name: 'timeOut')
  final int timeOut;
}