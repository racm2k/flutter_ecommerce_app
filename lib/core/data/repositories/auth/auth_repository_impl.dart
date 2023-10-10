
import 'dart:developer';

import 'package:app/core/data/repositories/auth/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  const AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<bool> signInWithFacebook() async {
    try {
      // Trigger Facebook login
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Check if the login was successful
      if (loginResult.status == LoginStatus.success) {
        // Use the access token to sign in or sign up with Firebase
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);



        // Check if the user already exists in Firebase
        UserCredential? existingUser = await firebaseAuth
            .signInWithCredential(facebookAuthCredential);


        final photoUrl= existingUser.additionalUserInfo?.profile?['picture']['data']['url'];


        // Create a new document in the users collection with the uid
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(existingUser.user?.uid);

        // Save the user information to the database
        await userRef.set({
          'user_name': existingUser.user?.displayName,
          'image_url': photoUrl,
        });
              return existingUser.user != null;
      }
      return false;
    } catch (e) {
      print("Error signing in with Facebook: $e");
      return false;
    }
  }

  @override
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<bool> checkAuthentication() async {
    try {
      final user = firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      // Handle any exceptions that occur during the check
      // You can show an error message here if required
      return false;
    }
  }

  @override
  Future<String?> getUserImageURL(String uid) async {
    try {
      // Fetch the user information from the database and get the image URL
      // For example, if you're using Firestore:
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userSnapshot = await userRef.get();
      final imageUrl = userSnapshot.data()?['image_url'];

      return imageUrl ?? '';
    } catch (e) {
      // Handle any exceptions that occur during image URL retrieval
      // You can show an error message here if required
      return '';
    }
  }

  @override
  Future<String?> getUserUUID() async {
    try {
      final user = firebaseAuth.currentUser;
      return user?.uid;
    } catch (e) {
      // Handle any exceptions that occur during UUID retrieval
      // You can show an error message here if required
      return null;
    }
  }

  @override
  Future<String?> getUserEmail() async {
    try {
      final user = firebaseAuth.currentUser;
      return user?.email;
    } catch (e) {
      // Handle any exceptions that occur during email retrieval
      // You can show an error message here if required
      return null;
    }
  }

  @override
  Future<String?> getUserName(String uid) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userSnapshot = await userRef.get();
      final userName = userSnapshot.data()?['user_name'];
      return userName;
    } catch (e) {
      // Handle any exceptions that occur during name retrieval
      // You can show an error message here if required
      return null;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create a new document in the users collection with the uid
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid);

      // Save the user information to the database
      await userRef.set({
        'user_name': username,
        'image_url': '',
      });

      return userCredential.user != null;
    } catch (e) {
      // Handle any exceptions that occur during registration
      // You can show an error message here if required
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      // Handle any exceptions that occur during password reset
      // You can show an error message here if required
      return false;
    }
  }

  @override
  Future<bool> updatePassword(String code, String newPassword) async {
    try {
      await firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      return true;
    } catch (e) {
      // Handle any exceptions that occur during password reset confirmation
      // You can show an error message here if required
      return false;
    }
  }
}
