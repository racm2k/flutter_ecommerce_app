abstract class AuthUseCase {
  Future<bool> signInWithFacebook();
  Future<bool> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<bool> checkAuthentication();
  Future<String?> getUserImageURL(String uid);
  Future<String?> getUserUUID();
  Future<String?> getUserEmail();
  Future<String?> getUserName(String uid);
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });
}
