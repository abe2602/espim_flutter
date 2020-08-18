import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'event_trigger_cm.g.dart';

@HiveType(typeId: 2)
class EventTriggerCM {
  const EventTriggerCM({
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

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String triggerType;

  @HiveField(2)
  final String triggerCondition;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final int timeOut;
}
