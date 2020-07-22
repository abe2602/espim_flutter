import 'package:domain/data_repository/auth_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/remote/data_source/auh_rds.dart';

class AuthRepository implements AuthDataRepository {
  const AuthRepository({
    @required this.authRDS,
  }) : assert(authRDS != null);

  final AuthRDS authRDS;

  @override
  Future<bool> checkIsUserLogged() => authRDS.checkIsUserLogged();
}
