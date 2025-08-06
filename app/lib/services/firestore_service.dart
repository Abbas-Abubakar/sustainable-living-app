import 'package:app/models/carbon_foot_print.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save new user to Firestore
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update entire user record
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  // Update part of user record
  Future<void> updateUserFields(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Save footprint with frequency
  Future<void> saveCarbonFootprint(CarbonFootprint footprint) async {
    await _firestore
        .collection('carbon_footprints')
        .add(footprint.toMap());
  }

// Get all footprints for a user, optionally filtered by frequency
  Stream<List<CarbonFootprint>> getUserFootprints(String userId, {String? frequency}) {
    Query query = _firestore
        .collection('carbon_footprints')
        .where('userId', isEqualTo: userId);

    if (frequency != null) {
      query = query.where('frequency', isEqualTo: frequency);
    }

    return query
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => CarbonFootprint.fromMap(doc.data() as Map<String, dynamic>))
            .toList());

  }

// Get total carbon footprint for a user, optionally filtered by frequency
  Future<double> getTotalUserCarbonFootprint(String userId, {String? frequency}) async {
    Query query = _firestore
        .collection('carbon_footprints')
        .where('userId', isEqualTo: userId);

    if (frequency != null) {
      query = query.where('frequency', isEqualTo: frequency);
    }

    final snapshot = await query.get();

    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['total'] != null) {
        total += (data['total'] as num).toDouble();
      }
    }
    return total;
  }




  // Add a completed challenge
  Future<void> completeChallenge(String uid, String challengeName) async {
    await _firestore.collection('users').doc(uid).update({
      'completedChallenges': FieldValue.arrayUnion([challengeName]),
      'challengesCompleted': FieldValue.increment(1),
      'currentChallenges.$challengeName': false,
    });
  }

  // Start a challenge
  Future<void> startChallenge(String uid, String challengeName) async {
    await _firestore.collection('users').doc(uid).update({
      'currentChallenges.$challengeName': true,
    });
  }

  // Bookmark product
  Future<void> bookmarkProduct(String uid, String productId) async {
    await _firestore.collection('users').doc(uid).update({
      'bookmarkedProducts': FieldValue.arrayUnion([productId]),
    });
  }

  // Save recipe
  Future<void> saveRecipe(String uid, String recipeId) async {
    await _firestore.collection('users').doc(uid).update({
      'savedRecipes': FieldValue.arrayUnion([recipeId]),
    });
  }
}
