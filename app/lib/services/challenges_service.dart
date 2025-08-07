import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/';

class ChallengeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all active challenges
  Future<List<EcoChallenge>> fetchChallenges() async {
    final snapshot = await _db
        .collection('eco_challenges')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => EcoChallenge.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Join a challenge for a user
  Future<void> joinChallenge(String userId, EcoChallenge challenge) async {
    final ref = _db
        .collection('users')
        .doc(userId)
        .collection('joined_challenges')
        .doc(challenge.id);

    await ref.set({
      'joinedAt': FieldValue.serverTimestamp(),
      'status': 'in-progress',
      'progress': 0.0,
    });
  }

  /// Fetch challenges a user has joined
  Future<List<String>> getUserJoinedChallengeIds(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('joined_challenges')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// Check if user has joined a challenge
  Future<bool> hasJoined(String userId, String challengeId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('joined_challenges')
        .doc(challengeId)
        .get();

    return doc.exists;
  }
}
