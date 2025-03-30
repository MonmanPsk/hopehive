import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String donationId;
  final DocumentReference creator;
  final List<DocumentReference> requesters;
  final String title;
  final String description;
  final List<String> images;
  final String category;
  final String condition;
  final int quantity;
  final GeoPoint location;
  final String option;
  final Map<String, String> contact;

  Donation({
    required this.donationId,
    required this.creator,
    required this.requesters,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.condition,
    required this.quantity,
    required this.location,
    required this.option,
    required this.contact,
  });
}
