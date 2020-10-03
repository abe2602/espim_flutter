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

  static String interventionType(
      String interventionType, int eventId, int orderPosition, int flowSize) {
    switch (interventionType) {
      case 'task':
        return '$taskIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'record_video':
        return '$recordAudioIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'record_audio':
        return '$recordAudioIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'take_picture':
        return '$takePictureIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'open_question':
        return '$openQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'closed_question':
        return '$closedQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'likert':
        return '$likertIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'custom_likert':
        return '$customLikertIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'semantic_diff':
        return '$semanticDiffIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'multiple_answer':
        return '$multiQuestionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      default:
        return '$emptyIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
    }
  }

  static String modalInterventionType(
      String interventionType, int eventId, int orderPosition, int flowSize) {
    switch (interventionType) {
      case 'task':
        return '$taskInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'record_video':
        return '$recordAudioInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'record_audio':
        return '$recordAudioInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'take_picture':
        return '$takePictureInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'open_question':
        return '$openQuestionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'closed_question':
        return '$closedQuestionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'likert':
        return '$likertInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'custom_likert':
        return '$customLikertInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'semantic_diff':
        return '$semanticDiffInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'multiple_answer':
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
