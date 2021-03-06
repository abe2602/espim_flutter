import 'package:flutter/foundation.dart';

import '../intervention_models.dart';

class TaskInterventionSuccess extends Success {
  TaskInterventionSuccess({
    @required this.appPackage,
    @required this.taskParameters,
    @required this.startFromNotification,
    intervention,
    nextInterventionType,
    nextPage,
  }) : super(
      intervention: intervention,
      nextInterventionType: nextInterventionType,
      nextPage: nextPage);

  final String appPackage;

  final Map<String, String> taskParameters;

  final bool startFromNotification;
}