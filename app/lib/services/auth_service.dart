import 'package:app/exceptions/auth_exception.dart';
import 'package:app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in
  Future<User?> signIn(String email, String password) async {
    if (!isValidEmail(email)) {
      throw AuthException('Please enter a valid email address.');
    }

    if (!isValidPassword(password)) {
      throw AuthException('Password must be at least 6 characters.');
    }

    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthException('No user found for that email.');
        case 'wrong-password':
          throw AuthException('Incorrect password.');
        case 'invalid-email':
          throw AuthException('Invalid email address.');
        default:
          throw AuthException('Login failed. Please try again.');
      }
    } catch (e) {
      throw AuthException('An unexpected error occurred.');
    }
  }


  // Register
  Future<User?> register(String name,String email, String password) async {
    if (!isValidName(name)) {
      throw AuthException('Please enter a valid name.');
    }

    if (!isValidEmail(email)) {
      throw AuthException('Please enter a valid email address.');
    }

    if (!isValidPassword(password)) {
      throw AuthException('Password must be at least 6 characters long.');
    }

    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await result.user?.updateDisplayName(name);
      await result.user?.reload();
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('This email is already in use.');
        case 'invalid-email':
          throw AuthException('The email address is invalid.');
        case 'weak-password':
          throw AuthException('The password is too weak.');
        default:
          throw AuthException('Registration failed. Please try again.');
      }
    } catch (e) {
      throw AuthException('An unexpected error occurred.');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check current user
  User? get currentUser => _auth.currentUser;
}
