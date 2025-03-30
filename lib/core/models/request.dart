import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String requestId;
  final DocumentReference creator;
  final List<DocumentReference> donors;
  final String title;
  final String reason;
  final List<String> images;
  final String category;
  final String condition;
  final int quantity;
  final String urgency;
  final GeoPoint location;
  final String option;
  final Map<String, String> contact;

  Request({
    required this.requestId,
    required this.creator,
    required this.donors,
    required this.title,
    required this.reason,
    required this.images,
    required this.category,
    required this.condition,
    required this.quantity,
    required this.urgency,
    required this.location,
    required this.option,
    required this.contact,
  });
}
