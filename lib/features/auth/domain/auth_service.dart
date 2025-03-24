import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hopehive/features/auth/domain/login_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(WidgetRef ref, String email, String password) async {
    ref.read(isLoadingProvider.notifier).state = true;
    ref.read(errorMessageProvider.notifier).state = null;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ref.read(errorMessageProvider.notifier).state = _handleError(e.code);
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> loginWithGoogle(WidgetRef ref) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  String _handleError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'Login failed. Please check your credentials.';
    }
  }
}
