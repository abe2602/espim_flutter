import 'package:hive/hive.dart';

class UserCDS {
  static const _landingPageBoxKey = 'landingPageBoxKey';
  static const _loginBoxKey = 'loginBoxKey';

  Future<Box> _openLandingPageBox() => Hive.openBox(_landingPageBoxKey);

  Future<Box> _openLoginBox() => Hive.openBox(_loginBoxKey);

  Future<bool> checkHasShownLandingPage() =>
      _openLandingPageBox().then((box) => box.get(_landingPageBoxKey) ?? false);

  Future<void> markLandingPageAsSeen() =>
      _openLandingPageBox().then((box) => box.put(_landingPageBoxKey, true));

  Future<bool> checkIsUserLogged() => _openLoginBox().then(
        (box) {
          final String isLogged = box.get(_loginBoxKey);

          if (isLogged == null) {
            return false;
          } else {
            return true;
          }
        },
      );

  Future<String> getEmail() => _openLoginBox().then(
        (box) => box.get(_loginBoxKey),
      );

  Future<void> upsertUserEmail(String email) => _openLoginBox().then(
        (box) => box.put(_loginBoxKey, email),
      );

  Future<void> deleteUserEmail() => _openLoginBox().then(
        (box) => box.delete(_loginBoxKey),
      );
}
