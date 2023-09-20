import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globo_quest/errors/auth_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  AuthService() {
    _authStateSubscription = _fireAuth.authStateChanges().listen(
          _onAuthStateChanged,
        );
  }

  User? _user;

  User? get user => _user;

  final _fireAuth = FirebaseAuth.instance;

  StreamSubscription<User?>? _authStateSubscription;

  Future<User> loginWithEmail(String email, String password) async {
    try {
      final credential = await _fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!;
    } catch (_) {
      throw const LoginException();
    }
  }

  Future<User> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) throw const AbortedGoogleLoginException();

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final userCredential = await _fireAuth.signInWithCredential(credential);
      return userCredential.user!;
    } catch (_) {
      throw const GoogleLoginException();
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    await _fireAuth.signOut();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<User?> getCurrentUser() async {
    final user = await _fireAuth.userChanges().first;
    _onAuthStateChanged(user);
    return user;
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
