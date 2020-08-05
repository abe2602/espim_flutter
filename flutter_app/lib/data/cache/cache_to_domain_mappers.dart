import 'package:domain/model/complex_condition.dart';
import 'package:domain/model/empty_intervention.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/model/media_intervention.dart';
import 'package:domain/model/question_intervention.dart';
import 'package:domain/model/task_intervention.dart';
import 'package:domain/model/task_parameter.dart';

import 'model/complex_condition_cm.dart';
import 'model/intervention_cm.dart';
import 'model/media_information_cm.dart';
import 'model/task_parameter_cm.dart';

extension InterventionCMToDM on InterventionCM {
  Intervention toDM() {
    switch (type) {
      case 'media':
        {
          return MediaIntervention(
            mediaType: mediaType,
            type: type,
            statement: statement,
            orderPosition: orderPosition,
            isFirst: isFirst,
            next: next,
            isObligatory: isObligatory,
            complexConditions: complexConditions?.toDM(),
            mediaInformation: mediaInformation?.toDM(),
          );
        }
        break;
      case 'question':
        {
          return QuestionIntervention(
            questionType: questionType,
            questionAnswers: questionAnswers,
            questionConditions: questionConditions,
            type: type,
            statement: statement,
            orderPosition: orderPosition,
            isFirst: isFirst,
            next: next,
            isObligatory: isObligatory,
            complexConditions: complexConditions?.toDM(),
            mediaInformation: mediaInformation?.toDM(),
          );
        }
        break;
      case 'task':
        {
          return TaskIntervention(
            appPackage: appPackage,
            startFromNotification: startFromNotification,
            taskParameters: taskParameters.toDM(),
            type: type,
            statement: statement,
            orderPosition: orderPosition,
            isFirst: isFirst,
            next: next,
            isObligatory: isObligatory,
            complexConditions: complexConditions?.toDM(),
            mediaInformation: mediaInformation?.toDM(),
          );
        }
        break;
      default:
        {
          return EmptyIntervention(
            type: type,
            statement: statement,
            orderPosition: orderPosition,
            isFirst: isFirst,
            next: next,
            isObligatory: isObligatory,
            complexConditions: complexConditions?.toDM(),
            mediaInformation: mediaInformation?.toDM(),
          );
        }
        break;
    }
  }
}

extension MediaInformationListCMtoDM on List<MediaInformationCM> {
  List<MediaInformation> toDM() => map(
        (mediaInformation) => mediaInformation.toDM(),
  ).toList();
}

extension ComplexConditionListCMtoDM on List<ComplexConditionCM> {
  List<ComplexCondition> toDM() => map(
        (complexCondition) => complexCondition.toDM(),
  ).toList();
}

extension ComplexConditionCMtoDM on ComplexConditionCM {
  ComplexCondition toDM() => ComplexCondition(
    dependencyCondition: dependencyCondition,
    complexAction: complexAction,
  );
}

extension TaskParameterCMtoDM on TaskParameterCM {
  TaskParameter toDM() => TaskParameter(
    videoUrl: videoUrl,
  );
}

extension MediaInformationCMtoDM on MediaInformationCM {
  MediaInformation toDM() => MediaInformation(
    id: id,
    mediaType: mediaType,
    mediaUrl: mediaUrl,
    shouldAutoPlay: shouldAutoPlay,
  );
}