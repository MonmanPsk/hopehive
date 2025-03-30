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

  Map<String, dynamic> toMap() {
    return {
      'creator': creator.path,
      'donor': donors.map((d) => d.path).toList(),
      'title': title,
      'reason': reason,
      'images': images,
      'category': category,
      'condition': condition,
      'quantity': quantity,
      'urgency': urgency,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'option': option,
      'contact': contact,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map, String id) {
    return Request(
      requestId: id,
      creator: FirebaseFirestore.instance.doc(map['creator']),
      donors: (map['donor'] as List<dynamic>?)
              ?.map((d) => FirebaseFirestore.instance.doc(d))
              .toList() ??
          [],
      title: map['title'] ?? '',
      reason: map['reason'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      condition: map['condition'] ?? '',
      quantity: map['quantity'] ?? 0,
      urgency: map['urgency'] ?? '',
      location:
          GeoPoint(map['location']['latitude'], map['location']['longitude']),
      option: map['option'] ?? '',
      contact: Map<String, String>.from(map['contact'] ?? {}),
    );
  }
}
