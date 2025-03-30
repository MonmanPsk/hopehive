import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopehive/core/models/donation.dart';

class DonationsFirestoreService {
  final CollectionReference _donations =
      FirebaseFirestore.instance.collection('donations');

  Future<void> addDonation(Donation donation) async {
    try {
      await _donations.doc(donation.donationId).set(donation.toMap());
    } catch (e) {
      throw Exception('Failed to add donation: $e');
    }
  }

  Future<List<Donation>> getDonations() async {
    try {
      QuerySnapshot snapshot = await _donations.get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations: $e');
    }
  }
}
