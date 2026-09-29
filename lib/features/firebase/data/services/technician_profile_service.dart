import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TechnicianProfileService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _techniciansCollection =>
          _firestore.collection('technicians');

  // ==========================================================
  // CURRENT TECHNICIAN UID
  // ==========================================================

  static String? get currentTechnicianId {
    return _auth.currentUser?.uid;
  }

  // ==========================================================
  // CREATE TECHNICIAN PROFILE
  // ==========================================================

  static Future<void> createTechnicianProfile({
    required String name,
    required String email,
    required String phone,
    String profession = 'Technician',
  }) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'profession': profession,

      // Profile picture
      'profileImageUrl': '',
      'profileImageBase64': '',

      'services': <String>[],
      'availability': true,
      'rating': 0,
      'isNewTechnician': true,
      'bankDetails': {},

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // GET CURRENT TECHNICIAN PROFILE
  // ==========================================================

  static Future<
      DocumentSnapshot<Map<String, dynamic>>?>
      getCurrentTechnicianProfile() async {
    final uid = currentTechnicianId;

    if (uid == null) {
      return null;
    }

    return await _techniciansCollection
        .doc(uid)
        .get();
  }

  // ==========================================================
  // UPDATE TECHNICIAN PROFILE
  // ==========================================================

  static Future<void> updateTechnicianProfile({
    String? name,
    String? phone,
    String? profession,
    String? profileImageUrl,
  }) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (profession != null) {
      data['profession'] = profession;
    }

    if (profileImageUrl != null) {
      data['profileImageUrl'] =
          profileImageUrl;
    }

    data['updatedAt'] =
        FieldValue.serverTimestamp();

    await _techniciansCollection
        .doc(uid)
        .update(data);
  }

  // ==========================================================
  // UPDATE PROFILE PICTURE - BASE64
  // ==========================================================

  static Future<void> updateProfilePictureBase64(
    String imageBase64,
  ) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'profileImageBase64': imageBase64,

      // Clear old Storage URL if there was one.
      'profileImageUrl': '',

      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // REMOVE PROFILE PICTURE
  // ==========================================================

  static Future<void> removeProfilePicture() async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'profileImageUrl': '',
      'profileImageBase64': '',
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE SERVICES
  // ==========================================================

  static Future<void> updateServices(
    List<String> services,
  ) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'services': services,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE AVAILABILITY
  // ==========================================================

  static Future<void> updateAvailability(
    bool availability,
  ) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'availability': availability,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE BANK DETAILS
  // ==========================================================

  static Future<void> updateBankDetails({
    required Map<String, dynamic> bankDetails,
  }) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'bankDetails': bankDetails,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE PROFILE PICTURE - OLD URL METHOD
  // ==========================================================

  static Future<void> updateProfilePicture(
    String imageUrl,
  ) async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .update({
      'profileImageUrl': imageUrl,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // DELETE TECHNICIAN PROFILE
  // ==========================================================

  static Future<void> deleteTechnicianProfile() async {
    final uid = currentTechnicianId;

    if (uid == null) {
      throw Exception(
        'No technician is currently logged in.',
      );
    }

    await _techniciansCollection
        .doc(uid)
        .delete();
  }

  // ==========================================================
  // TECHNICIAN PROFILE STREAM
  // ==========================================================

  static Stream<
      DocumentSnapshot<Map<String, dynamic>>>
      technicianProfileStream() {
    final uid = currentTechnicianId;

    if (uid == null) {
      return const Stream.empty();
    }

    return _techniciansCollection
        .doc(uid)
        .snapshots();
  }
}