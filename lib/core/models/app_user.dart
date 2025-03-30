import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  final String profileImage;
  final String firstname;
  final String lastname;
  final String phone;
  final List<DocumentReference> donations;
  final List<DocumentReference> requests;
  final Map<String, List<DocumentReference>> saved;
  final List<Map<String, bool>> verification;
  final List<GeoPoint> locations;

  AppUser({
    required this.userId,
    required this.profileImage,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.donations,
    required this.requests,
    required this.saved,
    required this.verification,
    required this.locations,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'donation': donations.map((d) => d.path).toList(),
      'request': requests.map((r) => r.path).toList(),
      'saved': {
        'donation': saved['donation']?.map((d) => d.path).toList() ?? [],
        'request': saved['request']?.map((r) => r.path).toList() ?? [],
      },
      'verification': verification,
      'locations': locations
          .map((l) => {'latitude': l.latitude, 'longitude': l.longitude})
          .toList(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: '',
      profileImage: map['profileImage'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      phone: map['phone'] ?? '',
      donations: (map['donation'] as List<dynamic>?)
              ?.map((d) => FirebaseFirestore.instance.doc(d))
              .toList() ??
          [],
      requests: (map['request'] as List<dynamic>?)
              ?.map((r) => FirebaseFirestore.instance.doc(r))
              .toList() ??
          [],
      saved: {
        'donation': (map['saved']?['donation'] as List<dynamic>?)
                ?.map((d) => FirebaseFirestore.instance.doc(d))
                .toList() ??
            [],
        'request': (map['saved']?['request'] as List<dynamic>?)
                ?.map((r) => FirebaseFirestore.instance.doc(r))
                .toList() ??
            [],
      },
      verification: (map['verification'] as List<dynamic>?)
              ?.map((v) => Map<String, bool>.from(v))
              .toList() ??
          [],
      locations: (map['locations'] as List<dynamic>?)
              ?.map((l) => GeoPoint(l['latitude'], l['longitude']))
              .toList() ??
          [],
    );
  }
}
