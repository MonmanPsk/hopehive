import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String requestId;
  final String creator;
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
  final List<Map<String, dynamic>> contact;
  final Timestamp createdAt;

  Request({
    required this.requestId,
    required this.creator,
    this.donors = const [],
    required this.title,
    required this.reason,
    this.images = const [],
    required this.category,
    required this.condition,
    required this.quantity,
    required this.urgency,
    required this.location,
    required this.option,
    required this.contact,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
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
      'createdAt': createdAt,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map, String id) {
    return Request(
      requestId: id,
      creator: map['creator'] ?? '',
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
      contact: List<Map<String, dynamic>>.from(map['contact'] ?? []),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
