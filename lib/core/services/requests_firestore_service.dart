import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopehive/core/models/request.dart';

class RequestsFirestoreService {
  final CollectionReference _requests =
      FirebaseFirestore.instance.collection('requests');

  Future<void> addRequest(Request request) async {
    try {
      await _requests.doc(request.requestId).set(request.toMap());
    } catch (e) {
      throw Exception('Failed to add request: $e');
    }
  }

  Future<List<Request>> getRequests() async {
    try {
      QuerySnapshot snapshot = await _requests.get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  Stream<List<Request>> getRequestsStream() {
    return _requests.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> updateRequest(Request request) async {
    try {
      await _requests.doc(request.requestId).update(request.toMap());
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await _requests.doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  Future<Request?> getRequestById(String requestId) async {
    try {
      DocumentSnapshot snapshot = await _requests.doc(requestId).get();
      if (snapshot.exists) {
        return Request.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch request: $e');
    }
  }

  Future<List<Request>> getRequestsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('userId', isEqualTo: userId).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by user ID: $e');
    }
  }

  Future<List<Request>> getRequestsByStatus(String status) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('status', isEqualTo: status).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by status: $e');
    }
  }

  Future<List<Request>> getRequestsByCategory(String category) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('category', isEqualTo: category).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by category: $e');
    }
  }

  Future<List<Request>> getRequestsByCondition(String condition) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('condition', isEqualTo: condition).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by condition: $e');
    }
  }

  Future<List<Request>> getRequestsByUrgency(String urgency) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('urgency', isEqualTo: urgency).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by urgency: $e');
    }
  }

  Future<List<Request>> getRequestsByOption(String option) async {
    try {
      QuerySnapshot snapshot =
          await _requests.where('option', isEqualTo: option).get();
      return snapshot.docs
          .map((doc) =>
              Request.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests by option: $e');
    }
  }
}
