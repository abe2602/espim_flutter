import 'package:domain/data_repository/user_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/user_cds.dart';

class UserRepository implements UserDataRepository {
  const UserRepository({
    @required this.userCDS,
  }) : assert(userCDS != null);

  final UserCDS userCDS;

  @override
  Future<bool> checkHasShownTutorial() => userCDS.checkHasShowTutorial();
}