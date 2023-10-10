import 'package:app/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus {
  initial,
  authenticationFailed,
  authenticated,
  unauthenticated,
  authenticating,
  registrationFailed,
  registering,
  registered
}

class AuthCubit extends Cubit<AuthStatus> {
  final AuthUseCase authUseCase;
  AuthCubit({required this.authUseCase}) : super(AuthStatus.initial);

  void checkAuthentication() async {
    // Check if the user is already authenticated or not
    // You can use Firebase Auth's current user here
    // and update the state accordingly.
    try {
      emit(AuthStatus.authenticating);
      // Check if the user is already authenticated
      final isAuthenticated = await authUseCase.checkAuthentication();

      if (isAuthenticated) {
        emit(AuthStatus.authenticated);
      } else {
        emit(AuthStatus.unauthenticated);
      }
    } catch (e) {
      // Handle any exceptions that occur during the check
      // You can show an error message here if required
    }
  }

  void signInWithFacebook() async{
    try{
      emit(AuthStatus.authenticating);
      final isSignedIn= await authUseCase.signInWithFacebook();
      if(isSignedIn){
        emit(AuthStatus.authenticated);
      }else{
        emit(AuthStatus.authenticationFailed);
      }
    }catch(e){
      print(e);
    }
  }

  void signInWithEmailAndPassword(String email, String password) async {
    // Implement Firebase Email/Password authentication here
    // Update the state based on the authentication result.
    try {
      emit(AuthStatus.authenticating);
      final isSignedIn =
          await authUseCase.signInWithEmailAndPassword(email, password);
      if (isSignedIn) {
        emit(AuthStatus.authenticated);
      } else {
        emit(AuthStatus.authenticationFailed);
        // Authentication failed
        // You can show an error message here if required
      }
    } catch (e) {
      // Handle any exceptions that occur during sign-in
      // You can show an error message here if required
    }
  }

  void signOut() async {
    // Implement Firebase sign-out here
    // Update the state accordingly.
    try {
      await authUseCase.signOut();
      emit(AuthStatus.unauthenticated);
    } catch (e) {
      // Handle any exceptions that occur during sign-out
      // You can show an error message here if required
    }
  }

  void registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String username}) async {
    // Implement Firebase Email/Password registration here
    // Update the state based on the registration result.
    try {
      emit(AuthStatus.registering);
      final isRegistered = await authUseCase.registerWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );
      if (isRegistered) {
        emit(AuthStatus.registered);
      } else {
        emit(AuthStatus.registrationFailed);
        // Registration failed
        // You can show an error message here if required
      }
    } catch (e) {
      // Handle any exceptions that occur during registration
      // You can show an error message here if required
    }
  }
}
