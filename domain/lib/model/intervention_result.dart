import 'package:flutter/widgets.dart';

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

  final String interventionType;
  final int startTime;
  final int endTime;
  final String answer;
  final int interventionId;
}
