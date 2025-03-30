import 'package:cloud_firestore/cloud_firestore.dart';

class User {
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

  User({
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
}
