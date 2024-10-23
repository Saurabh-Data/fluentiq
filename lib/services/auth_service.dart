import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print('Error signing in: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return snapshot.data() as Map<String, dynamic>;
        } else {
          print('User profile does not exist');
          return null;
        }
      } else {
        print('No user is currently signed in');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a user profile in Firestore
      await _firestore.collection('users').doc(result.user?.uid).set({
        'email': email,
        // Add any additional user information here
      });

      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print('Error signing up: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
