import 'package:domain/model/settings.dart';

abstract class SettingsResponseState {}

class Loading implements SettingsResponseState {}

class Error implements SettingsResponseState {}

class Success implements SettingsResponseState {
  const Success({
    this.settings,
  });

  final Settings settings;
}

class NonBlockingGenericError implements Error {}

class GenericError implements Error {}