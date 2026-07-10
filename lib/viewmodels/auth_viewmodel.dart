import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository) {
  _status = repository.currentUser != null
      ? AuthStatus.authenticated
      : AuthStatus.unauthenticated;

  repository.authStateChanges.listen((user) {
    _status = user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    notifyListeners();
  });
}

  AuthStatus _status = AuthStatus.initial;
  String? errorMessage;

  AuthStatus get status => _status;
  User? get currentUser => repository.currentUser;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> signInWithGoogle() async {
    _status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.signInWithGoogle();
    } catch (e) {
      _status = AuthStatus.error;
      errorMessage = e.toString().contains('cancelado')
          ? 'Inicio de sesión cancelado'
          : 'Error al iniciar sesión. Intenta de nuevo.';
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await repository.signOut();
    notifyListeners();
  }
}