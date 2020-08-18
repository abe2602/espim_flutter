import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/model/user.dart';
import 'package:meta/meta.dart';

import 'use_case.dart';

class GetLoggedUserUC extends UseCase<void, User> {
  GetLoggedUserUC({
    @required this.userRepository,
  }) : assert(userRepository != null);

  final UserDataRepository userRepository;

  @override
  Future<User> getRawFuture({void params}) =>
      userRepository.getLoggedUser();
}