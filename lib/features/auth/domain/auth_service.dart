import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hopehive/core/models/app_user.dart';
import 'package:hopehive/core/services/users_firestore_service.dart';
import 'package:hopehive/features/auth/domain/login_provider.dart';
import 'package:hopehive/features/auth/domain/register_provider.dart';

class AuthService {
  Future<void> login(WidgetRef ref, String email, String password) async {
    ref.read(isLoadingProvider.notifier).state = true;
    ref.read(errorMessageProvider.notifier).state = null;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ref.read(errorMessageProvider.notifier).state = _handleError(e.code);
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> loginWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Signed in
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Signed in
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  String _handleError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      default:
        return 'Login failed. Please check your credentials.';
    }
  }

  Future<bool> register(
    WidgetRef ref,
    String email,
    String password,
    String firstname,
    String lastname,
  ) async {
    ref.read(registerIsLoadingProvider.notifier).state = true;
    ref.read(registerErrorMessageProvider.notifier).state = null;

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update the user's display name
      await userCredential.user?.updateDisplayName('$firstname $lastname');

      // Create a Firestore document for the user
      final userId = userCredential.user?.uid;
      if (userId != null) {
        final appUser = AppUser(
          userId: userId,
          firstname: firstname,
          lastname: lastname,
        );

        final usersFirestoreService = UsersFirestoreService();
        await usersFirestoreService.addUser(appUser);
      }

      // Sign out the user after registration
      await FirebaseAuth.instance.signOut();

      return true;
    } on FirebaseAuthException catch (e) {
      ref.read(registerErrorMessageProvider.notifier).state =
          _handleError(e.code);

      return false;
    } finally {
      ref.read(registerIsLoadingProvider.notifier).state = false;
    }
  }
}
