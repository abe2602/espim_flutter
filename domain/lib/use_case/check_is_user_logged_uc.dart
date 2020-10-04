import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class CheckIsUserLoggedUC extends UseCase<void, bool> {
  CheckIsUserLoggedUC({
    @required this.authRepository,
  }) : assert(authRepository != null);

  final AuthDataRepository authRepository;

  @override
  Future<bool> getRawFuture({void params}) =>
      authRepository.checkIsUserLogged();
}
