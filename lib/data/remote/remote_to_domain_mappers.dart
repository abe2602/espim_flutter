import 'package:domain/model/closed_question_intervention.dart';
import 'package:domain/model/complex_condition.dart';
import 'package:domain/model/empty_intervention.dart';
import 'package:domain/model/event.dart';
import 'package:domain/model/event_trigger.dart';
import 'package:domain/model/intervention.dart';
import 'package:domain/model/likert_intervention.dart';
import 'package:domain/model/custom_likert_intervention.dart';
import 'package:domain/model/semantic_diff_intervention.dart';
import 'package:domain/model/media_information.dart';
import 'package:domain/model/media_intervention.dart';
import 'package:domain/model/multiple_answer_intervention.dart';
import 'package:domain/model/observer.dart';
import 'package:domain/model/participant.dart';
import 'package:domain/model/program.dart';
import 'package:domain/model/question_intervention.dart';
import 'package:domain/model/task_intervention.dart';
import 'package:domain/model/user.dart';
import 'package:flutter_app/data/remote/model/complex_condition_rm.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';
import 'package:flutter_app/data/remote/model/event_trigger_rm.dart';
import 'package:flutter_app/data/remote/model/intervention_rm.dart';
import 'package:flutter_app/data/remote/model/media_information_rm.dart';
import 'package:flutter_app/data/remote/model/participant_rm.dart';
import 'package:flutter_app/data/remote/model/program_rm.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';

import 'model/observer_rm.dart';
import 'model/user_rm.dart';

extension EventRMToDM on EventRM {
  Event toDM() => Event(
        id: id,
        title: title,
        description: description,
        type: type,
        eventTriggerList: eventTriggerList.toDM(),
        interventionList: interventionList.toDM(),
        color: color == 'none' ? SenSemColors.primaryColor : color.toColor(),
      );
}

extension EventTriggerRMToDM on EventTriggerRM {
  EventTrigger toDM() => EventTrigger(
        id: id,
        triggerType: triggerType,
        triggerCondition: triggerCondition,
        priority: priority,
        timeOut: timeOut,
      );
}

extension InterventionRMToDM on InterventionRM {
  Intervention toDM() {
    switch (type) {
      case 'media':
        {
          return MediaIntervention(
            mediaType: mediaType,
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
            appPackage: appPackage,
            startFromNotification: startFromNotification,
            taskParameters: taskParameters,
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
      default:
        {
          if (questionType == 4) {
            return SemanticDiffIntervention(
              scales: scales,
              interventionId: interventionId,
              type: 'semantic_diff',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
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
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          } else if (questionType == 31){
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
          }else if (questionType == 2) {
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
              isObligatory: isObligatory,
              complexConditions: complexConditions?.toDM(),
              mediaInformation: mediaInformation?.toDM(),
            );
          } else if (questionType == 1) {
            return ClosedQuestionIntervention(
              questionType: questionType,
              questionAnswers: questionAnswers,
              questionConditions: questionConditions,
              interventionId: interventionId,
              type: 'closed_question',
              statement: statement,
              orderPosition: orderPosition,
              isFirst: isFirst,
              next: next,
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
              type: 'open_question',
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

extension ComplexConditionRMtoDM on ComplexConditionRM {
  ComplexCondition toDM() => ComplexCondition(
        dependencyCondition: dependencyCondition,
        complexAction: complexAction,
      );
}

extension MediaInformationRMtoDM on MediaInformationRM {
  MediaInformation toDM() => MediaInformation(
        id: id,
        mediaType: mediaType,
        mediaUrl: mediaUrl,
        shouldAutoPlay: shouldAutoPlay,
      );
}

extension ProgramRMToDM on ProgramRM {
  Program toDM() => Program(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        updateTime: updateTime,
        isPublic: isPublic,
        hasPhase: hasPhase,
        eventList: eventList.toDM(),
        observer: observer.toDM(),
        participants: participants.toDM(),
      );
}

extension UserRMToDM on UserRM {
  User toDM() => User(id: id, name: name);
}

extension ObserverRMToDM on ObserverRM {
  Observer toDM() => Observer(
        id: id,
        name: name,
        email: email,
        role: role,
        observerContacts: observerContacts,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
}

extension ParticipantRMToDM on ParticipantRM {
  Participant toDM() => Participant(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
}

extension ParticipantListRMtoDM on List<ParticipantRM> {
  List<Participant> toDM() => map(
        (participant) => participant.toDM(),
      ).toList();
}

extension ObserverListRMtoDM on List<ObserverRM> {
  List<Observer> toDM() => map(
        (observer) => observer.toDM(),
      ).toList();
}

extension MediaInformationListRMtoDM on List<MediaInformationRM> {
  List<MediaInformation> toDM() => map(
        (mediaInformation) => mediaInformation.toDM(),
      ).toList();
}

extension ComplexConditionListRMtoDM on List<ComplexConditionRM> {
  List<ComplexCondition> toDM() => map(
        (complexCondition) => complexCondition.toDM(),
      ).toList();
}

extension EventsListRMToDM on List<EventRM> {
  List<Event> toDM() => map(
        (event) => event.toDM(),
      ).toList();
}

extension EventsListTriggerRMToDM on List<EventTriggerRM> {
  List<EventTrigger> toDM() => map(
        (eventTrigger) => eventTrigger.toDM(),
      ).toList();
}

extension InterventionListRMToDM on List<InterventionRM> {
  List<Intervention> toDM() => map(
        (intervention) => intervention.toDM(),
      ).toList();
}

extension ProgramListRMToDM on List<ProgramRM> {
  List<Program> toDM() => map(
        (program) => program.toDM(),
      ).toList();
}
