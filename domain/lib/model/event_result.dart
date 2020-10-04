import 'package:domain/model/intervention_result.dart';
import 'package:meta/meta.dart';

// precisa do participantId e endTime no RM
class EventResult {
  const EventResult({
    @required this.startTime,
    @required this.eventId,
    @required this.interventionResultsList,
    @required this.interventionsIds,
    @required this.eventTrigger,
    this.endTime,
  })  : assert(startTime != null),
        assert(eventId != null),
        assert(interventionsIds != null),
        assert(eventTrigger != null),
        assert(interventionResultsList != null);

  final int eventTrigger;
  final int eventId;
  final int startTime;
  final int endTime;
  final List<int> interventionsIds;
  final List<InterventionResult> interventionResultsList;
}
