import 'package:domain/data_repository/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class MarkLandingPageAsSeenUC extends UseCase<void, void> {
  MarkLandingPageAsSeenUC({
    @required this.userRepository,
  }) : assert(userRepository != null);

  final UserDataRepository userRepository;

  @override
  Future<void> getRawFuture({void params}) =>
      userRepository.markLandingPageAsSeen();
}
