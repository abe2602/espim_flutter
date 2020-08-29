import 'package:flutter/widgets.dart';
import 'package:flutter_app/data/remote/model/event_trigger_rm.dart';
import 'package:flutter_app/data/remote/model/intervention_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_rm.g.dart';

@JsonSerializable()
class EventRM {
  const EventRM({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.eventTriggerList,
//    @required this.sensorsList,
//    @required this.complexConditionList,
    @required this.color,
    @required this.interventionList,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(type != null),
        assert(eventTriggerList != null),
//        assert(sensorsList != null),
//        assert(complexConditionList != null),
        assert(interventionList != null),
        assert(color != null);

  factory EventRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$EventRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$EventRMToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'triggers')
  final List<EventTriggerRM> eventTriggerList;

  @JsonKey(name: 'color')
  final String color;
//  @JsonKey(name: 'sensors')
//  final List<SensorRM> sensorsList;
//  @JsonKey(name: 'complexConditions')
//  final List<ComplexConditionRM> complexConditionList;
  @JsonKey(name: 'interventions')
  final List<InterventionRM> interventionList;
}
