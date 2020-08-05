class RouteNameBuilder {
  static const root = '/';
  static const login = 'login';
  static const settings = 'settings';
  static const accompaniment = 'accompaniment';
  static const taskIntervention = 'taskIntervention';
  static const emptyIntervention = 'emptyIntervention';
  static const questionIntervention = 'questionIntervention';
  static const mediaIntervention = 'mediaIntervention';

  static String interventionType(
      String interventionType, int eventId, int pageNumber) {
    switch (interventionType) {
      case 'task':
        return '$taskIntervention/$eventId?pageNumber=$pageNumber';
        break;
      case 'media':
        return '$mediaIntervention/$eventId?pageNumber=$pageNumber';
        break;
      case 'question':
        return '$questionIntervention/$eventId?pageNumber=$pageNumber';
        break;
      default:
        return '$emptyIntervention/$eventId?pageNumber=$pageNumber';
        break;
    }
  }

  static String settingsPage() => '$settings';
  static String loginPage() => '$login';
  static String accompanimentPage() => '$accompaniment';
}
