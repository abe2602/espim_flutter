class LoginResponseState {}

class Success extends LoginResponseState {}

class Error extends LoginResponseState {}

class LoginError extends Error {}

class NoConnectionError extends Error {}
