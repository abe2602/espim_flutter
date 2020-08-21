class RouteNameBuilder {
  static const root = '/';
  static const login = 'login';
  static const settings = 'settings';
  static const accompaniment = 'accompaniment';
  static const taskIntervention = 'taskIntervention';
  static const emptyIntervention = 'emptyIntervention';
  static const questionIntervention = 'questionIntervention';
  static const mediaIntervention = 'mediaIntervention';
  static const taskInterventionModal = 'taskInterventionModal';
  static const emptyInterventionModal = 'emptyInterventionModal';
  static const questionInterventionModal = 'questionInterventionModal';
  static const mediaInterventionModal = 'mediaInterventionModal';

  static String interventionType(
      String interventionType, int eventId, int orderPosition, int flowSize) {
    switch (interventionType) {
      case 'task':
        return '$taskIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'media':
        return '$mediaIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'question':
        return '$questionIntervention/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
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
      case 'media':
        return '$mediaInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
        break;
      case 'question':
        return '$questionInterventionModal/$eventId?orderPosition=$orderPosition&flowSize=$flowSize';
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