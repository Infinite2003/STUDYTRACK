import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository) {
    // Escucha cambios de sesión automáticamente
    repository.authStateChanges.listen((user) {
      if (user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
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
      _status = AuthStatus.authenticated;
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
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}