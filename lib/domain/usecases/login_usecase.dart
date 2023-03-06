abstract class LoginUseCase {
  Future<bool> loginWithGmail({String email = "", String pass = ""});
  Future<bool> logout();
}
