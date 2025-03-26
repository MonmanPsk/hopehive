import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerIsLoadingProvider = StateProvider<bool>((ref) => false);
final registerErrorMessageProvider = StateProvider<String?>((ref) => null);
final registerAuthStateProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());
