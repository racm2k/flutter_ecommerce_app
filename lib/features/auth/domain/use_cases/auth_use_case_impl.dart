import 'package:app/core/data/repositories/auth/auth_repository.dart';
import 'package:app/features/auth/domain/use_cases/auth_use_case.dart';

class AuthUseCaseImpl implements AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCaseImpl({required this.authRepository});

  @override
  Future<bool> signInWithFacebook() async => await authRepository.signInWithFacebook();

  @override
  Future<bool> signInWithEmailAndPassword(String email, String password) async => await authRepository.signInWithEmailAndPassword(email, password);

  @override
  Future<void> signOut() {
    return authRepository.signOut();
  }

  @override
  Future<bool> checkAuthentication() {
    return authRepository.checkAuthentication();
  }

  @override
  Future<String?> getUserImageURL(String uid) {
    return authRepository.getUserImageURL(uid);
  }

  @override
  Future<String?> getUserUUID() {
    return authRepository.getUserUUID();
  }

  @override
  Future<String?> getUserEmail() {
    return authRepository.getUserEmail();
  }

  @override
  Future<String?> getUserName(String uid) {
    return authRepository.getUserName(uid);
  }

  @override
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) {
    return authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
      username: username,
    );
  }
}
