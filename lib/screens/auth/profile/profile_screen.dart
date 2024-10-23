import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String email = "Loading...";
  String avatarUrl = "";
  bool isEditing = false;
  bool isLoading = true;
  File? _imageFile; // For storing selected avatar image

  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        DocumentSnapshot userData = await _firestore.collection('users').doc(uid).get();

        if (userData.exists) {
          setState(() {
            userName = userData['name'] ?? "No name available";
            email = userData['email'] ?? "No email available";
            avatarUrl = userData['avatarUrl'] ?? "";
            _nameController.text = userName;
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            userName = "User data not found";
            email = "Email not available";
            isLoading = false; // Stop loading
          });
        }
      } else {
        setState(() {
          userName = "No user signed in";
          email = "No email available";
          isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userName = "Error loading data";
        email = "Error loading email";
        isLoading = false; // Stop loading
      });
    }
  }

  // Pick avatar image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Upload avatar image to Firebase Storage
  Future<String?> _uploadAvatar() async {
    if (_imageFile == null) return null;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
       // Reference ref = _storage.ref().child('avatars/$uid.png');
        //UploadTask uploadTask = ref.putFile(_imageFile!);
        //TaskSnapshot snapshot = await uploadTask;
       // String downloadUrl = await snapshot.ref.getDownloadURL();
       // return downloadUrl;
      }
    } catch (e) {
      print('Error uploading avatar: $e');
    }
    return null;
  }

  // Save profile data to Firestore
  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        String? avatarUrl = await _uploadAvatar();

        // Update Firestore with the new user data
        await _firestore.collection('users').doc(uid).update({
          'name': _nameController.text,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
        });

        setState(() {
          userName = _nameController.text;
          if (avatarUrl != null) {
            this.avatarUrl = avatarUrl;
          }
          isEditing = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error saving profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // App bar title
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage, // Select image when tapped
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) // Show selected image
                      : avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl) // Show avatar from Firebase
                      : AssetImage('assets/default_avatar.png') as ImageProvider, // Fallback to default avatar
                ),
              ),
              const SizedBox(height: 20),
              if (isEditing)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                )
              else
                ListTile(
                  leading: Icon(Icons.person, size: 40),
                  title: Text(
                    'Name: $userName',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ListTile(
                leading: Icon(Icons.email, size: 40),
                title: Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              if (isEditing)
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  child: const Text('Edit Profile'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
