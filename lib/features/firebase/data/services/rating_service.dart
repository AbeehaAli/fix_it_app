import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // =========================================================
  // SUBMIT RATING
  // =========================================================

  static Future<void> submitRating({
    required String requestId,
    required String technicianId,
    required int rating,
    required String review,
  }) async {
    final customer = _auth.currentUser;

    if (customer == null) {
      throw Exception('Customer is not logged in.');
    }

    if (rating < 1 || rating > 5) {
      throw Exception('Rating must be between 1 and 5.');
    }

    final requestRef =
        _firestore.collection('service_requests').doc(requestId);

    final technicianRef =
        _firestore.collection('technicians').doc(technicianId);

    await _firestore.runTransaction((transaction) async {
      // =====================================================
      // GET REQUEST
      // =====================================================

      final requestSnapshot =
          await transaction.get(requestRef);

      if (!requestSnapshot.exists) {
        throw Exception('Service request not found.');
      }

      final requestData = requestSnapshot.data();

      if (requestData == null) {
        throw Exception('Service request data not found.');
      }

      // =====================================================
      // CHECK STATUS
      // =====================================================

      final status =
          requestData['status']?.toString().toLowerCase();

      if (status != 'completed') {
        throw Exception(
          'Only completed jobs can be rated.',
        );
      }

      // =====================================================
      // PREVENT DUPLICATE RATING
      // =====================================================

      final existingRating = requestData['rating'];

      if (existingRating != null) {
        throw Exception(
          'This job has already been rated.',
        );
      }

      // =====================================================
      // GET TECHNICIAN
      // =====================================================

      final technicianSnapshot =
          await transaction.get(technicianRef);

      if (!technicianSnapshot.exists) {
        throw Exception('Technician profile not found.');
      }

      final technicianData =
          technicianSnapshot.data();

      if (technicianData == null) {
        throw Exception(
          'Technician profile data not found.',
        );
      }

      // =====================================================
      // OLD RATING DATA
      // =====================================================

      final oldRating =
          (technicianData['rating'] as num?)?.toDouble() ?? 0.0;

      final oldRatingCount =
          (technicianData['ratingCount'] as num?)?.toInt() ?? 0;

      // =====================================================
      // CALCULATE NEW AVERAGE
      // =====================================================

      final newRatingCount = oldRatingCount + 1;

      final newRating =
          ((oldRating * oldRatingCount) + rating) /
              newRatingCount;

      // =====================================================
      // SAVE RATING TO SERVICE REQUEST
      // =====================================================

      transaction.update(requestRef, {
        'rating': rating,
        'review': review.trim(),
        'ratedBy': customer.uid,
        'ratedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      // =====================================================
      // UPDATE TECHNICIAN RATING
      // =====================================================

      transaction.update(technicianRef, {
        'rating': double.parse(
          newRating.toStringAsFixed(1),
        ),
        'ratingCount': newRatingCount,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  // =========================================================
  // CHECK WHETHER JOB HAS BEEN RATED
  // =========================================================

  static Future<bool> hasRated(
    String requestId,
  ) async {
    final snapshot = await _firestore
        .collection('service_requests')
        .doc(requestId)
        .get();

    if (!snapshot.exists) {
      return false;
    }

    final data = snapshot.data();

    if (data == null) {
      return false;
    }

    return data['rating'] != null;
  }
}