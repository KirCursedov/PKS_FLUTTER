import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Текущий пользователь
  User? get currentUser => _auth.currentUser;

  // Вход
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Ошибка входа: $e");
      return null;
    }
  }

  // Регистрация
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Ошибка регистрации: $e");
      return null;
    }
  }

  // Выход
  Future<void> signOut() async {
    await _auth.signOut();
  }
}