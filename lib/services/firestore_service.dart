import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new user to Firestore
  Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
      throw Exception('Failed to add user'); // Optionally, throw an exception for higher-level error handling
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _db.collection('users').doc(userId).get(); // Ensure proper type safety here

      if (doc.exists) {
        return doc.data(); // Returns the Map<String, dynamic> data
      } else {
        print('User not found');
        return null; // Return null if user does not exist
      }
    } catch (e) {
      print('Error getting user: $e');
      return null; // Return null in case of error
    }
  }

  // Update user data in Firestore
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).update(userData);
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user');
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }
}
