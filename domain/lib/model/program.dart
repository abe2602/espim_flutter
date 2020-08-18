import 'package:domain/model/event.dart';
import 'package:domain/model/observer.dart';
import 'package:domain/model/participant.dart';
import 'package:flutter/foundation.dart';

class Program {
  const Program({
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

  final String title;

  final String description;

  final String startTime;

  final String endTime;

  final String updateTime;

  final bool hasPhase;

  final bool isPublic;

  final List<Participant> participants;

  final List<Observer> observer;

  final List<Event> eventList;
}
