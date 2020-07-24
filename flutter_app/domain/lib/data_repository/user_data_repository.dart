abstract class UserDataRepository {
  Future<bool> checkHasShownLandingPage();
  Future<void> markLandingPageAsSeen();
}