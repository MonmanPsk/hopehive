import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addChat(String chatId, Map<String, dynamic> chatData) async {
    try {
      await _firestore.collection('chats').doc(chatId).set(chatData);
    } catch (e) {
      throw Exception('Failed to add chat: $e');
    }
  }

  Future<Map<String, dynamic>?> getChat(String chatId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('chats').doc(chatId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to fetch chat: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getChatsStream() {
    return _firestore.collection('chats').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  Future<void> updateChat(String chatId, Map<String, dynamic> chatData) async {
    try {
      await _firestore.collection('chats').doc(chatId).update(chatData);
    } catch (e) {
      throw Exception('Failed to update chat: $e');
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }
}
