import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globo_quest/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required this.authService});

  final AuthService authService;

  bool _showPassword = false;
  bool _loading = false;

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  bool get showPassword {
    return _showPassword;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading {
    return _loading;
  }

  Future<User> loginWithEmail(String email, String password) async {
    loading = true;

    try {
      final user = await authService.loginWithEmail(email, password);
      loading = false;
      return user;
    } catch (_) {
      loading = false;
      rethrow;
    }
  }

  Future<User> loginWithGoogle() async {
    loading = true;

    try {
      final user = await authService.loginWithGoogle();
      loading = false;
      return user;
    } catch (_) {
      loading = false;
      rethrow;
    }
  }

  void clearValues() {
    _showPassword = false;
    _loading = false;
    notifyListeners();
  }
}
