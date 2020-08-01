import 'package:flutter/widgets.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';
import 'package:flutter_app/data/remote/model/observer_rm.dart';
import 'package:flutter_app/data/remote/model/participant_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'program_rm.g.dart';

@JsonSerializable()
class ProgramRM {
  const ProgramRM({
    @required this.title,
    @required this.description,
    @required this.startTime,
    @required this.endTime,
    @required this.updateTime,
    @required this.hasPhase,
    @required this.isPublic,
    @required this.eventList,
    @required this.observer,
    @required this.participants,
  })  : assert(title != null),
        assert(description != null),
        assert(startTime != null),
        assert(endTime != null),
        assert(updateTime != null),
        assert(hasPhase != null),
        assert(isPublic != null);

  factory ProgramRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$ProgramRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$ProgramRMToJson(this);

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'starts')
  final String startTime;

  @JsonKey(name: 'ends')
  final String endTime;

  @JsonKey(name: 'updateDate')
  final String updateTime;

  @JsonKey(name: 'hasPhases')
  final bool hasPhase;

  @JsonKey(name: 'isPublic')
  final bool isPublic;

  @JsonKey(name: 'participants')
  final List<ParticipantRM> participants;

  @JsonKey(name: 'observers')
  final List<ObserverRM> observer;

  @JsonKey(name: 'events')
  final List<EventRM> eventList;
}
