abstract class UserRepository {
  Future<bool> loginWithGmail(String email, String password);
  Future<bool> isAuthentication();
  Future<void> logout();
  Future<bool> registerWithGmail(String email, String password);
}
