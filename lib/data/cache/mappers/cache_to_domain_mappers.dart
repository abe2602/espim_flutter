import 'package:domain/model/complex_condition.dart';
import 'package:domain/model/custom_likert_intervention.dart';
import 'package:domain/model/empty_intervention.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/likert_intervention.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/model/media_intervention.dart';
import 'package:domain/model/multiple_answer_intervention.dart';
import 'package:domain/model/question_intervention.dart';
import 'package:domain/model/semantic_diff_intervention.dart';
import 'package:domain/model/settings.dart';
import 'package:domain/model/task_intervention.dart';
import 'package:flutter_app/data/cache/model/complex_condition_cm.dart';
import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:flutter_app/data/cache/model/media_information_cm.dart';
import 'package:flutter_app/data/cache/model/settings_cm.dart';

extension SettingsCMtoDM on SettingsCM {
  Settings toDM() => Settings(
        isLandscape: isLandscape,
        isMobileNetworkEnabled: isMobileNetworkEnabled,
        isNotificationOnMediaEnabled: isMobileNetworkEnabled,
      );
}

extension InterventionCMToDM on InterventionCM {
  Intervention toDM() {
    switch (type) {
      case 'media':
        {
          return MediaIntervention(
            interventionId: interventionId,
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
      case 'empty':
        {
          return EmptyIntervention(
            interventionId: interventionId,
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
            interventionId: interventionId,
            appPackage: appPackage,
            startFromNotification: startFromNotification,
            taskParameters: taskParameters,
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
          if (questionType == 4) {
            return SemanticDiffIntervention(
              interventionId: interventionId,
              type: 'semantic_diff',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
              scales: scales,
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          }
          if (questionType == 3) {
            return LikertIntervention(
              questionType: questionType,
              questionAnswers: questionAnswers,
              questionConditions: questionConditions,
              interventionId: interventionId,
              type: 'likert',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
              scales: scales,
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          }
          if (questionType == 31) {
            return CustomLikertIntervention(
              interventionId: interventionId,
              type: 'custom_likert',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
              scales: scales,
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          } else if (questionType == 2) {
            return MultipleAnswerIntervention(
              questionType: questionType,
              questionAnswers: questionAnswers,
              questionConditions: questionConditions,
              interventionId: interventionId,
              type: 'multiple_answer',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
              scales: scales,
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          } else {
            return QuestionIntervention(
              questionType: questionType,
              questionAnswers: questionAnswers,
              questionConditions: questionConditions,
              interventionId: interventionId,
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

extension MediaInformationCMtoDM on MediaInformationCM {
  MediaInformation toDM() => MediaInformation(
        id: id,
        mediaType: mediaType,
        mediaUrl: mediaUrl,
        shouldAutoPlay: shouldAutoPlay,
      );
}
