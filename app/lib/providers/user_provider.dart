import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// FirebaseAuth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final uidProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.uid;
});

// Current user stream provider
  final currentUserProvider = StreamProvider<User?>((ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return firebaseAuth.authStateChanges();
  });
