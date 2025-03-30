import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final DocumentReference senderId;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}
