import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/model/settings.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:flutter/foundation.dart';

class ChangeSettingsUC extends UseCase<ChangeSettingsUCParams, void> {
  ChangeSettingsUC({
    @required this.userRepository,
  }) : assert(userRepository != null);

  final UserDataRepository userRepository;

  @override
  Future<void> getRawFuture({ChangeSettingsUCParams params}) =>
      userRepository.changeSettings(params.settings);
}

class ChangeSettingsUCParams {
  const ChangeSettingsUCParams(this.settings);

  final Settings settings;
}