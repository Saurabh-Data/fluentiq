import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class DatabaseService {
  final FirestoreService _firestoreService = FirestoreService();

  // Add a user to the database
  Future<void> createUser(String userId, String name, String email) async {
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'created_at': FieldValue.serverTimestamp(),
    };
    await _firestoreService.addUser(userId, userData);
  }

  // Get user details
  Future<Map<String, dynamic>?> readUser(String userId) async {
    return await _firestoreService.getUser(userId);
  }

  // Update user details
  Future<void> updateUser(String userId, String name, String email) async {
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _firestoreService.updateUser(userId, userData);
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    await _firestoreService.deleteUser(userId);
  }
}
