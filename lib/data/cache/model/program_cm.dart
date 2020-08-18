import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/model/event_cm.dart';
import 'package:flutter_app/data/cache/model/observer_cm.dart';
import 'package:flutter_app/data/cache/model/participant_cm.dart';
import 'package:hive/hive.dart';

part 'program_cm.g.dart';

@HiveType(typeId: 7)
class ProgramCM {
  const ProgramCM({
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

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String startTime;

  @HiveField(3)
  final String endTime;

  @HiveField(4)
  final String updateTime;

  @HiveField(5)
  final bool hasPhase;

  @HiveField(6)
  final bool isPublic;

  @HiveField(7)
  final List<ParticipantCM> participants;

  @HiveField(8)
  final List<ObserverCM> observer;

  @HiveField(9)
  final List<EventCM> eventList;
}
