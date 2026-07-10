import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) throw Exception('Inicio de sesión cancelado');

  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await _auth.signInWithCredential(credential);

  // Guarda o actualiza el perfil en Firestore
  // Esto permite buscar usuarios por email para compartir tareas
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .set({
    'uid': userCredential.user!.uid,
    'email': userCredential.user!.email,
    'name': userCredential.user!.displayName,
    'photoUrl': userCredential.user!.photoURL,
  }, SetOptions(merge: true));

  return userCredential;
}

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}