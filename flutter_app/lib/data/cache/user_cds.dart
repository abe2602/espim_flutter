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

  Future<bool> checkIsUserLogged() =>
      _openLoginBox().then((box) => box.get(_loginBoxKey) ?? false);

  Future<void> markUserAsLogged() =>
      _openLoginBox().then((box) => box.put(_loginBoxKey, true));

  Future<void> markUserAsSignOut() =>
      _openLoginBox().then((box) => box.put(_loginBoxKey, false));
}
