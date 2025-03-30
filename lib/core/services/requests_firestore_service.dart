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
}
