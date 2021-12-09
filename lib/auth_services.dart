import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future signUpEmail(email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return SignInSignUpResult(user: result.user, message: "");
    } catch (e) {
      return SignInSignUpResult(user: null, message: e.toString().trim());
    }
  }

  static Future signInEmail(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return SignInSignUpResult(user: result.user, message: "");
    } catch (e) {
      return SignInSignUpResult(user: null, message: e.toString().split(" ")[0].trim());
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> delete(email, password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.delete();
  }

  static Stream<User?> get userStream => _auth.authStateChanges();
}

class SignInSignUpResult {
  final User? user;
  final String message;

  SignInSignUpResult({required this.user, required this.message});
}
