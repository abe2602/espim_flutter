import 'package:domain/model/user.dart';

abstract class UserDataRepository {
  Future<bool> checkHasShownLandingPage();
  Future<void> markLandingPageAsSeen();
  Future<User> getLoggedUser();
}