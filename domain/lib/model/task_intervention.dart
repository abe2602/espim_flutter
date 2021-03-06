import 'package:meta/meta.dart';

import 'intervention.dart';

class TaskIntervention extends Intervention {
  TaskIntervention(
      {@required this.appPackage,
      @required this.taskParameters,
      @required this.startFromNotification,
      interventionId,
      type,
      statement,
      orderPosition,
      isFirst,
      next,
      isObligatory,
      complexConditions,
      mediaInformation})
      : assert(appPackage != null),
        assert(taskParameters != null),
        assert(startFromNotification != null),
        super(
          interventionId: interventionId,
          type: type,
          statement: statement,
          orderPosition: orderPosition,
          isFirst: isFirst,
          next: next,
          isObligatory: isObligatory,
          complexConditions: complexConditions,
          mediaInformation: mediaInformation,
        );

  final String appPackage;

  final Map<String, String> taskParameters;

  final bool startFromNotification;
}
