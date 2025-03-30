import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopehive/core/models/message.dart';

class Chat {
  final String chatId;
  final List<DocumentReference> users;
  final List<Message> messages;

  Chat({
    required this.chatId,
    required this.users,
    required this.messages,
  });
}
