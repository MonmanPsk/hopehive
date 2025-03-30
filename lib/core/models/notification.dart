import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String type;
  final String title;
  final String content;
  final Timestamp timestamp;

  Notification({
    required this.type,
    required this.title,
    required this.content,
    required this.timestamp,
  });
}
