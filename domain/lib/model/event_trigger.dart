import 'package:flutter/foundation.dart';

class EventTrigger {
  const EventTrigger({
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

  final int id;

  final String triggerType;

  final String triggerCondition;

  final String priority;

  final int timeOut;
}
