// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      print('Signed in as ${userCredential.user?.uid}');
    } catch (e) {
      print('Failed to sign in anonymously: $e');
    }
  }
}
