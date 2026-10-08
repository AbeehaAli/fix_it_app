import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceRequestService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _requestsCollection =>
          _firestore.collection('service_requests');

  // =========================================================
  // SEND REQUEST - CUSTOMER
  // =========================================================

  static Future<void> sendRequest({
    required String technicianId,
    required String technicianName,
    required String technicianProfession,
    required String service,
  }) async {
    final customer = _auth.currentUser;

    if (customer == null) {
      throw Exception('Customer is not logged in.');
    }

    final customerName =
        customer.displayName?.trim().isNotEmpty == true
            ? customer.displayName!.trim()
            : 'Customer';

    await _requestsCollection.add({
      'customerId': customer.uid,
      'customerName': customerName,
      'customerEmail': customer.email ?? '',
      'technicianId': technicianId,
      'technicianName': technicianName,
      'technicianProfession': technicianProfession,
      'service': service,
      'status': 'pending',
      'date': '',
      'time': '',
      'address': '',
      'problemDetails': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // TECHNICIAN REQUESTS
  // =========================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      technicianRequestsStream() {
    final technician = _auth.currentUser;

    if (technician == null) {
      return const Stream.empty();
    }

    return _requestsCollection
        .where(
          'technicianId',
          isEqualTo: technician.uid,
        )
        .snapshots();
  }
  // =========================================================
// CUSTOMER REQUESTS
// =========================================================

static Stream<QuerySnapshot<Map<String, dynamic>>>
    customerRequestsStream() {
  final customer = _auth.currentUser;

  if (customer == null) {
    return const Stream.empty();
  }

  return _requestsCollection
      .where(
        'customerId',
        isEqualTo: customer.uid,
      )
      .snapshots();
}

  // =========================================================
  // ACCEPT REQUEST
  // =========================================================

  static Future<void> acceptRequest(
      String requestId) async {
    await _requestsCollection.doc(requestId).update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // REJECT REQUEST
  // =========================================================

  static Future<void> rejectRequest(
      String requestId) async {
    await _requestsCollection.doc(requestId).update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  
static Future<void> startJob(String requestId) async {
  await _requestsCollection.doc(requestId).update({
    'status': 'in_progress',
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

static Future<void> completeJob(String requestId) async {
  await _requestsCollection.doc(requestId).update({
    'status': 'completed',
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

}