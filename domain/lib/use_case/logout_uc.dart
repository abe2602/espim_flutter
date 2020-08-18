import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:flutter/foundation.dart';

import 'use_case.dart';

class LogoutUC extends UseCase<void, void> {
  LogoutUC({
    @required this.authRepository,
  }) : assert(authRepository != null);

  final AuthDataRepository authRepository;

  @override
  Future<void> getRawFuture({void params}) =>
      authRepository.logout();
}