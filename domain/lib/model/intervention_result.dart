import 'package:domain/model/intervention_type.dart';
import 'package:meta/meta.dart';

class InterventionResult {
  const InterventionResult({
    @required this.interventionType,
    @required this.startTime,
    @required this.endTime,
    @required this.interventionId,
    this.answer,
  })  : assert(interventionType != null),
        assert(startTime != null),
        assert(endTime != null),
        assert(interventionId != null);

  final InterventionType interventionType;
  final int startTime;
  final int endTime;
  final String answer;
  final int interventionId;
}
