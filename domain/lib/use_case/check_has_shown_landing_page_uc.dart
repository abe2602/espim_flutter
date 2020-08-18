import 'package:domain/data_repository/user_data_repository.dart';
import 'package:flutter/foundation.dart';

import 'use_case.dart';

class CheckHasShownLandingPageUC extends UseCase<void, bool> {
  CheckHasShownLandingPageUC({
    @required this.userRepository,
  }) : assert(userRepository != null);

  final UserDataRepository userRepository;

  @override
  Future<bool> getRawFuture({void params}) =>
      userRepository.checkHasShownLandingPage();
}
