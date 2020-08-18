abstract class AuthDataRepository {
  Future<bool> checkIsUserLogged();
  Future<void> login();
  Future<void> logout();
}