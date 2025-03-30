import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopehive/core/models/app_user.dart';

class UsersFirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(AppUser user) async {
    try {
      await _users.doc(user.userId).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<AppUser?> getUser(String id) async {
    try {
      DocumentSnapshot doc = await _users.doc(id).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _users.doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _users.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
