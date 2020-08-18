import 'package:domain/model/settings.dart';
import 'package:domain/model/user.dart';

abstract class UserDataRepository {
  Future<bool> checkHasShownLandingPage();
  Future<void> markLandingPageAsSeen();
  Future<User> getLoggedUser();
  Future<Settings> getSettings();
  Future<void> changeSettings(Settings settings);
}