import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/model/event_trigger_cm.dart';
import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:hive/hive.dart';

part 'event_cm.g.dart';

@HiveType(typeId: 1)
class EventCM {
  const EventCM({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.eventTriggerList,
    @required this.interventionList,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(type != null),
        assert(eventTriggerList != null),
        assert(interventionList != null);

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final List<EventTriggerCM> eventTriggerList;

  @HiveField(5)
  final List<InterventionCM> interventionList;
}
