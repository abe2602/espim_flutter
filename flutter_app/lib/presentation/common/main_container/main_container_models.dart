abstract class MainScreenResponseState {}

class Success implements MainScreenResponseState {}

class Loading implements MainScreenResponseState {}

class Error implements MainScreenResponseState {}

class GenericError implements Error {}

class UserNotLoggedError implements Error {}

class TutorialNotShownError implements Error {}
