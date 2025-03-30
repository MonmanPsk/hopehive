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

  Stream<List<Donation>> getDonationsStream() {
    return _donations.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> updateDonation(Donation donation) async {
    try {
      await _donations.doc(donation.donationId).update(donation.toMap());
    } catch (e) {
      throw Exception('Failed to update donation: $e');
    }
  }

  Future<void> deleteDonation(String donationId) async {
    try {
      await _donations.doc(donationId).delete();
    } catch (e) {
      throw Exception('Failed to delete donation: $e');
    }
  }

  Future<Donation?> getDonationById(String donationId) async {
    try {
      DocumentSnapshot snapshot = await _donations.doc(donationId).get();
      if (snapshot.exists) {
        return Donation.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch donation: $e');
    }
  }

  Future<List<Donation>> getDonationsByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _donations
          .where('creator', isEqualTo: FirebaseFirestore.instance.doc(userId))
          .get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations by user: $e');
    }
  }

  Future<List<Donation>> getDonationsByCategory(String category) async {
    try {
      QuerySnapshot snapshot =
          await _donations.where('category', isEqualTo: category).get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations by category: $e');
    }
  }

  Future<List<Donation>> getDonationsByCondition(String condition) async {
    try {
      QuerySnapshot snapshot =
          await _donations.where('condition', isEqualTo: condition).get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations by condition: $e');
    }
  }

  Future<List<Donation>> getDonationsByUrgency(String urgency) async {
    try {
      QuerySnapshot snapshot =
          await _donations.where('urgency', isEqualTo: urgency).get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations by urgency: $e');
    }
  }

  Future<List<Donation>> getDonationsByOption(String option) async {
    try {
      QuerySnapshot snapshot =
          await _donations.where('option', isEqualTo: option).get();
      return snapshot.docs
          .map((doc) =>
              Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch donations by option: $e');
    }
  }
}
