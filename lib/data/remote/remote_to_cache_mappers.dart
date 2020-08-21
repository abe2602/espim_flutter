import 'package:flutter_app/data/cache/model/complex_condition_cm.dart';
import 'package:flutter_app/data/cache/model/event_cm.dart';
import 'package:flutter_app/data/cache/model/event_trigger_cm.dart';
import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:flutter_app/data/cache/model/media_information_cm.dart';
import 'package:flutter_app/data/cache/model/observer_cm.dart';
import 'package:flutter_app/data/cache/model/participant_cm.dart';
import 'package:flutter_app/data/cache/model/program_cm.dart';
import 'package:flutter_app/data/remote/model/complex_condition_rm.dart';
import 'package:flutter_app/data/remote/model/event_rm.dart';
import 'package:flutter_app/data/remote/model/intervention_rm.dart';
import 'package:flutter_app/data/remote/model/media_information_rm.dart';
import 'package:flutter_app/data/remote/model/observer_rm.dart';
import 'package:flutter_app/data/remote/model/participant_rm.dart';

import 'model/event_trigger_rm.dart';
import 'model/program_rm.dart';

extension InterventionRMToCM on InterventionRM {
  InterventionCM toCM() => InterventionCM(
      type: type,
      statement: statement,
      orderPosition: orderPosition,
      isFirst: isFirst,
      next: next,
      isObligatory: isObligatory,
      questionType: questionType,
      questionAnswers: questionAnswers,
      questionConditions: questionConditions,
      mediaType: mediaType,
      taskParameters: taskParameters,
      complexConditions: complexConditions?.toCM(),
      mediaInformation: mediaInformation?.toCM(),
      scales: scales,
      startFromNotification: startFromNotification,
      appPackage: appPackage,
    );
}

extension ObserverRMtoCM on ObserverRM {
  ObserverCM toCM() => ObserverCM(
    id: id,
    name: name,
    email: email,
    role: role,
    observerContacts: observerContacts,
    phoneNumber: phoneNumber,
    profileImageUrl: profileImageUrl,
  );
}

extension ComplexConditionRMtoCM on ComplexConditionRM {
  ComplexConditionCM toCM() => ComplexConditionCM(
    dependencyCondition: dependencyCondition,
    complexAction: complexAction,
  );
}

extension MediaInformationRMtoCM on MediaInformationRM {
  MediaInformationCM toCM() => MediaInformationCM(
    id: id,
    mediaType: mediaType,
    mediaUrl: mediaUrl,
    shouldAutoPlay: shouldAutoPlay,
  );
}

extension ProgramRMtoCM on ProgramRM {
  ProgramCM toCM() => ProgramCM(
    title: title,
    description: description,
    startTime: startTime,
    endTime: endTime,
    updateTime: updateTime,
    isPublic: isPublic,
    hasPhase: hasPhase,
    eventList: eventList.toCM(),
    observer: observer.toCM(),
    participants: participants.toCM(),
  );
}

extension ParticipantRMtoCM on ParticipantRM {
  ParticipantCM toCM() => ParticipantCM(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    profileImageUrl: profileImageUrl,
  );
}

extension EventTriggerRMtoCM on EventTriggerRM {
  EventTriggerCM toCM() => EventTriggerCM(
    id: id,
    triggerType: triggerType,
    triggerCondition: triggerCondition,
    priority: priority,
    timeOut: timeOut,
  );
}

extension EventRMtoCM on EventRM {
  EventCM toCM() => EventCM(
    id: id,
    title: title,
    description: description,
    type: type,
    eventTriggerList: eventTriggerList.toCM(),
    interventionList: interventionList.toCM(),
  );
}

extension ParticipantListRMtoCM on List<ParticipantRM> {
  List<ParticipantCM> toCM() => map(
        (participant) => participant.toCM(),
  ).toList();
}

extension ObserverListRMtoCM on List<ObserverRM> {
  List<ObserverCM> toCM() => map(
        (observer) => observer.toCM(),
  ).toList();
}

extension MediaInformationListRMtoCM on List<MediaInformationRM> {
  List<MediaInformationCM> toCM() => map(
        (mediaInformation) => mediaInformation.toCM(),
  ).toList();
}

extension ComplexConditionListRMtoCM on List<ComplexConditionRM> {
  List<ComplexConditionCM> toCM() => map(
        (complexCondition) => complexCondition.toCM(),
  ).toList();
}

extension EventsListRMtoCM on List<EventRM> {
  List<EventCM> toCM() => map(
        (event) => event.toCM(),
  ).toList();
}

extension EventsListTriggerRMtoCM on List<EventTriggerRM> {
  List<EventTriggerCM> toCM() => map(
        (eventTrigger) => eventTrigger.toCM(),
  ).toList();
}

extension InterventionListRMtoCM on List<InterventionRM> {
  List<InterventionCM> toCM() => map(
        (intervention) => intervention.toCM(),
  ).toList();
}

extension ProgramListRMtoCM on List<ProgramRM> {
  List<ProgramCM> toCM() => map(
        (program) => program.toCM(),
  ).toList();
}
