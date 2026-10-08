import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      _messagesCollection(String requestId) {
    return _firestore
        .collection('service_requests')
        .doc(requestId)
        .collection('messages');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      latestMessagesStream(String requestId) {
    return _messagesCollection(requestId)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(1)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String requestId,
    required String senderName,
    required String message,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    await _messagesCollection(requestId).add({
      'senderId': user.uid,
      'senderName': senderName,
      'message': text,

      // Save the current device time
      'createdAt': Timestamp.now(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      messagesStream(String requestId) {
    return _messagesCollection(requestId)
        .orderBy(
          'createdAt',
          descending: false,
        )
        .snapshots();
  }
}