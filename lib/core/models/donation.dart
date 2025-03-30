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
  final Timestamp createdAt;

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
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'creator': creator.path,
      'requester': requesters.map((r) => r.path).toList(),
      'title': title,
      'description': description,
      'images': images,
      'category': category,
      'condition': condition,
      'quantity': quantity,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'option': option,
      'contact': contact,
      'createdAt': createdAt,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map, String id) {
    return Donation(
      donationId: id,
      creator: FirebaseFirestore.instance.doc(map['creator']),
      requesters: (map['requester'] as List<dynamic>?)
              ?.map((r) => FirebaseFirestore.instance.doc(r))
              .toList() ??
          [],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      condition: map['condition'] ?? '',
      quantity: map['quantity'] ?? 0,
      location:
          GeoPoint(map['location']['latitude'], map['location']['longitude']),
      option: map['option'] ?? '',
      contact: Map<String, String>.from(map['contact'] ?? {}),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
