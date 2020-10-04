import 'package:domain/model/event_trigger.dart';
import 'package:domain/model/intervention.dart';
import 'package:meta/meta.dart';

class Event {
  const Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.eventTriggerList,
//    @required this.sensorsList,
//    @required this.complexConditionList,
    @required this.interventionList,
    @required this.color,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(type != null),
        assert(eventTriggerList != null),
//        assert(sensorsList != null),
//        assert(complexConditionList != null),
        assert(interventionList != null),
        assert(color != null);

  final int id;

  final String title;

  final String description;

  final String type;

  final String color;

  final List<EventTrigger> eventTriggerList;

//  final List<SensorRM> sensorsList;
//  final List<ComplexConditionRM> complexConditionList;
  final List<Intervention> interventionList;
}
