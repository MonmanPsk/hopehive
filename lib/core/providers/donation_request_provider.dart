// Create a provider for donations stream
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/models/donation.dart';
import 'package:hopehive/core/models/request.dart';

final donationsStreamProvider = StreamProvider<List<Donation>>((ref) {
  return FirebaseFirestore.instance
      .collection('donations')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Donation.fromMap(doc.data(), doc.id))
          .toList());
});

// Create a provider for requests stream
final requestsStreamProvider = StreamProvider<List<Request>>((ref) {
  return FirebaseFirestore.instance
      .collection('requests')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Request.fromMap(doc.data(), doc.id))
          .toList());
});
