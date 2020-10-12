abstract class SensemException implements Exception {}

class NoMoreInterventionsException implements SensemException {}

class NoConnectionException implements SensemException {}

class GenericException implements SensemException {}

class TutorialNotShownException implements SensemException {}

class UserNotLoggedException implements SensemException {}

class UserLoginException implements SensemException {}

class UnexpectedException implements SensemException {}

abstract class FormFieldException implements SensemException {}

class EmptyFormFieldException implements FormFieldException {}

class InvalidFormFieldException implements FormFieldException {}
