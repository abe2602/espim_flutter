import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';

class AuthRepository implements AuthDataRepository {
  const AuthRepository({
    @required this.authRDS,
    @required this.userCDS,
  }) : assert(authRDS != null);

  final AuthRDS authRDS;
  final UserCDS userCDS;

  @override
  Future<bool> checkIsUserLogged() => userCDS.checkIsUserLogged();

  @override
  Future<void> login() => authRDS.login().then(
        (_) => userCDS.markUserAsLogged(),
      );

  @override
  Future<void> logout() => authRDS.logout().then(
        (_) => userCDS.markUserAsSignOut(),
  );
}
