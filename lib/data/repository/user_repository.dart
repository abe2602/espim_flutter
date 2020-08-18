import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/model/settings.dart';
import 'package:domain/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/cache/user_cds.dart';
import 'package:flutter_app/data/cache/domain_to_cache_mappers.dart';
import 'package:flutter_app/data/cache/cache_to_domain_mappers.dart';
import 'package:flutter_app/data/remote/data_source/user_rds.dart';
import 'package:flutter_app/data/remote/remote_to_domain_mappers.dart';

class UserRepository implements UserDataRepository {
  const UserRepository({
    @required this.userCDS,
    @required this.userRDS,
  })  : assert(userCDS != null),
        assert(userRDS != null);

  final UserCDS userCDS;
  final UserRDS userRDS;

  @override
  Future<bool> checkHasShownLandingPage() => userCDS.checkHasShownLandingPage();

  @override
  Future<void> markLandingPageAsSeen() => userCDS.markLandingPageAsSeen();

  @override
  Future<User> getLoggedUser() => userRDS.getLoggedUser().then(
        (user) => user.toDM(),
      );

  @override
  Future<Settings> getSettings() => userCDS.getUserSettings().then(
        (settings) => settings.toDM(),
      );

  @override
  Future<void> changeSettings(Settings settings) => userCDS.upsertSettings(
        settings.toCM(),
      ).catchError((error) {
        print(error);
        throw error;
  });
}
