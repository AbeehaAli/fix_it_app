import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerProfileService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ==========================================================
  // CUSTOMERS COLLECTION
  // ==========================================================

  static CollectionReference<Map<String, dynamic>>
      get _customersCollection =>
          _firestore.collection('customers');

  // ==========================================================
  // CURRENT CUSTOMER UID
  // ==========================================================

  static String? get currentCustomerId {
    return _auth.currentUser?.uid;
  }

  // ==========================================================
  // CURRENT CUSTOMER DOCUMENT
  // ==========================================================

  static DocumentReference<Map<String, dynamic>>?
      get _currentCustomerDocument {
    final uid = currentCustomerId;

    if (uid == null) {
      return null;
    }

    return _customersCollection.doc(uid);
  }

  // ==========================================================
  // CREATE CUSTOMER PROFILE
  // ==========================================================

  static Future<void> createCustomerProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No customer is currently logged in.');
    }

    final customerDocument =
        _customersCollection.doc(user.uid);

    final snapshot = await customerDocument.get();

    // If the customer document already exists,
    // do not overwrite the existing information.
    if (snapshot.exists) {
      return;
    }

    await customerDocument.set({
      'uid': user.uid,
      'name': user.displayName?.trim() ?? '',
      'email': user.email?.trim() ?? '',
      'phone': '',
      'addresses': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // GET CUSTOMER PROFILE
  // ==========================================================

  static Future<Map<String, dynamic>?> getCustomerProfile() async {
    final document = _currentCustomerDocument;

    if (document == null) {
      return null;
    }

    final snapshot = await document.get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  // ==========================================================
  // UPDATE CUSTOMER PROFILE
  // ==========================================================

  static Future<void> updateCustomerProfile({
    required String name,
    required String phone,
  }) async {
    final document = _currentCustomerDocument;

    if (document == null) {
      throw Exception('No customer is currently logged in.');
    }

    await document.set(
      {
        'uid': currentCustomerId,
        'name': name.trim(),
        'phone': phone.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // Also keep Firebase Auth displayName synchronized.
    final user = _auth.currentUser;

    if (user != null) {
      await user.updateDisplayName(name.trim());
    }
  }

  // ==========================================================
  // UPDATE CUSTOMER EMAIL
  // ==========================================================

  static Future<void> updateCustomerEmail(
    String email,
  ) async {
    final document = _currentCustomerDocument;

    if (document == null) {
      throw Exception('No customer is currently logged in.');
    }

    await document.set(
      {
        'email': email.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // ==========================================================
  // ADD ADDRESS
  // ==========================================================

  static Future<void> addAddress({
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    final document = _currentCustomerDocument;

    if (document == null) {
      throw Exception('No customer is currently logged in.');
    }

    final addressData = {
      'address': address.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.now(),
    };

    await document.update({
      'addresses': FieldValue.arrayUnion([addressData]),
      'updatedAt': FieldValue.serverTimestamp(),
    }
     );
  }

  // ==========================================================
  // GET CUSTOMER ADDRESSES
  // ==========================================================

  static Future<List<Map<String, dynamic>>> getAddresses() async {
    final profile = await getCustomerProfile();

    if (profile == null) {
      return [];
    }

    final addresses = profile['addresses'];

    if (addresses is! List) {
      return [];
    }

    return addresses
        .whereType<Map>()
        .map(
          (address) => Map<String, dynamic>.from(address),
        )
        .toList();
  }

  // ==========================================================
  // DELETE ADDRESS
  // ==========================================================

  static Future<void> deleteAddress(
    Map<String, dynamic> address,
  ) async {
    final document = _currentCustomerDocument;

    if (document == null) {
      throw Exception('No customer is currently logged in.');
    }

    await document.update({
      'addresses': FieldValue.arrayRemove([address]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}