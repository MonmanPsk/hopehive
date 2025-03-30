import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/models/app_user.dart';

final userProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map(
        (snapshot) => snapshot.exists ? AppUser.fromMap(snapshot.data() ?? {}) : null,
      );
});
