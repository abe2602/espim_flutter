import 'package:domain/model/intervention_type.dart';

class RouteNameBuilder {
  static const root = '/';
  static const login = 'login';
  static const settings = 'settings';
  static const accompaniment = 'accompaniment';
  static const taskIntervention = 'taskIntervention';
  static const emptyIntervention = 'emptyIntervention';
  static const openQuestionIntervention = 'openQuestionIntervention';
  static const closedQuestionIntervention = 'closedQuestionIntervention';
  static const likertIntervention = 'likertIntervention';
  static const customLikertIntervention = 'customLikertIntervention';
  static const semanticDiffIntervention = 'semanticDiffIntervention';
  static const multiQuestionIntervention = 'multipleAnswerIntervention';
  static const recordVideoIntervention = 'recordVideoIntervention';
  static const recordAudioIntervention = 'recordAudioIntervention';
  static const takePictureIntervention = 'takePictureIntervention';

  static const taskInterventionModal = 'taskInterventionModal';
  static const emptyInterventionModal = 'emptyInterventionModal';
  static const openQuestionInterventionModal = 'openQuestionInterventionModal';
  static const closedQuestionInterventionModal =
      'closedQuestionInterventionModal';
  static const likertInterventionModal = 'likertInterventionModal';
  static const customLikertInterventionModal = 'customLikertInterventionModal';
  static const semanticDiffInterventionModal = 'semanticDiffInterventionModal';
  static const multiQuestionInterventionModal =
      'multipleAnswerInterventionModal';
  static const recordVideoInterventionModal = 'recordVideoInterventionModal';
  static const recordAudioInterventionModal = 'recordAudioInterventionModal';
  static const takePictureInterventionModal = 'takePictureInterventionModal';

  static String interventionType(InterventionType interventionType, int eventId,
      int orderPosition, int flowSize) {
    switch (interventionType) {
      case InterventionType.task:
        return '$taskIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.recordVideo:
        return '$recordVideoIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.recordAudio:
        return '$recordAudioIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.takePicture:
        return '$takePictureIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.openQuestion:
        return '$openQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.closedQuestion:
        return '$closedQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.likert:
        return '$likertIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.customLikert:
        return '$customLikertIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.semanticDiff:
        return '$semanticDiffIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.multipleAnswer:
        return '$multiQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      default:
        return '$emptyIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
    }
  }

  static String modalInterventionType(InterventionType interventionType,
      int eventId, int orderPosition, int flowSize) {
    switch (interventionType) {
      case InterventionType.task:
        return '$taskInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.recordVideo:
        return '$recordVideoInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.recordAudio:
        return '$recordAudioInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.takePicture:
        return '$takePictureInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.openQuestion:
        return '$openQuestionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.closedQuestion:
        return '$closedQuestionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.likert:
        return '$likertInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.customLikert:
        return '$customLikertInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.semanticDiff:
        return '$semanticDiffInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case InterventionType.multipleAnswer:
        return '$multiQuestionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      default:
        return '$emptyInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
    }
  }

  static String settingsPage() => '$settings';

  static String loginPage() => '$login';

  static String accompanimentPage() => '$accompaniment';
}
